uniform vec2 rectPos;
uniform vec2 rectSize;
uniform vec4 cornerRadius;

uniform vec4 fillColor;
uniform bool drawFill;

uniform vec4  borderColor;
uniform float borderWidth;
uniform float borderAlpha;
uniform bool  smoothBorderTransition;

uniform vec4  shadowColor;
uniform float shadowWidth;
uniform vec2  shadowOffset;
uniform float shadowBlur;

uniform vec2 skew;

float sdRoundedBoxIndividual(vec2 p, vec2 halfSize, vec4 radius)
{
    float r;
    if (p.x < 0.0) {
        r = (p.y < 0.0) ? radius.x : radius.w;
    } else {
        r = (p.y < 0.0) ? radius.y : radius.z;
    }

    r = clamp(r, 0.0, min(halfSize.x, halfSize.y));

    vec2 q = abs(p) - halfSize + r;
    return min(max(q.x, q.y), 0.0) + length(max(q, 0.0)) - r;
}

vec4 toPMA(vec4 c) {
    return vec4(c.rgb * c.a, c.a);
}

vec4 toStraight(vec4 c) {
    if (c.a <= 1e-4) {
        return vec4(0.0);
    }
    c.rgb = min(c.rgb, c.a);
    return vec4(c.rgb / c.a, c.a);
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    vec2 halfSize = rectSize * 0.5;
    vec2 center   = rectPos + halfSize;
    vec2 local    = screen_coords - center;

    vec2 skewedLocal = vec2(
        local.x + local.y * skew.x,
        local.y + local.x * skew.y
    );

    float dOuter = sdRoundedBoxIndividual(skewedLocal, halfSize, cornerRadius);
    float aa = max(fwidth(dOuter), 1e-4);
    float outerMask = 1.0 - smoothstep(0.0, aa, dOuter);

    float bw = clamp(borderWidth, 0.0, min(halfSize.x, halfSize.y));
    float dInner = dOuter + bw;
    float innerMask = 1.0 - smoothstep(0.0, aa, dInner);

    float ringMask = clamp(outerMask - innerMask, 0.0, 1.0);

    vec2 shadowLocal = local - shadowOffset;
    vec2 skewedShadowLocal = vec2(
        shadowLocal.x + shadowLocal.y * skew.x,
        shadowLocal.y + shadowLocal.x * skew.y
    );

    vec2 shadowHalfSize = halfSize + shadowWidth;
    vec4 shadowRadius   = cornerRadius + shadowWidth;
    float dShadow = sdRoundedBoxIndividual(skewedShadowLocal, shadowHalfSize, shadowRadius);

    float blurHalf  = max(shadowBlur, 1e-4);
    float shadowRaw = 1.0 - smoothstep(-blurHalf, blurHalf, dShadow);

    // --- CORREÇÃO: recorte da sombra baseado na opacidade efetiva do fill ---
    // Quando drawFill=false: recorta totalmente (buraco no centro)
    // Quando drawFill=true e fill transparente: recorta proporcionalmente ao alpha
    // Quando drawFill=true e fill opaco: sombra fica escondida sob o shape
    float fillOpacity = drawFill ? fillColor.a : 0.0;
    float shadowMask  = shadowRaw * mix(1.0 - outerMask, 1.0, fillOpacity);

    // --- Shape em Premultiplied Alpha ---
    vec4 pmShadow = toPMA(shadowColor) * shadowMask;
    vec4 pmFill   = toPMA(fillColor);
    vec4 pmBorder = toPMA(vec4(borderColor.rgb, borderColor.a * borderAlpha));

    vec4 pmShape = vec4(0.0);

    if (drawFill) {
        if (smoothBorderTransition) {
            float t = smoothstep(-bw, 0.0, dOuter);
            pmShape = mix(pmFill, pmBorder, t) * outerMask;
        } else {
            pmShape = mix(pmFill, pmBorder, ringMask) * outerMask;
        }
    } else {
        // Sem fill: só a borda (ring)
        pmShape = pmBorder * ringMask;
    }

    // Compositing: Shape SOBRE Sombra (fórmula PMA)
    vec4 finalPMA = pmShape + pmShadow * (1.0 - pmShape.a);

    vec4 finalColor = toStraight(finalPMA);

    return finalColor * color;
}
