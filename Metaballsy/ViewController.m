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

@property (weak, nonatomic) IBOutlet UILabel *radiusLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *thresholdLabel;
@property (weak, nonatomic) IBOutlet UILabel *gooinessLabel;


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

- (void)updateLabel:(UILabel *)label fromSlider:(UISlider *)slider {
    label.text = [NSString stringWithFormat:@"%.1f", slider.value];
}

- (IBAction)radiusChanged:(id)sender {
    self.metalBallView.radius = self.radiusSlider.value;
    [self updateLabel:self.radiusLabel fromSlider:self.radiusSlider];
}

- (IBAction)speedChanged:(id)sender {
    self.metalBallView.speed = self.speedSlider.value; 
    [self updateLabel:self.speedLabel fromSlider:self.speedSlider];
}

- (IBAction)distanceChanged:(id)sender {
    self.metalBallView.distance = self.distanceSlider.value; 
    [self updateLabel:self.distanceLabel fromSlider:self.distanceSlider];
}

- (IBAction)thresholdChanged:(id)sender {
    self.metalBallView.threshold = self.thresholdSlider.value; 
    [self updateLabel:self.thresholdLabel fromSlider:self.thresholdSlider];
}

- (IBAction)gooinessChanged:(id)sender {
    self.metalBallView.gooiness = self.gooinessSlider.value; 
    [self updateLabel:self.gooinessLabel fromSlider:self.gooinessSlider];
}



@end
