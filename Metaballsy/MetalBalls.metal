//
//  MetalBalls.metal
//  Metaballsy
//
//  Created by Ilya Nikokoshev on 08/06/15.
//  Copyright (c) 2015 ilyan. All rights reserved.
//

using namespace metal;
#include <metal_math>
#include <metal_geometric>

struct ColoredVertex
{
    float4 position [[position]];
    float4 color;
    float4 vector1;
    float4 vector2;
};


vertex ColoredVertex vertex_main(constant float4 *position [[buffer(0)]],
                                 constant float4 *color [[buffer(1)]],
                                 uint vid [[vertex_id]])
{
    ColoredVertex vert;
    vert.position = position[vid];
    vert.color = color[vid];
    vert.vector1 = position[vid];
    vert.vector2 = position[vid];
    vert.vector1[3] = 0;
    vert.vector2[3] = 0;
    
    vert.vector2[1] +=0.5;
    return vert;
}

fragment float4 fragment_main(ColoredVertex vert [[stage_in]])
{
    float4 color = vert.color;
    float dist1 = length_squared(vert.vector1);
    float dist2 = length_squared(vert.vector2);

    if (dist1 < 0.01 || dist2 < 0.01) {
        color[0] = 0;
        color[1] = 0;
        color[2] = 0;
    }
    
    return color;
}