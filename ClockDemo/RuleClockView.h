//
//  RuleClockView.h
//  iKSmart
//
//  Created by 吴伟城 on 2017/2/15.
//  Copyright © 2017年 508. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RuleClockView : UIView

/// @{@"start": (a HH:mm), @"end": (a HH:mm)}
- (void)addTime:(NSDictionary *)time;

- (void)removeTime:(NSDictionary *)time;

@end
