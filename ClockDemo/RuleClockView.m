//
//  RuleClockView.m
//  iKSmart
//
//  Created by 吴伟城 on 2017/2/15.
//  Copyright © 2017年 508. All rights reserved.
//

#import "RuleClockView.h"

#define angle2radion(angle) (angle * M_PI)

@interface RuleClockView ()
@property (nonatomic, strong) NSMutableDictionary *times;
@end

@implementation RuleClockView

- (void)addTime:(NSDictionary *)time {
    NSString *start = time[@"start"];
    NSString *end = time[@"end"];
    
    NSMutableArray *layers = @[].mutableCopy;
    
    // 这部分算法很有问题！！！
    if ([self isAM:start] && [self isAM:end])
    {
        if ([self time:start lessThan:end])
        {
            [layers addObject:[self addStart:start end:end isAM:YES]];
        }
        else
        {
            [layers addObject:[self addStart:start end:end isAM:YES]];
            [layers addObject:[self addStart:@"下午 00:00" end:@"下午 12:00" isAM:NO]];
        }
    }
    if ([self isAM:start] && ![self isAM:end])
    {
        [layers addObject:[self addStart:start end:@"上午 12:00" isAM:YES]];
        [layers addObject:[self addStart:@"下午 00:00" end:end isAM:NO]];
    }
    if (![self isAM:start] && [self isAM:end])
    {
        [layers addObject:[self addStart:@"下午 00:00" end:end isAM:YES]];
        [layers addObject:[self addStart:start end:@"上午 12:00" isAM:NO]];
    }
    if (![self isAM:start] && ![self isAM:end])
    {
        if ([self time:start lessThan:end]) {
            [layers addObject:[self addStart:start end:end isAM:NO]];
        } else {
            [layers addObject:[self addStart:start end:end isAM:NO]];
            [layers addObject:[self addStart:@"上午 00:00" end:@"上午 12:00" isAM:YES]];
        }
    }
    
    NSString *key = [self keyForDict:time];
    self.times[key] = layers.copy;
    
    NSLog(@"%@", self.times);
}

- (void)removeTime:(NSDictionary *)time {
    NSString *key = [self keyForDict:time];
    NSArray *layers = self.times[key];
    [self.times removeObjectForKey:key];
    for (CALayer *layer in layers) {
        [layer removeFromSuperlayer];
    }
}

- (NSMutableDictionary *)times {
    if (!_times) {
        _times = @{}.mutableCopy;
    }
    return _times;
}

- (BOOL)isAM:(NSString *)time {
    return [time hasPrefix:@"上午"];
}

- (BOOL)time:(NSString *)time1 lessThan:(NSString *)time2 {
    return [self angleForTime:time1] < [self angleForTime:time2];
}

- (NSString *)keyForDict:(NSDictionary *)dict {
    return [NSString stringWithFormat:@"key_%@_%@", dict[@"start"], dict[@"end"]];
}

- (CAShapeLayer *)addStart:(NSString *)startTime end:(NSString *)endTime isAM:(BOOL)isAM {
    return [self drawCircle:isAM ? self.centerAM : self.centerPM
                     radius:self.radius - 12.f
                strokeColor:[UIColor greenColor]
                 startAngle:[self angleForTime:startTime]
                   endAngle:[self angleForTime:endTime]
                  clockwise:YES];
}

- (CGFloat)angleForTime:(NSString *)time {
    NSString *ignore = @"上午 ";
    int hours = [time substringWithRange:NSMakeRange(ignore.length, ignore.length + 2)].intValue;
    int minutes = [time substringFromIndex:ignore.length + 3].intValue;
    minutes += hours * 60;
    CGFloat result = -M_PI_2 + minutes / (12.f * 60.f) * M_PI * 2;
    return result;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        [self prepareClocks];
    }
    return self;
}

- (void)prepareClocks
{
    [self drawCircle:self.centerAM radius:self.radius strokeColor:[UIColor whiteColor]];
    [self drawCircle:self.centerAM radius:(self.radius - 12.f) strokeColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.f]];
    [self drawCircle:self.centerPM radius:self.radius strokeColor:[UIColor darkGrayColor]];
    [self drawCircle:self.centerPM radius:(self.radius - 12.f) strokeColor:[UIColor whiteColor]];
    
    [self drawNumbers:self.centerAM];
    [self drawNumbers:self.centerPM];
}

- (CAShapeLayer *)drawCircle:(CGPoint)center
                      radius:(CGFloat)radius
                 strokeColor:(UIColor *)strokeColor
{
    return [self drawCircle:center
                     radius:radius
                strokeColor:strokeColor
                 startAngle:-M_PI_2
                   endAngle:(M_PI_2 * 3.f)
                  clockwise:YES];
}

- (CAShapeLayer *)drawCircle:(CGPoint)center
                      radius:(CGFloat)radius
                 strokeColor:(UIColor *)strokeColor
                  startAngle:(CGFloat)startAngle
                    endAngle:(CGFloat)endAngle
                   clockwise:(BOOL)clockwise
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = strokeColor.CGColor;
    layer.strokeStart = 0.f;
    layer.strokeEnd = 1.f;
    layer.lineWidth = radius;
    layer.zPosition = -1;
    layer.path = [UIBezierPath bezierPathWithArcCenter:center
                                                radius:radius / 2.f
                                            startAngle:startAngle
                                              endAngle:endAngle
                                             clockwise:clockwise].CGPath;
    [self.layer addSublayer:layer];
    return layer;
}

- (void)drawNumbers:(CGPoint)center
{
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

- (CGSize)sizeForText:(NSString *)text
{
    return [text boundingRectWithSize:CGSizeMake(50, 50)
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:[self labelAttributes]
                              context:nil].size;
}

- (NSDictionary *)labelAttributes
{
    return @{
             NSFontAttributeName: [UIFont systemFontOfSize:11],
             NSForegroundColorAttributeName: [UIColor blackColor],
             };
}

- (void)drawRect:(CGRect)rect
{
}

#pragma mark - getters

- (CGFloat)margin {
    return 12.f;
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
