/*
    Post processing : CRT distortion & border effect
    ZIK@MMXX
*/
attribute vec3 in_Position;                  // (x,y,z)
//attribute vec3 in_Normal;                  // (x,y,z)     unused in this shader.	
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    vec4 object_space_pos = vec4( in_Position.x, in_Position.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
}

//######################_==_YOYO_SHADER_MARKER_==_######################@~//
/*
    Post processing : CRT distortion & border effect
    ZIK@MMXX
*/
// #define lightonly
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float uTime; // time
uniform sampler2D uTexNoise;    // noise texture
uniform sampler2D uTexRainbow;  // RGB tint texture for chromatic aberration
uniform vec2 uScreenTexelSize;  // size of single texel on surface that's being drawn to
uniform vec2 uNoiseTexelSize;   // size of single texel on noise texture

// Samples noise and returns float with range of [0..1]
float noise (vec2 uv)
{
    return texture2D(uTexNoise, fract(uv / uScreenTexelSize * uNoiseTexelSize + vec2(uTime * 32.0))).r;
}

// Applies power curve for contrast of value
// https://forum.unity.com/threads/shader-function-to-adjust-texture-contrast.457635/
vec3 applyContrast (vec3 col, float contrast)
{
    return pow(abs(col * 2.0 - 1.0), vec3(1.0 / max(contrast, 0.0001))) * sign(col - 0.5) + 0.5;
}

// Distorts UV like a CRT monitor
vec2 getCRTUV (vec2 uv, float distortion)
{
    vec2 centerDelta = vec2(0.5) - uv;
    float centerDist = length(centerDelta);
    float distortfactor = centerDist;
    uv -= 0.5;
    uv *= mix(1.0, 1.0 + distortion, distortfactor);
    uv += 0.5;
    return uv;
}

vec3 textureCRT_Border (sampler2D tex, vec2 uv, float distortion)
{
    float dithernoise = noise(uv);
    
    vec2 centerDelta = vec2(0.5) - uv;
    float centerDist = length(centerDelta);
    float distortfactor = centerDist;
    uv = getCRTUV(uv, distortion);
    
    // calculate delta between center and warped UV
    vec2 warpedCenterDelta = vec2(0.5) - uv;
    float warpedCenterDist = length(warpedCenterDelta);
    
    // UV mirror trick by https://blog.nobel-joergensen.com/2011/09/17/mirror-texture-coordinates-in-unity/
    // apply UV mirroring AFTER we've calculated the center delta to prevent the mixing values being mirrored too
    uv = fract(uv * 0.5) * 2.0;
    uv = vec2(1.0) - abs(uv - vec2(1.0));
    
    // calculate 'border' distortion
    const float borderdistortamp = 0.4;
    float bordercornerfade = 1.0 - max(abs(0.5 - uv.x) + abs(0.5 - uv.y) - 0.75, 0.0) * 2.0;
    float borderfade = 1.0; // smoothstep(0.95, 1.0, fadefactor);
    float borderdistortfactor = smoothstep(0.4, 0.7, distortfactor) + max(max(abs(0.5 - uv.x), abs(0.5 - uv.y)) - 1.0, 0.0); // smoothstep(0.0, 0.7, distortfactor);
    uv -= 0.5;
    uv *= mix(1.0, 1.0 - distortion, borderfade * borderdistortfactor * borderdistortamp);
    uv += 0.5;
    
    // apply blurring on the 'border' side of the uv
    vec2 blurfactor = uScreenTexelSize * 8.0 * smoothstep(0.4, 0.625, warpedCenterDist);
    uv += blurfactor * vec2(dithernoise * 2.0 - 1.0, noise(uv.yx) * 2.0 - 1.0) * borderfade;
    
    // mixing factor of screen border 'reflection' to pitch black
    vec2 warpedCenterDeltaMirrored = vec2(0.5) - uv;
    const float fadeborderbegin = 0.4;
    const float fadeborderend   = 0.5;
    float fadefactorBorders = max(
        smoothstep(fadeborderbegin, fadeborderend, abs(warpedCenterDeltaMirrored.x)),
        smoothstep(fadeborderbegin, fadeborderend, abs(warpedCenterDeltaMirrored.y))
    ) * bordercornerfade;
    
    return mix(vec3(0.0), texture2D(tex, uv).rgb, fadefactorBorders);
}

vec3 textureCRT (sampler2D tex, vec2 uv, float distortion)
{
    float dithernoise = noise(uv);
    
    vec2 centerDelta = vec2(0.5) - uv;
    float centerDist = length(centerDelta);
    float distortfactor = centerDist;
    uv = getCRTUV(uv, distortion);
    
    vec3 final = texture2D(tex, uv).rgb;
    return final;
}

void main()
{
    const float screenDistortFactor = 0.25;
    vec4 final = vec4(vec3(1.0, 1.0, 0.0), 1.0);
    vec2 uv    = v_vTexcoord;
    vec2 crtuv = getCRTUV(uv, screenDistortFactor);
    
    float dithernoise = noise(uv);
    
    // calculate delta between center and warped UV
    vec2 warpedCenterDelta = vec2(0.5) - crtuv;
    float warpedCenterDist = length(warpedCenterDelta);
    
    // mixing factor of screen texture to borders
    // apply smoothstep() to make the screen-to-border transition 'smooth'
    const float fadesmoothfactor = 0.01;
    float fadefactor = max(
        smoothstep(0.5 - fadesmoothfactor, 0.5, abs(warpedCenterDelta.x)),
        smoothstep(0.5 - fadesmoothfactor, 0.5, abs(warpedCenterDelta.y))
    );
    
    // CRT distortion + border reflection effect
    const float crtBorderAmp = 0.3;
    vec3 crtScreen = textureCRT(gm_BaseTexture, uv, screenDistortFactor);
    vec3 crtBorder = textureCRT_Border(gm_BaseTexture, uv, screenDistortFactor) * crtBorderAmp;
    final.rgb = v_vColour.rgb * mix(crtScreen, crtBorder, fadefactor);
    
    #ifdef lightonly
        final.rgb = vec3(0.0);
    #endif
    
    // Subtle light
    float crtLightAmp = 0.1;
    vec2 crtLightOff = vec2(0.2, -0.2);
    float crtLightDist = distance(getCRTUV(uv - crtLightOff, screenDistortFactor), vec2(0.5)) + dithernoise * 0.1;
    crtLightDist = smoothstep(0.3, 0.0, crtLightDist);
    
    float crtLightSharpness = 32.0;
    float crtLight = pow(crtLightDist, crtLightSharpness);
    
    final.rgb += vec3(0.9, 0.75, 1.0) * crtLightDist * crtLightAmp;
    
    gl_FragColor = final;
}

