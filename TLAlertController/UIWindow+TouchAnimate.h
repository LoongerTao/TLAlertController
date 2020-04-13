//
//  UIWindow+TouchAnimate.h
//  TLAlertController
//
//  Created by 故乡的云 on 2020/3/31.
//  Copyright © 2020 故乡的云. All rights reserved.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIWindow (TouchAnimate)
/// 是否激活触摸动画，Default is NO
@property(nonatomic, assign) BOOL activeTouchAnimate;

@end

NS_ASSUME_NONNULL_END
