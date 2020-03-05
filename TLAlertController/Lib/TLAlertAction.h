//
//  TLAlertAction.h
//  TLAlertController
//
//  Created by 故乡的云 on 2020/2/28.
//  Copyright © 2020 故乡的云. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TLAlertActionStyle) {
    TLAlertActionStyleDefault = 0,
    TLAlertActionStyleCancel,
    TLAlertActionStyleDestructive
} API_AVAILABLE(ios(9.0));


UIKIT_EXTERN API_AVAILABLE(ios(9.0)) @interface TLAlertAction : NSObject
/**
*  初始化`TLAlertController`的按钮
*
*  @param title   按钮标题
*  @param style   按钮style，跟系统一样，有 Default、Cancel、Destructive 三种类型
*  @param handler 处理点击事件的block，注意 TLAlertAction 点击后必定会隐藏 alertController，不需要手动在 handler 里 hide
*
*  @return TLAlertController按钮的实例
*/
+ (instancetype)actionWithTitle:(nullable NSString *)title style:(TLAlertActionStyle)style handler:(void (^ __nullable)(TLAlertAction *action))handler;
/**
*  初始化`TLAlertController`的按钮
*
*  @param customView   自定义View
*  @param style   按钮style，跟系统一样，有 Default、Cancel、Destructive 三种类型
*  @param handler 处理点击事件的block，注意 TLAlertAction 点击后必定会隐藏 alertController，不需要手动在 handler 里 hide
*
*  @return TLAlertController按钮的实例
*/
+ (instancetype)actionWithCustomView:(UIView *)customView style:(TLAlertActionStyle)style handler:(void (^ __nullable)(TLAlertAction *action))handler;

@property (nullable, nonatomic, readonly) NSString *title;
/// 会自动匹配superview的size，如果点击时不想被dismiss，请设置action.enabled = NO
@property (nullable, nonatomic, readonly) UIView *customView;
@property (nonatomic, readonly) TLAlertActionStyle style;
/// Deafult is YES, 决定action被电击时会不会进行dismiss操作
@property (nonatomic, getter=isEnabled) BOOL enabled;
@property(nonatomic, readonly) void (^handler)(TLAlertAction *action);

@end

NS_ASSUME_NONNULL_END
