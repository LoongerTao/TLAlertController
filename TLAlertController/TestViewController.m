//
//  TestViewController.m
//  TLAlertController
//
//  Created by 故乡的云 on 2020/4/13.
//  Copyright © 2020 故乡的云. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidDisappear:(BOOL)animated {
    if (self.callback) {
        self.callback();
    }
}


@end
