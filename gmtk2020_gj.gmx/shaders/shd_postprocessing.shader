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
// Postprocessing
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform sampler2D uTexDownscaledScreen;
uniform sampler2D uTexBluenoise;
uniform sampler2D uTexRainbow;
uniform float uTime;
uniform vec2 uScreenTexelSize;
uniform vec2 uBluenoiseTexelSize;

float noise (vec2 uv)
{
    return texture2D(uTexBluenoise, fract(uv / uScreenTexelSize * uBluenoiseTexelSize + vec2(uTime * 32.0))).r;
}

vec4 sampleScreen (vec2 uv, float distortness)
{
    float centerDist = length(vec2(0.5) - uv);//smoothstep(0.5, 0.7, );
    uv -= 0.5;
    uv *= mix(1.0, 1.0 + distortness, centerDist);
    uv += 0.5;
    
    if (uv.x < 0.0 || uv.x > 1.0 ||
        uv.y < 0.0 || uv.y > 1.0)
    {
        return vec4(vec3(0.0), 1.0);
    }
    else
    {
        return texture2D(gm_BaseTexture, uv);
    }
}

vec4 sampleDistort (sampler2D tex, vec2 uv, float distortness)
{
    float centerDist = length(vec2(0.5) - uv);//smoothstep(0.5, 0.7, );
    uv -= 0.5;
    uv *= mix(1.0, 1.0 + distortness, centerDist);
    uv += 0.5;
    
    if (uv.x < 0.0 || uv.x > 1.0 ||
        uv.y < 0.0 || uv.y > 1.0)
    {
        return vec4(vec3(0.0), 1.0);
    }
    else
    {
        return texture2D(tex, uv);
    }
}

void main()
{
    const float screenDistortFactor = 0.25;
    
    vec2 uv = v_vTexcoord;
    vec4 final = v_vColour * sampleScreen(uv, screenDistortFactor); // texture2D( gm_BaseTexture, v_vTexcoord );
    vec4 blurred = v_vColour * texture2D( uTexDownscaledScreen, v_vTexcoord );
    
    float uvnoise = noise(uv);
    
    /// Apply weird horizontal blur
    vec3 glowblur = vec3(0.0);
    const float blurSpread      = 16.0; // 32px blur spread
    const float blurZoomFactor  = 0.5;
    const float blurChromaFactor= 0.5;
    const float blurIteration       = 4.0;
    const float blurIterationStep   = 1.0 / blurIteration;
    const float blurIterationWeight = 1.0 / (blurIteration + 1.0);
    for (float i=0.0; i<=(1.0 - blurIterationStep); i+=blurIterationStep)
    {
        // dither up
        float i_interp = i + blurIterationStep * uvnoise;
        vec2 uvoff = vec2((i_interp - 0.5) * 2.0 * blurSpread * uScreenTexelSize.x, 0.0);
        float zoomoff = (i_interp - 0.5) * 2.0 * blurZoomFactor;
        
        // calculate 'tint' from rainbow/chromatic aberration lookup texture
        vec3 tint = mix(vec3(1.0), texture2D(uTexRainbow, vec2(i, 0.5)).rgb, blurChromaFactor);
        
        vec3 col = tint * sampleScreen(v_vTexcoord + uvoff, screenDistortFactor + zoomoff).rgb; // texture2D( gm_BaseTexture, v_vTexcoord + uvoff ).rgb;
        glowblur += col * blurIterationWeight;
    }
    
    // Apply w/ bias
    const float blurGlowFactor  = 0.75;
    const vec3 blurGlowMax      = vec3(0.3, 0.425, 0.5);
    final.rgb += clamp(glowblur * blurGlowFactor, vec3(0.0), blurGlowMax);
    
    /// Apply screen glow effect
    vec3 glow = sampleDistort(uTexDownscaledScreen, uv, screenDistortFactor).rgb;
    float glowLuma = (glow.r + glow.g + glow.b) / 3.0;
    glow *= smoothstep(0.75, 1.0, glowLuma);
    final.rgb += glow * 0.25;
    
    // Saturate
    final.rgb = clamp(final.rgb, 0.0, 1.0);
    final.a = 1.0;
    
    /// Apply screen tint
    final.r *= mix(0.85, 1.1, uv.y);
    final.b *= mix(0.95, 1.2, abs(uv.x - 0.5) * 2.0);
    
    /// Apply vignette + film grain
    float centerDist = smoothstep(0.5, 0.7, length(vec2(0.5) - uv));
    float grainIntensity = mix(0.1, 0.3, centerDist);
    final.rgb *= 1.0 + (uvnoise - 0.5) * 2.0 * grainIntensity;
    final.rgb *= mix(1.0, 0.8, centerDist);
    
    /// Apply scanline effect
    const float scanlineintensity = 0.2;
    const float scanlinenum = 80.0;
    float scanline = mix(1.0 - scanlineintensity, 1.0, smoothstep(0.0, 0.3, abs(0.5 - fract(uv.y * scanlinenum + uTime)) * 2.0));
    final.rgb *= scanline;
    
    // Saturate again
    final.rgb = clamp(final.rgb, 0.0, 1.0);
    final.a = 1.0;
    
    /// DEBUG : Noise UV
    // final.rgb = vec3(mod(floor(uv / uScreenTexelSize), 1.0 / uBluenoiseTexelSize) * uBluenoiseTexelSize, 0.5);
    // final.rgb = vec3(texture2D(uTexBluenoise, fract(uv / uScreenTexelSize * uBluenoiseTexelSize)).r);
    
    gl_FragColor = final;
}

