/*
    CRT effect
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
    CRT effect
    ZIK@MMXX
*/
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float uTime; // time
uniform sampler2D uTexNoise;    // noise texture
uniform vec2 uScreenTexelSize;  // size of single texel on surface that's being drawn to
uniform vec2 uNoiseTexelSize;   // size of single texel on noise texture

// Samples noise and returns float with range of [0..1]
float noise (vec2 uv)
{
    return texture2D(uTexNoise, fract(uv / uScreenTexelSize * uNoiseTexelSize + vec2(uTime * 32.0))).r;
}

vec4 textureCRT (sampler2D tex, vec2 uv, float distortion)
{
    vec2 centerDelta = vec2(0.5) - uv;
    float centerDist = length(centerDelta); //smoothstep(0.5, 0.7, );
    float distortfactor = centerDist;
    
    uv -= 0.5;
    uv *= mix(1.0, 1.0 + distortness, distortfactor);
    uv += 0.5;
    
    // calculate delta between center and warped UV
    vec2 warpedCenterDelta = vec2(0.5) - uv;
    
    // mixing factor of screen texture to borders
    // apply smoothstep() to make the screen-to-border transition 'smooth'
    const float fadesmoothfactor = 0.01;
    float fadefactor = max(
        smoothstep(0.5 - fadesmoothfactor, 0.5, abs(warpedCenterDelta.x)),
        smoothstep(0.5 - fadesmoothfactor, 0.5, abs(warpedCenterDelta.y))
    );
    
    // UV mirror trick by https://blog.nobel-joergensen.com/2011/09/17/mirror-texture-coordinates-in-unity/
    // apply UV mirroring AFTER we've calculated the center delta to prevent the mixing values being mirrored too
    uv = fract(uv * 0.5) * 2.0;
    uv = vec2(1.0) - abs(uv - vec2(1.0));
    
    // calculate 'border' distortion
    float borderfade = smoothstep(0.95, 1.0, fadefactor);
    float borderdistortfactor = smoothstep(0.0, 0.7, distortfactor);
    uv -= 0.5;
    uv *= mix(1.0, 0.9 - distortness, borderfade * borderdistortfactor);
    uv += 0.5;
    
    // apply blurring on the 'border' side of the uv
    vec2 blurfactor = uScreenTexelSize * 4.0 * smoothstep(0.65, 0.7, distortfactor);
    uv += blurfactor * vec2(noise(uv.xy) * 2.0 - 1.0, noise(uv.yx) * 2.0 - 1.0) * borderfade;
    
    vec2 warpedCenterDeltaMirrored = vec2(0.5) - uv;
    
    // mixing factor of screen border 'reflection' to pitch black
    const float fadeborderbegin = 0.3;
    const float fadeborderend   = 0.4;
    float fadefactorBorders = max(
        smoothstep(fadeborderbegin, fadeborderend, abs(warpedCenterDeltaMirrored.x)),
        smoothstep(fadeborderbegin, fadeborderend, abs(warpedCenterDeltaMirrored.y))
    );
    
    // uv = mix(uv, borderuv, fadefactor);
    fadefactor = max(0.0, fadefactor - fadefactorBorders * 0.3);
    
    return mix(texture2D(gm_BaseTexture, uv), vec4(vec3(0.0), 1.0), fadefactor);
}

void main()
{
    vec2 uv = v_vTexcoord;
    
    
    gl_FragColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
}

