//
//  MetalBalls.metal
//  Metaballsy
//
//  Created by Ilya Nikokoshev on 08/06/15.
//  Copyright (c) 2015 ilyan. All rights reserved.
//

using namespace metal;
#include <metal_common>
#include <metal_math>
#include <metal_geometric>

struct ColoredVertex
{
    float4 position [[position]];
    float4 coords;
    float4 background;
};


vertex ColoredVertex vertex_main(constant float4 *position [[buffer(0)]],
                                 constant float4 *color [[buffer(1)]],
                                 uint vid [[vertex_id]])
{
    ColoredVertex vert;
    vert.position = position[vid];
    vert.coords   = position[vid];
    vert.background = color[vid];
    
    
    return vert;
}

float RenderMan(float dist_sq, float gooiness) {
    return pow(clamp(1 - dist_sq, 0, 1), 3 * gooiness);
}

fragment float4 fragment_main(ColoredVertex vert [[stage_in]],
                              constant float  *parameters [[buffer(0)]],
                              constant float4 *metaballs [[buffer(1)]]
                              )
{    
    float radius    = parameters[0];
    float threshold = parameters[1];
    float gooiness  = parameters[2]; 
    float smooth    = parameters[3];

    float sum = 0;
    for (int i = 0; i < 4; i++) {     
        float4 vector = vert.coords - metaballs[i];
        float dist = length_squared(vector / radius);
        float term = RenderMan(dist, gooiness);
        sum += term;
    }
    
    float density = sum / threshold;    
    float4 color = vert.background;

    if (smooth == 0 && density > 1) {
        color[0] = 0;
        color[1] = 0;
        color[2] = 0;
    } 
    
    if (smooth != 0) {
        float coef = smoothstep(1 - smooth, 1 + smooth, density);        
        color[0] = coef * color[0];
        color[1] = coef * color[1];
        color[2] = coef * color[2];
    }
    
    return color;
}