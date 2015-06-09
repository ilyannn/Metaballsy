//
//  MetaBallView.m
//  Metaballsy
//
//  Created by Ilya Nikokoshev on 08/06/15.
//  Copyright (c) 2015 ilyan. All rights reserved.
//

#import "MetalBallView.h"

@import Metal;
@import QuartzCore;
#import <GLKit/GLKMath.h>

@interface MetalBallView ()
@property (readonly) CAMetalLayer *metalLayer;
@property (readonly) CADisplayLink *displayLink;

@property (readonly) id <MTLDevice> device;
@property (readonly) MTLRenderPipelineDescriptor *renderPipelineDescriptor;
@property (readonly) id <MTLRenderPipelineState> renderPipelineState;

@property (readonly) id <MTLBuffer> positionBuffer;
@property (readonly) id <MTLBuffer> colorBuffer;
@property (readonly) id <MTLBuffer> metaballsBuffer;
@property (readonly) id <MTLBuffer> parametersBuffer;
@end

@implementation MetalBallView {
    float _parameters[3];
}


#pragma mark - UIView setup

+ (Class)layerClass {
    return [CAMetalLayer class];
}

- (CAMetalLayer *)metalLayer {
    return (CAMetalLayer *)[self layer];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setOpaque:YES];
        [self setBackgroundColor:nil];
        [self setupMetalPipeline];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupMetalPipeline];
    }
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (self.superview) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(renderScene:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    } else {
        [self.displayLink invalidate];
        _displayLink = nil;
    }
}

#pragma mark - Accessors

- (float)radius {
    return _parameters[0];
}

- (float)threshold {
    return _parameters[1];
}

- (float)gooiness {
    return _parameters[2];
}

- (void)setRadius:(float)radius {
    _parameters[0] = radius;
}

- (void)setThreshold:(float)threshold {
    _parameters[1] = threshold;
}

- (void)setGooiness:(float)gooiness {
    _parameters[2] = gooiness;
}


#pragma mark - Metal setup

- (void)buildVertexBuffers
{
    static const float positions[] =
    {
        0.0,  1.5, 0, 1,
        -1.5, -1.5, 0, 1,
        1.5, -1.5, 0, 1,
    };
    
    static const float colors[] =
    {
        1, 0, 0, 1,
        0, 1, 0, 1,
        0, 0, 1, 1,
    };
    
    static const float metaballs[] =
    {
        0, 0, 0, 1,
        0, 0, 0, 1,
        0, 0, 0, 1,
        0, 0, 0, 1,
    };
        
    _positionBuffer = [self.device newBufferWithBytes:positions
                                               length:sizeof(positions)
                                              options:MTLResourceOptionCPUCacheModeDefault];
    _colorBuffer = [self.device newBufferWithBytes:colors
                                            length:sizeof(colors)
                                           options:MTLResourceOptionCPUCacheModeDefault];

    _metaballsBuffer = [self.device newBufferWithBytes:metaballs
                                                length:sizeof(metaballs)
                                               options:MTLResourceOptionCPUCacheModeDefault];

    _parametersBuffer = [self.device newBufferWithBytes:_parameters
                                                length:sizeof(_parameters)
                                               options:MTLResourceOptionCPUCacheModeDefault];

}

- (void)setupMetalPipeline {
    [self setContentScaleFactor:[UIScreen mainScreen].scale];
    _device = MTLCreateSystemDefaultDevice();
    self.metalLayer.device = _device;
    self.metalLayer.pixelFormat = MTLPixelFormatBGRA8Unorm;
    
    id<MTLLibrary> library = [self.device newDefaultLibrary];
    
    MTLRenderPipelineDescriptor *pipelineDescriptor = [MTLRenderPipelineDescriptor new];
    pipelineDescriptor.vertexFunction = [library newFunctionWithName:@"vertex_main"];
    pipelineDescriptor.fragmentFunction = [library newFunctionWithName:@"fragment_main"];
    pipelineDescriptor.colorAttachments[0].pixelFormat = self.metalLayer.pixelFormat;
    
    _renderPipelineState = [self.device newRenderPipelineStateWithDescriptor:pipelineDescriptor 
                                                                       error:NULL];
    
    [self buildVertexBuffers];
}


#pragma mark - Render

- (void)renderScene:(id)sender {
    id <CAMetalDrawable> drawable;    
    
    while (!drawable){
        drawable = [self.metalLayer nextDrawable];
    }
    
    float *contents = (float *)[self.metaballsBuffer contents];
    
    float threshold = self.boundary;
    static float direction = +1;
    
    if (contents[0] > threshold) {
        direction = -1;
    } else if (contents[0] < -threshold) {
        direction = +1;
    }
    
    float step = (1.0/60.0) * self.speed * direction;
    contents[0] += step;
    contents[5] += step;
    contents[9] -= step;
    
    id<MTLTexture> texture = drawable.texture;

    MTLRenderPassDescriptor *passDescriptor = [MTLRenderPassDescriptor renderPassDescriptor];

    passDescriptor.colorAttachments[0].texture = texture;
    passDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
    passDescriptor.colorAttachments[0].storeAction = MTLStoreActionStore;
    passDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.1, 0.1, 0.1, 1.0);
    
    id<MTLCommandQueue> commandQueue = [self.device newCommandQueue];
    id<MTLCommandBuffer> commandBuffer = [commandQueue commandBuffer];
    id<MTLRenderCommandEncoder> commandEncoder = [commandBuffer renderCommandEncoderWithDescriptor:passDescriptor];

    [commandEncoder setRenderPipelineState: self.renderPipelineState];    
    [commandEncoder setVertexBuffer:self.positionBuffer offset:0 atIndex:0 ];
    [commandEncoder setVertexBuffer:self.colorBuffer offset:0 atIndex:1 ];
    [commandEncoder setVertexBuffer:self.metaballsBuffer offset:0 atIndex:2 ];
    [commandEncoder setVertexBuffer:self.parametersBuffer offset:0 atIndex:3 ];
    [commandEncoder drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:3 instanceCount:1];
    [commandEncoder endEncoding];
        
    [commandBuffer presentDrawable: drawable];
    [commandBuffer commit];    
}

@end
