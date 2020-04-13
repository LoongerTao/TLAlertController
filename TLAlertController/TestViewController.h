//
//  TestViewController.h
//  TLAlertController
//
//  Created by 故乡的云 on 2020/4/13.
//  Copyright © 2020 故乡的云. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestViewController : UIViewController

@property(nonatomic, copy) void(^callback)(void);

@end

NS_ASSUME_NONNULL_END
