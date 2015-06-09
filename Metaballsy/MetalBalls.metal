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
    float4 vector0;
    float4 vector1;
    float4 vector2;
    float4 vector3;
    float gooiness;
    float threshold;
};


vertex ColoredVertex vertex_main(constant float4 *position [[buffer(0)]],
                                 constant float4 *color [[buffer(1)]],
                                 constant float4 *metaballs [[buffer(2)]],
                                 constant float  *parameters [[buffer(3)]],
                                 uint vid [[vertex_id]])
{
    ColoredVertex vert;
    vert.position = position[vid];
    vert.color = color[vid];
    
    float radius = parameters[0];    // 0.4;
    float threshold = parameters[1]; // 0.6;
    float gooiness = parameters[2];  // 0.7;
    
    vert.vector0 =  (position[vid] - metaballs[0]) / radius;
    vert.vector1 =  (position[vid] - metaballs[1]) / radius;
    vert.vector2 =  (position[vid] - metaballs[2]) / radius;
    vert.vector3 =  (position[vid] - metaballs[3]) / radius;
    
    vert.threshold = threshold;
    vert.gooiness = gooiness;
    
//    vert.vector0[2] = 0;
//    vert.vector1[2] = 0;
//
//    vert.vector0[3] = 0;
//    vert.vector1[3] = 0;
    
    return vert;
}

float RenderMan(float dist_sq, float gooiness) {
    if (dist_sq > 1) {
        return 0;
    }
    
    return pow(pow(1 - dist_sq, 3), gooiness);
}

fragment float4 fragment_main(ColoredVertex vert [[stage_in]])
{
    float4 color = vert.color;
    
    float dist0 = length_squared(vert.vector0);
    float dist1 = length_squared(vert.vector1);
    float dist2 = length_squared(vert.vector2);
    float dist3 = length_squared(vert.vector3);
   
    float term0 = RenderMan(dist0, vert.gooiness);
    float term1 = RenderMan(dist1, vert.gooiness);
    float term2 = RenderMan(dist2, vert.gooiness);
    float term3 = RenderMan(dist3, vert.gooiness);
    
    if (term0 + term1 + term2 + term3 > vert.threshold ) {
        color[0] = 0;
        color[1] = 0;
        color[2] = 0;
    }
    
    return color;
}