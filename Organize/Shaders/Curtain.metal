//
//  Curtain.metal
//  Organize
//
//  Created by Yuhao Chen on 1/30/24.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>

using namespace metal;

[[ stitchable ]] half4 curtain(float2 position, SwiftUI::Layer layer, float4 bounds, float2 dragPosition, float foldCount) {
    // The `position` expressed in unit coordinates [0,1].
    float2 uv = position / bounds.zw;

    // The `dragPosition` expressed in unit coordinates [0,1].
    float2 dragUV = dragPosition / bounds.zw;

    // Reveals every row of pixels unformly.
    //
    // 0: The curtain is fully closed.
    // 1: The curtain is fully open.
    //
    // This matches the distance of the drag location to the left edge and thus
    // the location of the user's finger.
    float uniformReveal = saturate(1 - dragUV.x);

    // Abort early if the curtain if fully open.
    if (uniformReveal == 1) return 0;

    // Reveals every row of pixels based on its distance to the drag.
    //
    // We scale `uniformReveal` by multiplying with a Gaussian function that is
    // fed the vertical distance of the current row of pixels to the drag.
    //
    // This results in the row under the finger still being compressed by
    // `revealAmount`, lining up with the users finger.
    //
    // Meanwhile, rows further away "decompress" smoothly, giving the final edge
    // a smooth, bell-curve-like shape.
    //
    // The denominator 0.45 controls how "pointy" the curve is and was determined
    // through trial and error.
    float2 distance = uv - dragUV;
    float localReveal = uniformReveal * exp(-pow(distance.y, 2) / 0.45);

    // For the final compression value, blend between the uniform and local
    // values with a bias towards `curve`.
    //
    // This will make sure that when `uniformReveal` is `1`, `localReveal` will
    // no longer have an effect.
    float compression = mix(localReveal, uniformReveal,  saturate(pow(uniformReveal + 0.15, 1.8)));

    // Scale `uv` horizontally based on `compression`.
    //
    // When the current row of pixels is 0% revealed, `compression` will be 0
    // and thus `uv` will be scaled by `float2(1, 1)`.
    //
    // When the current row of pixels is 50% revealed, `compression` will be 0.5
    // and thus `uv` will be scaled by `float2(2, 1)`.
    //
    // This is the new location at which we will sample `layer`.
    float2 distortedUV = uv * float2(1 / (1 - compression), 1);

    // To create the illusion of the surface of the curtain folding, we need to
    // perform two additional steps.
    //
    // - Move the sample position vertically to create a depth effect as the
    //   material's distance to the camera changes.
    // - Tweak the sampled color to create the illusion of light hitting the
    //   folds.
    //
    // To do this, we model the surface of the scaled material using a wave-like
    // function and calculate its derivative.
    
    // The period of the waves, `1 / p` is the number of folds we'll see.
    float p = 1.0 / foldCount;

    // We don't want the folds evenly distributed across the surface, so we bias
    // them towards the right edge.
    float biasedX = pow(distortedUV.x, 1.2);

    // Scale factor for the lighting and vertical displacement.
    float foldAmount = distortedUV.x * -(cos(compression * M_PI_F) - 1) / 2;

    // A triangle function that models creases in the curtain and its
    // derivative.
    //
    // See https://en.wikipedia.org/wiki/Triangle_wave
    float fold  = 2 * abs(biasedX / p - floor(biasedX / p + 0.5));
    float foldD = sign(sin(2 * M_PI_F * biasedX / p));

    // Displace the y coorindate of the sample location, scaled by the distance
    // to the vertical center of the layer.
    distortedUV.y += foldAmount * fold * (-12 / bounds.w) * (2 * uv.y - 1);

    // The light we're adding or subtracting.
    half4 highlight = 0;

    if (distortedUV.x < 1) {
        highlight += foldAmount * foldD * half4(half3(0.1), 0);
        highlight -= compression * half4(half3(0.1), 0);
    }

    // The new sample position in the coordinate space of `layer`.
    float2 s = distortedUV * bounds.zw;

    // If the surface of the curtain contains high-frequency content such as
    // text, we'll see shimmering artifacts when it gets compressed too tightly.
    //
    // Since `layer` does not seem to support mipmaps, we perform a
    // one-dimensional Gassian blur to use as a low pass filter, then blend
    // between the "crisp" original `color` value and the `blurred` value based
    // on the amount of compression.

    // The sampling offsets of the blur.
    const float offset[5] = {0.0, 1.0, 2.0, 3.0, 4.0};
    // The weights of the blur.
    const float weight[5] = {0.2270270270, 0.1945945946, 0.1216216216, 0.0540540541, 0.0162162162};

    half4 color = layer.sample(s);
    half4 blurred = color * weight[0];

    // Perform the blur.
    for (int i = 1; i < 5; i++) {
        blurred += layer.sample(s + float2(1, 0) * offset[i]) * weight[i];
        blurred += layer.sample(s - float2(1, 0) * offset[i]) * weight[i];
    }

    // Mix, then add highlight.
    return mix(color, blurred, 1.1 * pow(compression, 1.4)) + highlight;
}
