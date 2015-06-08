//
//  MetalBalls.metal
//  Metaballsy
//
//  Created by Ilya Nikokoshev on 08/06/15.
//  Copyright (c) 2015 ilyan. All rights reserved.
//

using namespace metal;

struct ColoredVertex
{
    float4 position [[position]];
    float4 color;
    float4 distance;
};

float distance(float4 point, float4 point1, float4 point2) {
    float xcoef = point1[1] - point2[1];
    float ycoef = point2[0] - point1[0];   
    float cons  =  point1[0] * xcoef + point1[1] * ycoef;
    
    float result = point[0] * xcoef + point[1] * ycoef - cons;
    if (result > 0) {
        return result;
    } else {
        return -result;
    }
}

vertex ColoredVertex vertex_main(constant float4 *position [[buffer(0)]],
                                 constant float4 *color [[buffer(1)]],
                                 uint vid [[vertex_id]])
{
    ColoredVertex vert;
    vert.position = position[vid];
    vert.color = color[vid];
    vert.distance = float4(distance(position[vid], position[1], position[2]), 
                           distance(position[vid], position[2], position[0]), 
                           distance(position[vid], position[0], position[1]), 
                           0);
    return vert;
}

fragment float4 fragment_main(ColoredVertex vert [[stage_in]])
{
    float4 color = vert.color;
    float2 center = float2(1000, 1000);
    float dist = (vert.position[0] - center[0]) * (vert.position[0] - center[0]) + 
                 (vert.position[1] - center[1]) * (vert.position[1] - center[1]);
    if (dist < 100 * 100) {
        color[0] = 0;
        color[1] = 0;
        color[2] = 0;
    }
    return color;
}