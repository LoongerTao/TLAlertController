//
//  TLAlertController.m
//  TLAlertController
//
//  Created by 故乡的云 on 2020/2/27.
//  Copyright © 2020 故乡的云. All rights reserved.
//

#import "TLAlertController.h"
#import "TLAlertPresentationController.h"

#define kCornerRadius 15.f
#define kMargin 8.f
#define kSeparatorLineHeight 0.5f
#define kRowHeight 57.f
#define kAlertRowHeight 44.f
#define kMaxWidth (MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) - kMargin * 2)
#define kAlertWidth 270.f
#define kCancelBtnTag 1000

@interface TLAlertController ()

@property(nonatomic, strong) TLAlertAction *cancelAction;

// 不包含cancelAction
@property(nonatomic, strong) NSMutableArray <TLAlertAction *>*acts;
/// titleView 和 stackScrollView的显示容器
@property(nonatomic, weak)  UIVisualEffectView *containerView;
/// 顶部title和message显示容器
@property(nonatomic, weak)  UIView *titleView;
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) UILabel *messageLabel;
///  TLAlertActionStyleCancel和TLAlertActionStyleDestructive类型按钮显示容器
@property(nonatomic, weak)  UIScrollView *stackScrollView;
@property(nonatomic, weak)  UIStackView *stackView;

/// 取消按钮容器
@property(nonatomic, weak)  UIView *cancelView;

@property(nonatomic, strong) NSMutableDictionary <NSString *, UIButton *>*btns;
@end

@implementation TLAlertController
@dynamic title;

- (instancetype)init {
    if (self = [super init]) {
        
        self.separatorColor = [self colorWithHex:@"#BBBBBB"];
        self.titleColor = [self colorWithHex:@"#101010"];
        self.messageColor = [self colorWithHex:@"#181818"];
        self.textColorOfDefault = [self colorWithHex:@"#333"];
        self.textColorOfCancel = [self colorWithHex:@"#097FFF"];
        self.textColorOfDestructive = [self colorWithHex:@"#FF4238"];;
        
        self.titleFont = [UIFont boldSystemFontOfSize:13];
        self.messageFont = [UIFont systemFontOfSize:13];
        self.textFontOfDefault = [UIFont systemFontOfSize:17];
        self.textFontOfCancel = [UIFont boldSystemFontOfSize:17];
        self.textFontOfDestructive = [UIFont systemFontOfSize:17];
        
        self.actionBgColorOfHighlighted = [UIColor colorWithWhite:0 alpha:0.03];
        
        self.btns = [NSMutableDictionary dictionary];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat W = _preferredStyle == TLAlertControllerStyleAlert ? kAlertWidth : kMaxWidth;
    if (self.title || self.message) {
        if (self.title) {
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.numberOfLines = 0;
            titleLabel.text = self.title;
            titleLabel.font = self.titleFont;
            titleLabel.textColor = self.titleColor;
            [self.titleView addSubview:titleLabel];
            _titleLabel = titleLabel;
        }
        if (self.message) {
            UILabel *msgLabel = [[UILabel alloc] init];
            msgLabel.numberOfLines = 0;
            msgLabel.text = self.message;
            msgLabel.font = self.messageFont;
            msgLabel.textColor = self.messageColor;
            [self.titleView addSubview:msgLabel];
            _messageLabel = msgLabel;
        }
    }
    
    if(_preferredStyle == TLAlertControllerStyleAlert) {
        BOOL isMultiRow = self.isMultiRow;
        UIScrollView *scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, W, 0)];
        [self.containerView.contentView addSubview:scrollV];
        _stackScrollView = scrollV;
        scrollV.bounces = NO;
        
        UIStackView *stackView = [[UIStackView alloc] initWithFrame:CGRectMake(0, 0, W, self.rowHeight * self.acts.count)];
        _stackView = stackView;
        [scrollV addSubview:stackView];
        stackView.axis = isMultiRow ? UILayoutConstraintAxisVertical : UILayoutConstraintAxisHorizontal;
        stackView.distribution = UIStackViewDistributionFillEqually;
        
        if(isMultiRow) {
            [self.acts enumerateObjectsUsingBlock:^(TLAlertAction *action, NSUInteger idx, BOOL * _Nonnull stop) {
                BOOL isShow = idx != 0 || (idx == 0 && (self.title || self.message)); // 是否显示顶部分割线
                [_stackView addArrangedSubview:[self addRowWithAction:action tag:idx showSeparator:isShow]];
            }];
            if (self.cancelAction) {
                BOOL isShow = self.acts.count > 0 || (self.title || self.message); // 是否显示顶部分割线
                [_stackView addArrangedSubview:[self addRowWithAction:self.cancelAction tag:kCancelBtnTag showSeparator:isShow]];
            }
        }else {
            stackView.spacing = kSeparatorLineHeight;
            BOOL isShow = self.title || self.message; // 是否显示顶部分割线
            if (self.cancelAction) {
                BOOL isShow = self.acts.count > 0 || (self.title || self.message);
                [_stackView addArrangedSubview:[self addRowWithAction:self.cancelAction tag:kCancelBtnTag showSeparator:isShow]];
            }
            [self.acts enumerateObjectsUsingBlock:^(TLAlertAction *action, NSUInteger idx, BOOL * _Nonnull stop) {
                UIView *row = [self addRowWithAction:action tag:idx showSeparator:isShow];
                [_stackView addArrangedSubview:row];
            }];
            
            CALayer *sp = [[CALayer alloc] init];
            sp.backgroundColor = self.separatorColor.CGColor;
            sp.frame = CGRectMake((kAlertWidth - kSeparatorLineHeight) * 0.5, 0, kSeparatorLineHeight, kAlertRowHeight);
            [scrollV.layer addSublayer:sp];
        }
        
    }else {
        if (self.acts.count) {
            UIScrollView *scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, W, 0)];
            [self.containerView.contentView addSubview:scrollV];
            _stackScrollView = scrollV;
            scrollV.bounces = NO;
            
            UIStackView *stackView = [[UIStackView alloc] initWithFrame:CGRectMake(0, 0, W, self.rowHeight * self.acts.count)];
            _stackView = stackView;
            [scrollV addSubview:stackView];
            stackView.axis = UILayoutConstraintAxisVertical;
            stackView.distribution = UIStackViewDistributionFillEqually;
            
            [self.acts enumerateObjectsUsingBlock:^(TLAlertAction *action, NSUInteger idx, BOOL * _Nonnull stop) {
                BOOL isShow = idx != 0 || (idx == 0 && (self.title || self.message));
                [_stackView addArrangedSubview:[self addRowWithAction:action tag:idx showSeparator:isShow]];
            }];
        }
        
        if (self.cancelAction) {
            UIView *cancelView = [[UIView alloc] init];
            _cancelView = cancelView;
            cancelView.backgroundColor = [UIColor whiteColor];
            cancelView.layer.cornerRadius = kCornerRadius;
            cancelView.clipsToBounds = YES;
            [self.view addSubview:cancelView];
            
            UIView *view = [self addRowWithAction:self.cancelAction tag:kCancelBtnTag showSeparator:NO];
            view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
            [cancelView addSubview:view];
        }
    }
    
    /// 刷新布局
    [self updatePreferredContentSizeWithTraitCollection:self.traitCollection];
    
    /// 更新按钮使能
    for (TLAlertAction *action in self.actions) {
        self.btns[[NSString stringWithFormat:@"%p", action]].enabled = action.enabled;
    }
}

// MARK: - update Preferred Content Size
- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    
    [self updatePreferredContentSizeWithTraitCollection:newCollection];
}


- (void)updatePreferredContentSizeWithTraitCollection:(UITraitCollection *)traitCollection {
    BOOL isLandspace = traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact;
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat W = _preferredStyle == TLAlertControllerStyleAlert ? kAlertWidth : kMaxWidth; // 始终以最小屏宽计算
   
    if (_titleLabel) {
        CGFloat rowH = [@"一行文本的高度" boundingRectWithSize:CGSizeMake(1000, 40)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName: _titleLabel.font}
                                                context:nil].size.height;
        CGSize size = [_titleLabel sizeThatFits:CGSizeMake(W - kMargin * 4, rowH * 2)];
        size.height = size.height > rowH * 2 ? rowH * 2 : size.height;
        _titleLabel.frame = CGRectMake((W - size.width) / 2, 16, size.width, size.height);
       _titleView.frame = CGRectMake(0, 0, W, CGRectGetMaxY(_titleLabel.frame) + 16);
    }
    
    if (_messageLabel) {
        CGFloat rowH = [@"一行文本的高度" boundingRectWithSize:CGSizeMake(1000, 40)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName: _messageLabel.font}
                                                context:nil].size.height;
        CGFloat top = _titleLabel ? CGRectGetMaxY(_titleLabel.frame) + 8 : 16;
        CGSize size = [_messageLabel sizeThatFits:CGSizeMake(W - kMargin * 4, rowH * 3)];
        size.height = size.height > rowH * 3 ? rowH * 3 : size.height;
        _messageLabel.frame = CGRectMake((W - size.width) / 2, top, size.width, size.height);
       _titleView.frame = CGRectMake(0, 0, W, CGRectGetMaxY(_messageLabel.frame) + 24);
    }

    NSInteger qty = _preferredStyle == TLAlertControllerStyleActionSheet ? self.acts.count : self.actions.count;
    if (qty) {
        if (self.isMultiRow) {
            CGFloat H = self.rowHeight * qty;
            CGFloat top = _titleView ? CGRectGetMaxY(_titleView.frame) : 0;
            CGFloat kMaxHeight = 0;
            CGFloat maxH = 0;
            if (_preferredStyle == TLAlertControllerStyleAlert) {
                if (isLandspace) {
                    kMaxHeight = MIN(size.width, size.height);
                }else {
                    kMaxHeight = MAX(size.width, size.height);
                }
                maxH = kMaxHeight - top - 122;
            }else {
                CGFloat iphoneXBar = Is_iPhoneX ? 34 : 0;
                if (isLandspace) {
                    kMaxHeight = MIN(size.width, size.height) - kMargin - iphoneXBar;
                }else {
                    CGFloat top = [UIApplication sharedApplication].statusBarFrame.size.height + 44;
                    kMaxHeight = MAX(size.width, size.height) - top - iphoneXBar;
                }
                maxH = kMaxHeight - top - (self.cancelAction ? kMargin + self.rowHeight : 0);
            }
            
            H = H > maxH ? maxH : H;
            _stackScrollView.frame = CGRectMake(0, top, W, H);
            _stackView.frame = CGRectMake(0, 0, W, self.rowHeight * qty);
            _stackScrollView.contentSize = _stackView.frame.size;
        }else {
            CGFloat top = _titleView ? CGRectGetMaxY(_titleView.frame) : 0;
            _stackScrollView.frame = CGRectMake(0, top, W, kAlertRowHeight);
            _stackView.frame = CGRectMake(0, 0, W, kAlertRowHeight);
            _stackScrollView.contentSize = _stackView.frame.size;
        }
    }
    
    if (_stackScrollView || _titleView) {
       if (_stackView) {
           self.containerView.frame = CGRectMake(0, 0, W, CGRectGetMaxY(_stackScrollView.frame));
       }else {
           self.containerView.frame = CGRectMake(0, 0, W, CGRectGetMaxY(_titleView.frame));
       }
    }
    
    CGFloat preferredContentH = 0;
    if (_preferredStyle == TLAlertControllerStyleActionSheet && self.cancelAction) {
        CGFloat top = 0;
        if (_containerView) {
            top = CGRectGetMaxY(_containerView.frame) + kMargin;
        }
        _cancelView.frame = CGRectMake(0, top, W, self.rowHeight);
        preferredContentH = CGRectGetMaxY(_cancelView.frame);
    }else {
        preferredContentH = CGRectGetMaxY(_stackScrollView.frame);
    }
    self.preferredContentSize = CGSizeMake(W, preferredContentH);
}

// MARK: - add sub views
- (UIVisualEffectView *)containerView {
    if (!_containerView) {
        UIVisualEffect *effect  = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *containerView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _containerView = containerView;
//        containerView.backgroundColor = [UIColor whiteColor];
        containerView.layer.cornerRadius = kCornerRadius;
        containerView.clipsToBounds = YES;
        containerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self.view addSubview:containerView];
    }
    return _containerView;
}

- (UIView *)titleView {
    if (!_titleView) {
        UIView *titleView = [[UIView alloc] init];
        _titleView = titleView;
        [self.containerView.contentView addSubview:titleView];
    }
    return _titleView;
}

- (UIView *)cancelView {
    if (!_cancelView) {
        UIView *cancelView = [[UIView alloc] init];
        _cancelView = cancelView;
        cancelView.backgroundColor = [UIColor whiteColor];
        cancelView.layer.cornerRadius = kCornerRadius;
        cancelView.clipsToBounds = YES;
        [self.view addSubview:cancelView];
        
        UIView *view = [self addRowWithAction:self.cancelAction tag:kCancelBtnTag showSeparator:NO];
        view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
        [cancelView addSubview:view];
    }
    return _cancelView;
}

// MARK: - common method
/// 是否多行显示
- (BOOL)isMultiRow {
    if (_preferredStyle == UIAlertControllerStyleActionSheet) return YES;
    
    NSArray <TLAlertAction *>*actions = self.actions;
    BOOL isMultiRow = actions.count != 2 || (actions.firstObject.customView || actions.lastObject.customView);
    return isMultiRow;
}

- (CGFloat)rowHeight {
    return _preferredStyle == TLAlertControllerStyleAlert ? kAlertRowHeight : kRowHeight;
}
- (UIView *)addRowWithAction:(TLAlertAction *)action tag:(NSInteger)tag showSeparator:(BOOL)isShow {
    CGFloat W = _preferredStyle == TLAlertControllerStyleAlert ? kAlertWidth : kMaxWidth;
    if(!self.isMultiRow) {
        W = (kAlertWidth - kSeparatorLineHeight) * 0.5f;
    }
    UIView *rowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, W, self.rowHeight)];

    if (isShow) {
        CALayer *sp = [[CALayer alloc] init];
        sp.backgroundColor = self.separatorColor.CGColor;
        sp.frame = CGRectMake(0, 0, W, kSeparatorLineHeight);
        [rowView.layer addSublayer:sp];
    }
    
    CGRect frame = CGRectMake(0, kSeparatorLineHeight, W, self.rowHeight - kSeparatorLineHeight);
    if (action.customView) {
        action.customView.frame = frame;
        [rowView addSubview:action.customView];
        
        action.customView.tag = tag;
        
        if ([action.customView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)action.customView;
            [btn addTarget:self action:@selector(itemDidClick:) forControlEvents:UIControlEventTouchUpInside];
            self.btns[[NSString stringWithFormat:@"%p", action]] = btn;
        }else {
            UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(itemDidClick2:)];
            gesture.minimumPressDuration = 0.001;
            [action.customView addGestureRecognizer:gesture];
        }
    }else {
        UIButton *btn = [[UIButton alloc] initWithFrame:frame];
        btn.tag = tag;
        [btn setTitle:action.title forState:UIControlStateNormal];
        UIImage *bgImg = [self imageWithColor:self.actionBgColorOfHighlighted size:CGSizeZero];
        [btn setBackgroundImage:bgImg forState:UIControlStateHighlighted];
        [btn setTitleColor:[self colorWithHex:@"CCCCCC"] forState:UIControlStateDisabled];
        if (action.style == TLAlertActionStyleDefault) {
            [btn setTitleColor:self.textColorOfDefault forState:UIControlStateNormal];
            btn.titleLabel.font = self.textFontOfDefault;
            
        }else if (action.style == TLAlertActionStyleDestructive) {
            [btn setTitleColor:self.textColorOfDestructive forState:UIControlStateNormal];
            btn.titleLabel.font = self.textFontOfDestructive;
            
        }else if (action.style == TLAlertActionStyleCancel) {
            [btn setTitleColor:self.textColorOfCancel forState:UIControlStateNormal];
            btn.titleLabel.font = self.textFontOfCancel;
        }
        [rowView addSubview:btn];
        [btn addTarget:self action:@selector(itemDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.btns[[NSString stringWithFormat:@"%p", action]] = btn;
    }
    
    return rowView;
}

/// 生成指定颜色的图片，默认size = （3，3）
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    if (size.width <= 0  ) {
        size = CGSizeMake(3, 3);
    }
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

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
- (UIColor *)colorWithHex:(NSString *)hexString {
    if (hexString.length <= 0) return nil;
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default: {
            NSAssert(NO, @"Color value %@ is invalid. It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString);
            return nil;
        }
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

- (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

// MARK: - Action
- (void)itemDidClick:(UIButton *)btn {
    NSInteger tag = btn.tag;
    [self clickActionWithIndex:tag];
}

- (void)itemDidClick2:(UILongPressGestureRecognizer *)gestureRecognizer {
    NSInteger idx = gestureRecognizer.view.tag;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self clickActionWithIndex:idx];
    }
}

- (void)clickActionWithIndex:(NSInteger)index {
    TLAlertAction *action = nil;
    if (index == kCancelBtnTag) {
        action = self.cancelAction;
    }else {
        action = self.acts[index];
    }
    
    if (action.enabled) {
        if (action.handler) {
            action.handler(action);
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

// MARK: - API
+ (instancetype)alertControllerWithTitle:(nullable NSString *)title
                                 message:(nullable NSString *)message
                          preferredStyle:(TLAlertControllerStyle)preferredStyle
{
    TLAlertController *alertController = [[self alloc] init];
    alertController.allowTapMaskToDismiss = preferredStyle == TLAlertControllerStyleActionSheet;
    alertController.title = title;
    alertController.message = message;
    alertController->_preferredStyle = preferredStyle;
    return alertController;
}

- (void)addAction:(TLAlertAction *)action {
    if (!_acts) {
        _acts = [NSMutableArray array];
    }
    
    if (![action isKindOfClass:[TLAlertAction class]]) {
        [NSException raise:@"TLAlertController `-addAction:`使用错误" format:@"添加的TLAlertAction必须是TLAlertAction或其子类"];
    }
    if (action.style == TLAlertActionStyleCancel) {
        if (_cancelAction) {
            [NSException raise:@"TLAlertController使用错误" format:@"同一个alertController不可以同时添加两个cancel按钮"];
        }else {
            _cancelAction = action;
        }
    }else {
      [_acts addObject:action];
    }
}

- (NSArray<TLAlertAction *> *)actions {
    if (_cancelAction) {
        NSMutableArray *temp = [NSMutableArray arrayWithArray:_acts];
        [temp addObject:_cancelAction];
        return temp;
    }
    return _acts;
}

- (void)showInViewController:(UIViewController *)vc {
    if (self.actions.count == 0) {
        [NSException raise:@"TLAlertController 使用错误" format:@"actions的个数不能小于1"];
    }
    
    // 该宏表明存储在某些局部变量中的值在优化时不应该被编译器强制释放
    TLAlertPresentationController *pController NS_VALID_UNTIL_END_OF_SCOPE;
    pController = [[TLAlertPresentationController alloc] initWithPresentedViewController:self
                                                             presentingViewController:vc];
    pController.disableTapMaskToDismiss = !self.allowTapMaskToDismiss;
    __weak TLAlertController *wself = self;
    pController.didTapMaskView = ^{
        if (wself.didTapMaskView) {
            wself.didTapMaskView();
        }
    };
    pController.modalStyle = @(_preferredStyle).integerValue;
    self.transitioningDelegate = pController;
    [vc presentViewController:self animated:YES completion:nil];
}


@end



