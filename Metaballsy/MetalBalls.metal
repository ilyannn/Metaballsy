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
    float4 background;
    float4 vector0;
    float4 vector1;
    float4 vector2;
    float4 vector3;
};


vertex ColoredVertex vertex_main(constant float4 *position [[buffer(0)]],
                                 constant float4 *color [[buffer(1)]],
                                 constant float4 *metaballs [[buffer(2)]],
                                 uint vid [[vertex_id]])
{
    ColoredVertex vert;
    vert.position = position[vid];
    vert.background = color[vid];
    
    
    vert.vector0 = position[vid] - metaballs[0];
    vert.vector1 = position[vid] - metaballs[1];
    vert.vector2 = position[vid] - metaballs[2];
    vert.vector3 = position[vid] - metaballs[3];
        
    return vert;
}

float RenderMan(float dist_sq, float gooiness) {
    return pow(clamp(1 - dist_sq, 0, 1), 3 * gooiness);
}

fragment float4 fragment_main(ColoredVertex vert [[stage_in]],
                              constant float  *parameters [[buffer(0)]])
{    
    float radius    = parameters[0];
    float threshold = parameters[1];
    float gooiness  = parameters[2]; 
    float smooth    = parameters[3];

    float dist0 = length_squared(vert.vector0 / radius);
    float dist1 = length_squared(vert.vector1 / radius);
    float dist2 = length_squared(vert.vector2 / radius);
    float dist3 = length_squared(vert.vector3 / radius);

    float term0 = RenderMan(dist0, gooiness);
    float term1 = RenderMan(dist1, gooiness);
    float term2 = RenderMan(dist2, gooiness);
    float term3 = RenderMan(dist3, gooiness);
    
    float density = (term0 + term1 + term2 + term3 / threshold);
    
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