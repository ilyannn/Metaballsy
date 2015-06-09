//
//  ViewController.m
//  Metaballsy
//
//  Created by Ilya Nikokoshev on 08/06/15.
//  Copyright (c) 2015 ilyan. All rights reserved.
//

#import "ViewController.h"
#import "MetalBallView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISlider *radiusSlider;
@property (weak, nonatomic) IBOutlet UISlider *speedSlider;
@property (weak, nonatomic) IBOutlet UISlider *distanceSlider;
@property (weak, nonatomic) IBOutlet UISlider *thresholdSlider;
@property (weak, nonatomic) IBOutlet UISlider *gooinessSlider;

@property (weak, nonatomic) IBOutlet MetalBallView *metalBallView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self radiusChanged:self];
    [self speedChanged:self];
    [self distanceChanged:self];
    [self thresholdChanged:self];
    [self gooinessChanged:self];
}

- (IBAction)radiusChanged:(id)sender {
    self.metalBallView.radius = self.radiusSlider.value; 
}

- (IBAction)speedChanged:(id)sender {
    self.metalBallView.speed = self.speedSlider.value; 
}

- (IBAction)distanceChanged:(id)sender {
    self.metalBallView.distance = self.distanceSlider.value; 
}

- (IBAction)thresholdChanged:(id)sender {
    self.metalBallView.threshold = self.thresholdSlider.value; 
}

- (IBAction)gooinessChanged:(id)sender {
    self.metalBallView.gooiness = self.gooinessSlider.value; 
}



@end
