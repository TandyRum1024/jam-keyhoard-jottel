/*
    Post processing : CRT screen filter
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
    Post processing : CRT screen filter
    ZIK@MMXX
*/
// #define acid
#define PI 3.14159265359

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float uTime; // time
uniform float uShadowmaskIntensity; // intensity of shadow mask effect
uniform float uBrightness;      // brightness boost
uniform float uContrast;        // contrast
uniform sampler2D uTexNoise;    // noise texture
uniform sampler2D uTexRainbow;  // RGB tint texture for chromatic aberration
uniform sampler2D uTexShadowmask; // shadow mask for CRT effect
uniform vec2 uScreenTexelSize;  // size of single texel on surface that's being drawn to
uniform vec2 uNoiseTexelSize;   // size of single texel on noise texture
uniform vec2 uShadowmaskTexelSize; // size of single texel on shadow mask texture

// Samples noise and returns float with range of [0..1]
float noise (vec2 uv)
{
    return texture2D(uTexNoise, fract(uv / uScreenTexelSize * uNoiseTexelSize + vec2(uTime * 32.0))).r;
}

// Samples shadow mask
vec3 sampleShadowmask (vec2 uv)
{
    const float shadowmaskuvscale = 6.0;
    return mix(vec3(1.0), texture2D(uTexShadowmask, fract(uv / uScreenTexelSize * uShadowmaskTexelSize * shadowmaskuvscale)).rgb, uShadowmaskIntensity);
}

// Samples rainbow tint
vec3 sampleRainbowtint (vec2 uv, float invscale)
{
    // domain warp the uv
    const float warpintensity = 0.1;
    uv.x += sin(uv.y * 2.0 * PI + uTime) * warpintensity;
    uv.y += cos(uv.x * 3.0 * PI + 0.5 * PI + uTime) * warpintensity;
    
    // scale the uv
    uv *= invscale;
    
    // haha plasma machine go brrbrbrbrbrbhksfdagfdjkfsda;ll121!!!!!31'223k123k;l123
    // idea from https://www.shadertoy.com/view/Md23DV
    vec4 waves = vec4(
        sin(uv.x + uTime),
        sin(uv.y + uTime),
        sin(uv.x + uv.y + uTime),
        sin(length(0.5 - uv) + uTime)
        );
    float plasma = (waves.x + waves.y + waves.z + waves.w);
    return vec3(sin(plasma), sin(plasma + PI), sin(plasma + PI * 0.5)) * 0.5 + 0.5;
}

// Applies power curve for contrast of value
// https://forum.unity.com/threads/shader-function-to-adjust-texture-contrast.457635/
vec3 applyColourAdjustment (vec3 col, float contrast, float brightness)
{
    col = clamp(col + brightness, 0.0, 1.0);
    return pow(abs(col * 2.0 - 1.0), vec3(1.0 / max(contrast, 0.0001))) * sign(col - 0.5) + 0.5;
}

void main()
{
    vec2 uv = v_vTexcoord;
    vec3 final = v_vColour.rgb * texture2D( gm_BaseTexture, uv ).rgb;
    float dithernoise = noise(uv);
    
    /// Apply colour bleeding
    float bleedamp  = 0.35; // amplitude / mix intensity of colourbleed
    float bleedsize = 64.0; // colourbleed's size
    vec3 bleedtreshold = vec3(0.4, 0.5, 0.3);  // minimum threshold value of colourbleed
    vec3 bleedtint     = vec3(1.0, 0.8, 0.9); // colourbleed's tint
    vec2 bleeduvoffset = vec2(uScreenTexelSize.x * -bleedsize * (dithernoise - 0.3), 0.0); // uv offset for colour bleed
    // (get neighbor's rgb colour)
    vec3 neighbor = texture2D(gm_BaseTexture, uv + bleeduvoffset).rgb;
    // (calculate colourbleed's final intensity from rgb colour and add to final colour)
    float finalluma = (final.r + final.g + final.b) / 3.0;
    vec3 neighbormixfactor = smoothstep(bleedtreshold, vec3(0.9), neighbor) * (smoothstep(1.0, 0.0, finalluma) * 0.8 + 0.2);
    final += neighbor * neighbormixfactor * bleedamp * bleedtint;
    // (saturate)
    final = clamp(final, 0.0, 1.0);
    
    /// Apply screen tint
    final.r *= mix(0.85, 1.1, uv.y);
    final.b *= mix(0.95, 1.2, abs(uv.x - 0.5) * 2.0);
    
    // (dynamic tint)
    float dynamictintintensity = 0.1;
    vec3 rainbowtint = mix(vec3(1.0), sampleRainbowtint(uv, 10.0), dynamictintintensity);
    final *= rainbowtint;
    
    /// Apply scanline and shadowmask
    const float scanlineintensity = 0.6;
    // const float scanlineblur = 1.0;
    float scanlinenum = (1.0 / uScreenTexelSize.y) / 4.0;
    float scanline = mix(1.0 - scanlineintensity, 1.0, abs(0.5 - fract(uv.y * scanlinenum)) * 2.0);
    vec3 shadowmask = sampleShadowmask(uv);
    final *= shadowmask * scanline;
    
    /// Apply constrast & brightness
    final = applyColourAdjustment(final, uContrast, uBrightness);
    
    /// Apply vignette + film grain
    finalluma = (final.r + final.g + final.b) / 3.0;
    
    const vec2 grainIntensity = vec2(0.05, 0.1); // min/max grain intensity
    const float vignetteSize = 0.02;
    float centerDist = smoothstep(0.5, 0.7, length(vec2(0.5) - uv));
    float centerDistVignette = max(
        smoothstep(0.7 - vignetteSize, 0.7, length(vec2(0.5) - uv)),
        smoothstep(0.5 - vignetteSize, 0.5, max(abs(0.5 - uv.x), abs(0.5 - uv.y)))
        );
    
    float filmgrain  = mix(grainIntensity.x, grainIntensity.y, centerDist) * smoothstep(1.0, 0.0, finalluma);
    final.rgb *= mix(1.0, 0.0, centerDistVignette);
    final.rgb += vec3(dithernoise, noise(uv.yx), noise(vec2(1.0 - uv.x, uv.y))) * filmgrain;
    
    #ifdef acid
    final.rgb = rainbowtint;
    #endif
    
    gl_FragColor = vec4(final, 1.0); // v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
}
