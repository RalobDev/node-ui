// Uniforms enviados do host (Lua)
extern vec4 outlineColor;
extern float outlineWidth;
extern vec4 shadowColor;
extern vec2 shadowOffset;
extern float shadowOutlineWidth;
extern vec2 textureSize;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    // Calcula o tamanho de um pixel no espaço de textura (UV)
    vec2 texelSize = vec2(1.0) / textureSize;

    // Amostra o pixel original do texto
    vec4 original = Texel(texture, texture_coords);

    // ----------------------------------------------------
    // Passo 1: Máscara de outline do texto original (Circular e Suave)
    // ----------------------------------------------------
    float outlineAlpha = 0.0;
    if (outlineWidth > 0.0) {
        int oWidth = int(ceil(outlineWidth));
        for (int x = -oWidth; x <= oWidth; x++) {
            for (int y = -oWidth; y <= oWidth; y++) {
                // Restrição circular para o outline não ficar quadrado
                if (float(x*x + y*y) <= outlineWidth * outlineWidth) {
                    vec2 offset = vec2(float(x), float(y)) * texelSize;
                    float sampleAlpha = Texel(texture, texture_coords + offset).a;
                    // Mantém o maior alpha para preservar o anti-aliasing original
                    outlineAlpha = max(outlineAlpha, sampleAlpha);
                }
            }
        }
    }

    // ----------------------------------------------------
    // Passo 2: Máscara de silhueta da sombra (Circular e Suave)
    // ----------------------------------------------------
    float shadowAlpha = 0.0;
    vec2 shiftedUV = texture_coords - (shadowOffset * texelSize);
    int sWidth = int(ceil(shadowOutlineWidth));

    for (int x = -sWidth; x <= sWidth; x++) {
        for (int y = -sWidth; y <= sWidth; y++) {
            float d2 = float(x*x + y*y);
            // Executa se sWidth for 0 (silhueta básica) ou se estiver dentro do raio do outline da sombra
            if (shadowOutlineWidth == 0.0 || d2 <= shadowOutlineWidth * shadowOutlineWidth) {
                vec2 offset = vec2(float(x), float(y)) * texelSize;
                float sampleAlpha = Texel(texture, shiftedUV + offset).a;
                shadowAlpha = max(shadowAlpha, sampleAlpha);
            }
        }
    }

    // ----------------------------------------------------
    // Passo 3: Composição matemática de camadas (Alpha Blending Real)
    // ----------------------------------------------------
    // Definimos as cores prontas com seus respectivos alphas misturados
    vec4 cShadow  = vec4(shadowColor.rgb, shadowAlpha * shadowColor.a);
    vec4 cOutline = vec4(outlineColor.rgb, outlineAlpha * outlineColor.a);
    vec4 cText    = original;

    // 1. Blend: Outline por CIMA da Sombra
    float a1 = cOutline.a + cShadow.a * (1.0 - cOutline.a);
    vec3 rgb1 = vec3(0.0);
    if (a1 > 0.0) {
        rgb1 = (cOutline.rgb * cOutline.a + cShadow.rgb * cShadow.a * (1.0 - cOutline.a)) / a1;
    }
    vec4 outlineAndShadow = vec4(rgb1, a1);

    // 2. Blend: Texto Original por CIMA do (Outline + Sombra)
    float a2 = cText.a + outlineAndShadow.a * (1.0 - cText.a);
    vec3 rgb2 = vec3(0.0);
    if (a2 > 0.0) {
        rgb2 = (cText.rgb * cText.a + outlineAndShadow.rgb * outlineAndShadow.a * (1.0 - cText.a)) / a2;
    }
    vec4 finalColor = vec4(rgb2, a2);

    // ----------------------------------------------------
    // Passo 4: Multiplicação pela cor do vértice do LÖVE (Tinting)
    // ----------------------------------------------------
    return finalColor * color;
}
