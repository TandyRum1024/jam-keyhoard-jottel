/*
    Post processing : final effects
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
    Post processing : final effects
    ZIK@MMXX
*/
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float uTime; // time
uniform sampler2D uTexNoise;    // noise texture
uniform sampler2D uTexRainbow;  // RGB tint texture for chromatic aberration
uniform vec2 uScreenTexelSize;  // size of single texel on surface that's being drawn to
uniform vec2 uNoiseTexelSize;   // size of single texel on noise texture

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

// Samples noise and returns float with range of [0..1]
float noise (vec2 uv)
{
    return texture2D(uTexNoise, fract(floor(uv / uScreenTexelSize) * uNoiseTexelSize + vec2(uTime * 32.0))).r;
}

vec3 sampleScreen (vec2 uv, float zoom, float distortion)
{
    // float distortion = zoom * 0.25;
    vec2 centerDelta = vec2(0.5) - uv;
    float centerDist = length(centerDelta);
    float distortfactor = centerDist;
    uv -= 0.5;
    uv *= mix(1.0, 1.0 + distortion, distortfactor);
    uv /= zoom;
    uv += 0.5;
    
    return texture2D(gm_BaseTexture, uv).rgb;
}

void main()
{
    vec2 uv = v_vTexcoord;
    vec3 final = texture2D(gm_BaseTexture, uv).rgb;
    float dithernoise = noise(uv);
    
    /// Apply weird horizontal blur
    vec3 glowblur = vec3(0.0);
    const float blurSpread      = 8.0; // 32px blur spread
    const float blurZoomFactor  = 0.3;
    const float blurChromaFactor= 0.75;
    const float blurIteration       = 8.0;
    const float blurIterationStep   = 1.0 / blurIteration;
    const float blurIterationWeight = 1.0 / (blurIteration + 1.0);
    for (float i=0.0; i<=(1.0 - blurIterationStep); i+=blurIterationStep)
    {
        // dither up
        float i_interp = i + blurIterationStep * dithernoise;
        vec2 uvoff = vec2((i_interp - 0.5) * 2.0 * blurSpread * uScreenTexelSize.x, 0.0);
        float zoomoff = ((i_interp - 0.5) * 2.0 * blurZoomFactor);
        
        // calculate 'tint' from rainbow/chromatic aberration lookup texture
        vec3 tint = mix(vec3(1.0), texture2D(uTexRainbow, vec2(i_interp, 0.5)).rgb, blurChromaFactor);
        
        vec3 col = tint * sampleScreen(uv + uvoff, 1.0 - zoomoff, zoomoff).rgb; // texture2D( gm_BaseTexture, v_vTexcoord + uvoff ).rgb;
        glowblur += col * blurIterationWeight;
    }
    
    // Apply w/ bias
    const float blurGlowFactor  = 0.75;
    const vec3 blurGlowMax      = vec3(0.3, 0.425, 0.5);
    final += clamp(glowblur * blurGlowFactor, vec3(0.0), blurGlowMax);
    
    gl_FragColor = v_vColour * vec4(final, 1.0);
}
