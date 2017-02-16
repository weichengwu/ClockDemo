//
//  ViewController.m
//  ClockDemo
//
//  Created by weichengwu on 2017/2/16.
//  Copyright © 2017年 weichengwu. All rights reserved.
//

#import "ViewController.h"
#import "RuleClockView.h"

@interface ViewController ()
@property (nonatomic, strong) RuleClockView *clockView;
@end

@implementation ViewController

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!_clockView) {
        UIView *tempView = [self.view viewWithTag:1];
        _clockView = [[RuleClockView alloc] initWithFrame:tempView.bounds];
        [tempView addSubview:_clockView];
    }
    
//    [_clockView addStart:@"04:44" end:@"11:44" isAM:YES];
//    [_clockView addStart:@"01:44" end:@"02:44" isAM:NO];
    
    [_clockView addTime:@{
                          @"start" :@"下午 07:00",
                          @"end" :@"下午 06:00",
                          }];
    
    [_clockView removeTime:@{
                             @"start" :@"下午 07:00",
                             @"end" :@"下午 06:00",
                             }];
}


@end
