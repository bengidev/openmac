#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>

using namespace metal;

static float openMacHash(float2 point) {
    return fract(sin(dot(point, float2(127.1, 311.7))) * 43758.5453123);
}

static float openMacNoise(float2 point) {
    float2 cell = floor(point);
    float2 local = fract(point);
    float2 curve = local * local * (3.0 - 2.0 * local);

    float bottomLeft = openMacHash(cell);
    float bottomRight = openMacHash(cell + float2(1.0, 0.0));
    float topLeft = openMacHash(cell + float2(0.0, 1.0));
    float topRight = openMacHash(cell + float2(1.0, 1.0));

    return mix(
        mix(bottomLeft, bottomRight, curve.x),
        mix(topLeft, topRight, curve.x),
        curve.y
    );
}

static float openMacFBM(float2 point) {
    float value = 0.0;
    float amplitude = 0.52;

    for (int octave = 0; octave < 5; octave++) {
        value += amplitude * openMacNoise(point);
        point = point * 2.04 + float2(11.73, 7.91);
        amplitude *= 0.48;
    }

    return value;
}

static float openMacEllipse(float2 point, float2 center, float2 radius, float power) {
    float2 shifted = (point - center) / radius;
    return exp(-dot(shifted, shifted) * power);
}

static float openMacSoftBeam(float2 point, float y, float width, float spread) {
    float vertical = exp(-pow(abs(point.y - y) / width, 1.42));
    float horizontal = exp(-point.x * point.x * spread);
    return vertical * horizontal;
}

static float openMacMovingRibbon(float2 point, float time, float y, float thickness, float speed, float phase) {
    float wave = sin(point.x * 1.16 + time * speed + phase) * 0.052;
    wave += sin(point.x * 2.38 - time * speed * 0.68 + phase * 1.71) * 0.025;
    wave += (openMacFBM(point * 1.34 + float2(time * 0.048, phase * 0.31)) - 0.5) * 0.048;

    float band = exp(-pow(abs((point.y - y) - wave) / thickness, 1.22));
    float taper = exp(-point.x * point.x * 0.34);
    float pulse = 0.76 + 0.24 * sin(time * (abs(speed) * 0.58 + 0.34) + phase + point.x * 0.72);

    return band * taper * pulse;
}

static float openMacSoftEmbers(float2 uv, float2 point, float time, float mask) {
    float2 drift = float2(time * 0.026, -time * 0.040);
    drift.x += sin(time * 0.37 + uv.y * 8.0) * 0.006;
    float2 grid = (uv + drift) * float2(178.0, 58.0);
    float2 cell = floor(grid);
    float2 local = fract(grid) - 0.5;

    float seed = openMacHash(cell);
    float2 jitter = float2(
        openMacHash(cell + float2(19.1, 3.7)),
        openMacHash(cell + float2(5.3, 31.9))
    ) - 0.5;

    float radius = mix(0.028, 0.072, openMacHash(cell + 8.0));
    float particle = smoothstep(radius, 0.0, length(local - jitter * 0.46));
    float active = smoothstep(0.982, 0.999, seed);
    float twinkle = 0.55 + 0.45 * sin(time * 1.45 + seed * 23.0 + point.x * 0.8);
    float safeCenter = 1.0 - openMacEllipse(point, float2(0.0, -0.04), float2(0.78, 0.24), 1.8) * 0.55;

    return particle * active * twinkle * mask * safeCenter;
}

static float openMacMistParticles(float2 uv, float2 point, float time, float mask) {
    float2 grid = (uv + float2(-time * 0.018, time * 0.020 + sin(time * 0.30 + uv.x * 6.0) * 0.005)) * float2(88.0, 28.0);
    float2 cell = floor(grid);
    float2 local = fract(grid) - 0.5;
    float seed = openMacHash(cell + 41.0);
    float particle = smoothstep(0.045, 0.0, length(local));
    float active = smoothstep(0.945, 1.0, seed);
    float fade = 1.0 - smoothstep(0.04, 0.36, abs(point.y + 0.12));

    return particle * active * mask * fade * 0.32;
}

static float openMacDataStreaks(float2 uv, float2 point, float time, float mask) {
    float column = floor(uv.x * 128.0);
    float seed = openMacHash(float2(column, 17.0));
    float active = smoothstep(0.965, 1.0, seed);
    float scan = openMacNoise(float2(column * 0.17, uv.y * 10.0 + time * 0.34 + seed * 5.0));
    float segments = smoothstep(0.72, 1.0, scan);
    float width = smoothstep(0.50, 0.46, abs(fract(uv.x * 128.0) - 0.5));
    float titleSafe = 1.0 - openMacEllipse(point, float2(0.0, -0.06), float2(0.78, 0.24), 1.0) * 0.70;

    return active * segments * width * mask * titleSafe * 0.12;
}

static float3 openMacToneMap(float3 color) {
    color = max(color, float3(0.0));
    color = color / (float3(1.0) + color * 0.82);
    color = pow(color, float3(0.88));
    return color;
}

[[ stitchable ]] half4 openMacLavaAtmosphere(
    float2 position,
    float2 size,
    float time,
    half4 peach,
    half4 cream,
    half4 orange,
    half4 coral,
    half4 red,
    half4 burntRed,
    half4 deep
) {
    float2 safeSize = max(size, float2(1.0, 1.0));
    float2 uv = position / safeSize;
    float aspect = safeSize.x / safeSize.y;
    float2 point = float2((uv.x - 0.5) * 2.0 * aspect, (0.5 - uv.y) * 2.0);

    float breathe = 0.92 + 0.08 * sin(time * 0.76);
    float shimmer = 0.5 + 0.5 * sin(time * 1.08 + 1.2);
    float energyPulse = 0.88 + 0.12 * sin(time * 1.34 + point.x * 0.42);

    float2 flowPoint = point;
    flowPoint.x += (openMacFBM(point * 0.72 + float2(time * 0.052, -time * 0.028)) - 0.5) * 0.20;
    flowPoint.y += (openMacFBM(point.yx * 0.96 + float2(-time * 0.034, time * 0.046)) - 0.5) * 0.11;
    flowPoint.x += sin(point.y * 2.20 + time * 0.44) * 0.026;
    flowPoint.y += sin(point.x * 1.32 - time * 0.39) * 0.018;

    float chamber = openMacEllipse(flowPoint, float2(-0.14, -0.08), float2(1.45 * aspect, 0.66), 0.82);
    float upperSmoke = openMacEllipse(flowPoint, float2(0.18, 0.38), float2(1.26 * aspect, 0.46), 1.12);
    float lowerEmber = openMacEllipse(flowPoint, float2(0.02, -0.44), float2(1.05 * aspect, 0.34), 1.28);
    float core = openMacEllipse(flowPoint, float2(0.00, -0.28), float2(0.62 * aspect, 0.16 * breathe), 2.12);
    float hotCore = openMacEllipse(flowPoint, float2(0.00, -0.30), float2(0.24 * aspect, 0.054), 3.55);
    float iconAura = openMacEllipse(flowPoint, float2(0.00, 0.30), float2(0.28 * aspect, 0.20), 1.95);

    float activeRibbon = openMacMovingRibbon(flowPoint, time, -0.31, 0.066 + shimmer * 0.016, 0.82, 0.0);
    float upperRibbon = openMacMovingRibbon(flowPoint, time, -0.13, 0.048, -0.62, 2.15) * 0.42;
    float lowerRibbon = openMacMovingRibbon(flowPoint, time, -0.48, 0.074, 0.54, 4.65) * 0.50;
    float kineticRibbons = activeRibbon + upperRibbon + lowerRibbon;
    float currentWake = smoothstep(
        0.62,
        0.95,
        openMacFBM(flowPoint * float2(1.10, 2.00) + float2(time * 0.075, -time * 0.036))
    ) * chamber * 0.32;

    float mainBeam = max(openMacSoftBeam(flowPoint, -0.31, 0.082 + shimmer * 0.010, 0.68), activeRibbon * 0.86);
    float ghostBeam = openMacSoftBeam(flowPoint, -0.06, 0.030 + shimmer * 0.008, 0.42) * 0.22;
    float innerHorizon = max(openMacSoftBeam(flowPoint, -0.48, 0.11, 1.20) * 0.34, lowerRibbon * 0.28);

    float atmosphere = openMacFBM(flowPoint * 1.22 + float2(time * 0.044, -time * 0.030));
    float fineAtmosphere = openMacFBM(flowPoint * 3.20 + float2(-time * 0.064, time * 0.040));
    float atmosphereMask = clamp(chamber * (0.48 + atmosphere * 0.28) + core * 0.50 + mainBeam * 0.34 + kineticRibbons * 0.22, 0.0, 1.0);

    float titleSafe = openMacEllipse(point, float2(0.0, -0.05), float2(0.92 * aspect, 0.26), 1.45);
    float textPocket = 1.0 - titleSafe * 0.54;

    float embers = openMacSoftEmbers(uv, point, time, atmosphereMask) * 0.66;
    float mistDots = openMacMistParticles(uv, point, time, atmosphereMask) * 0.44;
    float streaks = openMacDataStreaks(uv, point, time, atmosphereMask) * 0.62;
    float grain = (openMacHash(floor(position * 0.34 + time * 5.0)) - 0.5) * 0.006;

    float3 deepColor = float3(deep.r, deep.g, deep.b);
    float3 burntColor = float3(burntRed.r, burntRed.g, burntRed.b);
    float3 redColor = float3(red.r, red.g, red.b);
    float3 coralColor = float3(coral.r, coral.g, coral.b);
    float3 orangeColor = float3(orange.r, orange.g, orange.b);
    float3 peachColor = float3(peach.r, peach.g, peach.b);
    float3 creamColor = float3(cream.r, cream.g, cream.b);

    float3 baseBlack = deepColor * 0.30;
    float3 color = baseBlack;

    color += burntColor * chamber * (0.32 + atmosphere * 0.11);
    color += redColor * (upperSmoke * 0.13 + lowerEmber * 0.22 + fineAtmosphere * chamber * 0.020 + currentWake * 0.08);
    color += coralColor * (mainBeam * 0.40 + core * 0.30 + innerHorizon * 0.14 + kineticRibbons * 0.16);
    color += orangeColor * (core * 0.58 + hotCore * 0.40 + lowerEmber * 0.10 + iconAura * 0.15 + kineticRibbons * 0.24 + currentWake * 0.12) * energyPulse;
    color += peachColor * (hotCore * 0.42 + embers * 0.52 + mistDots * 0.10 + activeRibbon * 0.16);
    color += creamColor * (pow(hotCore, 2.1) * 0.20 + embers * 0.36 + streaks * 0.16 + pow(max(activeRibbon, 0.0), 2.0) * 0.08);

    color *= textPocket;
    color += orangeColor * ghostBeam * (1.0 - titleSafe * 0.80) * (0.82 + shimmer * 0.18);
    color += creamColor * max(grain, 0.0);

    float2 edge = abs(uv - 0.5) * 2.0;
    float vignette = smoothstep(1.30, 0.20, length(point * float2(0.48, 0.78)));
    float verticalCurtain = smoothstep(0.02, 0.22, uv.y) * smoothstep(0.98, 0.78, uv.y);
    float sideCurtain = smoothstep(0.00, 0.10, uv.x) * smoothstep(1.00, 0.90, uv.x);
    float innerEdgeGlow = smoothstep(0.92, 1.0, max(edge.x, edge.y)) * atmosphereMask * 0.035;

    color = mix(baseBlack * 0.62, color, clamp(vignette * verticalCurtain * sideCurtain, 0.0, 1.0));
    color += orangeColor * innerEdgeGlow * 0.72;
    color = openMacToneMap(color * 1.18);

    return half4(half3(color), 1.0);
}
