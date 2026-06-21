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


vec4 blendOver(vec4 dst, vec4 src)
{
    float outA = src.a + dst.a * (1.0 - src.a);
    vec3  outRGB = (src.rgb * src.a + dst.rgb * dst.a * (1.0 - src.a)) / max(outA, 1e-5);
    return vec4(outRGB, outA);
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

    vec2 shadowHalfSize   = halfSize + shadowWidth;
    vec4 shadowRadius     = cornerRadius + shadowWidth;
    float dShadow = sdRoundedBoxIndividual(skewedShadowLocal, shadowHalfSize, shadowRadius);

    float blurHalf = max(shadowBlur, 1e-4);
    float shadowMask = 1.0 - smoothstep(-blurHalf, blurHalf, dShadow);

    if (!drawFill) {
        shadowMask *= (1.0 - outerMask);
    }

    vec4 result = vec4(0.0);

    result = blendOver(result, vec4(shadowColor.rgb, shadowColor.a * shadowMask));

    vec4 shapeColor = vec4(0.0);

    if (drawFill) {
        if (smoothBorderTransition) {
            float t = smoothstep(-bw, 0.0, dOuter);
            vec3  rgb = mix(fillColor.rgb, borderColor.rgb, t);
            float a   = mix(fillColor.a,  borderColor.a * borderAlpha, t);
            shapeColor = vec4(rgb, a * outerMask);
        } else {
            vec3  rgb = mix(fillColor.rgb, borderColor.rgb, ringMask);
            float a   = mix(fillColor.a,  borderColor.a * borderAlpha, ringMask);
            shapeColor = vec4(rgb, a * outerMask);
        }
    }

    result = blendOver(result, shapeColor);

    return result * color;
}
