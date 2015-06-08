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
    float4 vector1;
    float4 vector2;
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
    vert.vector1 = position[vid];
    vert.vector2 = position[vid];
    vert.vector2[1] +=0.5;
    return vert;
}

fragment float4 fragment_main(ColoredVertex vert [[stage_in]])
{
    float4 color = vert.color;
    float dist1 = vert.vector1[0] * vert.vector1[0] + vert.vector1[1] * vert.vector1[1];
    float dist2 = vert.vector2[0] * vert.vector2[0] + vert.vector2[1] * vert.vector2[1];
    if (dist1 < 0.01 || dist2 < 0.01) {
        color[0] = 0;
        color[1] = 0;
        color[2] = 0;
    }
    return color;
}