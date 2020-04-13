//
//  UIWindow+TouchAnimate.m
//  TLAlertController
//
//  Created by 故乡的云 on 2020/3/31.
//  Copyright © 2020 故乡的云. All rights reserved.
//

#import "UIWindow+TouchAnimate.h"
#import <objc/runtime.h>

// MARK: - TouchAnimateTapGestureDelegate
@interface TouchAnimateTapGestureDelegate : NSObject<UIGestureRecognizerDelegate>
@end

@implementation TouchAnimateTapGestureDelegate

static TouchAnimateTapGestureDelegate *INSTANCE;

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        INSTANCE = [[self alloc] init];
    });
    return INSTANCE;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
@end


// MARK: - UIWindow (TouchAnimate)
@implementation UIWindow (TouchAnimate)

- (void)setActiveTouchAnimate:(BOOL)activeTouchAnimate {
    if (activeTouchAnimate == self.activeTouchAnimate) return;
    
    if (activeTouchAnimate) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchWindow:)];
        tap.name = @"TouchGesture";
        tap.delegate = [TouchAnimateTapGestureDelegate shared]; // 保证不影响self其它手势
        [self addGestureRecognizer:tap];
    }else {
        
    }
    
    objc_setAssociatedObject(self, @selector(activeTouchAnimate), @(activeTouchAnimate), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)activeTouchAnimate {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)didTouchWindow:(UITapGestureRecognizer *)tap {
//    CGPoint p = [tap locationInView:self];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(200, 200, 20, 20);
    layer.cornerRadius = 10;
    layer.borderColor = [UIColor whiteColor].CGColor;
    layer.borderWidth = 5;
    [self.layer addSublayer:layer];
    
    CAShapeLayer *diffuseLayer = [CAShapeLayer layer];
    diffuseLayer.fillColor = [UIColor clearColor].CGColor;
    diffuseLayer.strokeColor = [UIColor colorWithRed:1 green:61 / 255.0 blue:50 / 255.0 alpha:1].CGColor;
    diffuseLayer.lineWidth = 3;
    diffuseLayer.path = [self diffuseBeginPath].CGPath;
    [self.layer addSublayer:diffuseLayer];
    diffuseLayer.anchorPoint = CGPointMake(0.5, 0.5);
    
    [layer addAnimation:[self expandAnimation] forKey:nil];
    [diffuseLayer addAnimation:[self diffuseAnimation] forKey:nil];

}

#pragma mark - ShapeLayer 的 path

- (UIBezierPath *)diffuseBeginPath {
    CGRect ovalRect = CGRectMake(200, 200, 20, 20);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:ovalRect];
    return path;
}

- (UIBezierPath *)diffuseEndPath {
    CGRect ovalRect = CGRectMake(200, 200, 100, 100);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:ovalRect];
    return path;
}

#pragma mark - Layer 层的动画

- (CAAnimationGroup *)expandAnimation {
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation1.fromValue = @1;
    animation1.toValue = @1.07;
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation1.duration = 0.1;
    animation1.beginTime = 0;
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation2.fromValue = @1.07;
    animation2.toValue = @3;
    animation2.duration = 0.5;
    animation2.beginTime = animation1.duration + animation1.beginTime;
    
    CABasicAnimation *animationEnd = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animationEnd.fromValue = @1;
    animationEnd.toValue = @1;
    animationEnd.duration = 0.1;
    animationEnd.beginTime = animation2.duration + animation2.beginTime;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[animation1, animation2, animationEnd];
    animationGroup.duration = animationEnd.beginTime + animationEnd.duration;
    animationGroup.repeatCount = 1;//CGFLOAT_MAX;
    return animationGroup;
}

- (CAAnimationGroup *)diffuseAnimation {
    CABasicAnimation *animation0 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation0.fromValue = @1;
    animation0.fromValue = @1;
    animation0.duration = 0.07;
    animation0.beginTime = 0;
    
    
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"path"];
    animation1.fromValue = (__bridge id _Nullable)([self diffuseBeginPath].CGPath);
    animation1.toValue = (__bridge id _Nullable)([self diffuseEndPath].CGPath);
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation1.duration = 0.9;
    animation1.beginTime = animation0.duration + animation0.beginTime;
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation2.fromValue = @1;
    animation2.toValue = @0;
    animation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation2.duration = 0.7;
    animation2.beginTime = animation1.beginTime;
    animation2.fillMode = kCAFillModeForwards;
    animation2.removedOnCompletion = NO;
    
    CABasicAnimation *animation3 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation3.fromValue = @1;
    animation3.fromValue = @1;
    animation3.duration = 0.83;
    animation3.beginTime = animation2.duration + animation2.beginTime;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[animation1, animation2, animation3];
    animationGroup.duration = animation3.duration + animation3.beginTime;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animationGroup.repeatCount = 1;//CGFLOAT_MAX;
    return animationGroup;
}

@end


