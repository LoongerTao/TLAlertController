//
//  TLAlertController.h
//  TLAlertController
//
//  Created by 故乡的云 on 2020/2/27.
//  Copyright © 2020 故乡的云. All rights reserved.
//
//  因为内部使用了UIStackView，所以只支持iOS 9.0+ （目前主流App也都只适配到iOS 9.0）


#import <UIKit/UIKit.h>
#import "TLAlertAction.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, TLAlertControllerStyle) {
    TLAlertControllerStyleActionSheet = 0,
    TLAlertControllerStyleAlert
} API_AVAILABLE(ios(9.0));


UIKIT_EXTERN API_AVAILABLE(ios(9.0)) @interface TLAlertController : UIViewController
/// 创建实例
+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(TLAlertControllerStyle)preferredStyle;

/// 添加Action
- (void)addAction:(TLAlertAction *)action;
@property (nonatomic, readonly) NSArray<TLAlertAction *> *actions;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *message;
@property (nonatomic, readonly) TLAlertControllerStyle preferredStyle;

/// presentingViewController (发起modal控制器)
- (void)showInViewController:(UIViewController *)vc;
/// 提供给自定义按钮事件使用
- (void)dismiss;

/// 允许点击空白处进行Dismiss，TLAlertControllerStyleActionSheet Default is YES, TLAlertControllerStyleAlert Default is NO
@property(nonatomic, assign) BOOL allowTapMaskToDismiss;
/// 点击空白处进行回调
@property(nonatomic, copy) void (^didTapMaskView)(void);

/// 外观配置(调用`- showInViewController:`前设置)
/// title文本颜色,Default is #979797
@property(nonatomic, strong) UIColor *titleColor;
/// title文本字体, Default is  13 bold
@property(nonatomic, strong) UIFont *titleFont;
/// message文本颜色,Default is #979797
@property(nonatomic, strong) UIColor *messageColor;
/// message文本字体 Default is 13
@property(nonatomic, strong) UIFont *messageFont;
/// 分割线的颜色,Default is #3C3C3C4A
@property(nonatomic, strong) UIColor *separatorColor;
/// 按钮文本颜色 style = TLAlertActionStyleDefault ,Default is  #333（黑）
@property(nonatomic, strong) UIColor *textColorOfDefault;
/// 按钮文本字体 style = TLAlertActionStyleDefault,Default is  17
@property(nonatomic, strong) UIFont *textFontOfDefault;
/// 按钮文本颜色 style = TLAlertActionStyleCancel, Default is #097FFF（蓝）
@property(nonatomic, strong) UIColor *textColorOfCancel;
/// 按钮文本字体 style = TLAlertActionStyleCancel ,Default is 17 bold
@property(nonatomic, strong) UIFont *textFontOfCancel;
/// 按钮文本颜色 style = TLAlertActionStyleDestructive, Default is #FF4238 (红)
@property(nonatomic, strong) UIColor *textColorOfDestructive;
/// 按钮文本字体 style = TLAlertActionStyleDestructive, Default is 17
@property(nonatomic, strong) UIFont *textFontOfDestructive;
/// action高亮背景颜色, Default is [UIColor colorWithWhite:0 alpha:0.03]
@property(nonatomic, strong) UIColor *actionBgColorOfHighlighted;


/// 取消按钮所在视图是否使用模糊效果，default is NO
@property(nonatomic, assign) BOOL isBlurEffectOfCancelView;
/// 默认白色（深色模式0.11的黑色）
@property(nonatomic, strong) UIColor *backgroundColorOfCancelView;
/// 模糊效果样式，默认：iOS 13之下 UIBlurEffectStyleExtraLight ，iOS 13+ UIBlurEffectStyleSystemMaterial（UIBlurEffectStyleSystemMaterialLight 、UIBlurEffectStyleSystemMaterialDark）
@property(nonatomic, assign) UIBlurEffectStyle effectStyle;

/// action的siize，可用于自定义Action
@property(nonatomic, assign, readonly) CGSize actionSize;
@end

NS_ASSUME_NONNULL_END
