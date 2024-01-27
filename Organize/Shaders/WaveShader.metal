//
//  WaveShader.metal
//  Organize
//
//  Created by Yuhao Chen on 1/27/24.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]] float2 wave(float2 position, float time, float speed, float frequency, float amplitude) {
    float positionY = position.y + sin((time * speed) + (position.x / frequency)) * amplitude;
    return float2(position.x, positionY);
}
