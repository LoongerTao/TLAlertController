//
//  TLAlertAction.m
//  TLAlertController
//
//  Created by 故乡的云 on 2020/2/28.
//  Copyright © 2020 故乡的云. All rights reserved.
//

#import "TLAlertAction.h"

@interface TLAlertAction ()
@property(nonatomic, assign, readwrite) TLAlertActionStyle style;
@property(nonatomic, assign, readwrite) NSString *title;
@property(nonatomic, copy) void (^handler)(TLAlertAction *action);
@end

@implementation TLAlertAction

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(TLAlertActionStyle)style handler:(void (^ __nullable)(TLAlertAction *action))handler {
    TLAlertAction *alertAction = [[TLAlertAction alloc] init];
    alertAction.title = title;
    alertAction.style = style;
    alertAction.handler = handler;
    return alertAction;
}

@end
