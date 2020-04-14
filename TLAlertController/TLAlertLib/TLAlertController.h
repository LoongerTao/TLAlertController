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
+ (instancetype)alertControllerWithTitle:(nullable NSString *)title
                                 message:(nullable NSString *)message
                          preferredStyle:(TLAlertControllerStyle)preferredStyle;
/// 创建富文本实例（因为行高计算是以默认字体/设置字体为标准计算，所以富文本字体与默认字体/设置字体相差较大时可能存在行高计算误差 ）
+ (instancetype)alertControllerWithAttributedTitle:(nullable NSAttributedString *)attributedTitle
                                 attributedMessage:(nullable NSAttributedString *)attributedMessage
                          preferredStyle:(TLAlertControllerStyle)preferredStyle;

/// 添加Action
- (void)addAction:(TLAlertAction *)action;
@property (nonatomic, readonly) NSArray<TLAlertAction *> *actions;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *message;
@property (nullable, nonatomic, copy) NSAttributedString *attributedTitle;
@property (nullable, nonatomic, copy) NSAttributedString *attributedMessage;
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
/// 圆角 Default is  15.f
@property(nonatomic, assign) CGFloat cornerRadius;
/// Action Sheet类型的距离屏幕边缘的距离，决定组件宽度[sheetWidth]（Alert 类型无效）Default is 8.f
@property(nonatomic, assign) CGFloat margin;
@property(nonatomic, assign, readonly) CGFloat sheetWidth;
/// Alert 类型 的组件宽度（ Action Sheet类型无效）,  Default is 270.f
@property(nonatomic, assign) CGFloat alertWidth;
/// 分割线高度, Default is  0.33f / 0.5f
@property(nonatomic, assign) CGFloat separatorLineHeight;
/// Action的高度 Default is 57.f / 44.f
@property(nonatomic, assign) CGFloat rowHeight;


/// title文本颜色,Default is #979797
@property(nonatomic, strong) UIColor *titleColor;
/// title文本字体, Default is  13 bold
@property(nonatomic, strong) UIFont *titleFont;
/// message文本颜色,Default is #979797
@property(nonatomic, strong) UIColor *messageColor;
/// message文本字体 Default is 13
@property(nonatomic, strong) UIFont *messageFont;
/// message文本对齐方式 Default is 13
@property(nonatomic, assign) NSTextAlignment messageAlignment;

/// 分割线的颜色,Default is #NSTextAlignmentLeft
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


// ======== 与TLAlertController使用无关的工具方法 =======
/**
 *  使用HEX命名方式的颜色字符串生成一个UIColor对象
 *
 *  @param hexString 支持以 # 开头和不以 # 开头的 hex 字符串
 *      #RGB        例如#f0f，等同于#ffff00ff，RGBA(255, 0, 255, 1)
 *      #ARGB       例如#0f0f，等同于#00ff00ff，RGBA(255, 0, 255, 0)
 *      #RRGGBB     例如#ff00ff，等同于#ffff00ff，RGBA(255, 0, 255, 1)
 *      #AARRGGBB   例如#00ff00ff，等同于RGBA(255, 0, 255, 0)
 *
 * @return UIColor对象
*/
+ (UIColor *)colorWithHex:(NSString *)hexString;
/// 生成指定颜色的图片，默认size = （3，3）
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
