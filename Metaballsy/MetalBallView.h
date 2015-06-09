//
//  MetaBallView.h
//  Metaballsy
//
//  Created by Ilya Nikokoshev on 08/06/15.
//  Copyright (c) 2015 ilyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MetalBalls.h"

@interface MetalBallView : UIView
@property MetalBalls *metalBalls;

// Must set these before displaying the view.
@property (nonatomic) float radius;
@property (nonatomic) float gooiness;
@property (nonatomic) float threshold;
@property (nonatomic) float speed;
@property (nonatomic) float distance;
@end
