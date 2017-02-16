//
//  RuleClockView.m
//  iKSmart
//
//  Created by 吴伟城 on 2017/2/15.
//  Copyright © 2017年 508. All rights reserved.
//

#import "RuleClockView.h"

@interface RuleClockView ()
@property (nonatomic, weak) CAShapeLayer *circleLayerAM;
@property (nonatomic, weak) CAShapeLayer *circleLayerPM;
@end

@implementation RuleClockView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        [self prepareClocks];
    }
    return self;
}

- (void)prepareClocks {
    [self drawCircle:self.centerAM radius:self.radius strokeColor:[UIColor whiteColor]];
    [self drawCircle:self.centerAM radius:(self.radius - 12.f) strokeColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.f]];
    [self drawCircle:self.centerPM radius:self.radius strokeColor:[UIColor darkGrayColor]];
    [self drawCircle:self.centerPM radius:(self.radius - 12.f) strokeColor:[UIColor whiteColor]];
    
    [self drawNumbers:self.centerAM];
    [self drawNumbers:self.centerPM];
}

- (CAShapeLayer *)drawCircle:(CGPoint)center radius:(CGFloat)radius strokeColor:(UIColor *)strokeColor {
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = strokeColor.CGColor;
    layer.strokeStart = 0.f;
    layer.strokeEnd = 1.f;
    layer.lineWidth = radius;
    layer.zPosition = -1;
    layer.path = [UIBezierPath bezierPathWithArcCenter:center
                                                radius:radius / 2.f
                                            startAngle:-M_PI_2
                                              endAngle:M_PI_2 * 3.f
                                             clockwise:YES].CGPath;
    [self.layer addSublayer:layer];
    return layer;
}

- (void)drawNumbers:(CGPoint)center {
    CGFloat angle = M_PI;
    CGFloat step = M_PI / 6.f;
    for (int i = 1; i <= 12; i++) {
        angle -= step;
        NSString *text = @(i).stringValue;
        CGSize size = [self sizeForText:text];
        CGFloat x = (self.radius - 5) * sin(angle) + center.x - size.width / 2.f;
        CGFloat y = (self.radius - 5) * cos(angle) + center.y - size.height / 2.f;
        
        CATextLayer *layer = [CATextLayer layer];
        layer.backgroundColor = [UIColor clearColor].CGColor;
        layer.foregroundColor = [UIColor blackColor].CGColor;
        layer.fontSize = 11;
        layer.string = text;
        layer.frame = CGRectMake(x, y, size.width, size.height);
        [self.layer addSublayer:layer];
    }
}

- (CGSize)sizeForText:(NSString *)text {
    return [text boundingRectWithSize:CGSizeMake(50, 50)
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:[self labelAttributes]
                              context:nil].size;
}

- (NSDictionary *)labelAttributes {
    return @{
             NSFontAttributeName: [UIFont systemFontOfSize:11],
             NSForegroundColorAttributeName: [UIColor blackColor],
             };
}

- (void)drawRect:(CGRect)rect {
}

#pragma mark - getters

- (CGFloat)margin {
    return 8.f;
}

- (CGFloat)radius {
    return CGRectGetHeight(self.bounds) / 2 - self.margin;
}

- (CGPoint)centerAM {
    return CGPointMake(CGRectGetMinX(self.bounds) + (self.margin + self.radius), CGRectGetHeight(self.bounds) / 2);
}

- (CGPoint)centerPM {
    return CGPointMake(CGRectGetMaxX(self.bounds) - (self.margin + self.radius), CGRectGetHeight(self.bounds) / 2);
}

@end
