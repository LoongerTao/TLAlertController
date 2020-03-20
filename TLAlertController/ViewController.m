//
//  ViewController.m
//  TLAlertController
//
//  Created by 故乡的云 on 2020/2/27.
//  Copyright © 2020 故乡的云. All rights reserved.
//

#import "ViewController.h"
#import "TLAlertController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tap];
}


- (void)tap:(UITapGestureRecognizer *)tap {
    CGFloat x = [tap locationInView:self.view].x;
    if (x > CGRectGetWidth(self.view.bounds) * 0.5) {
        TLAlertController *alertController = [TLAlertController alertControllerWithTitle:@"故乡的云" message:@"Copyright © 2020 故乡的云. All rights reserved" preferredStyle:TLAlertControllerStyleActionSheet];
        [alertController addAction:[TLAlertAction actionWithTitle:@"Action" style:TLAlertActionStyleDefault handler:^(TLAlertAction * _Nonnull action) {
            NSLog(@"%@", action.title);
        }]];
        [alertController addAction:[TLAlertAction actionWithTitle:@"Action2" style:TLAlertActionStyleDefault handler:^(TLAlertAction * _Nonnull action) {
            NSLog(@"%@", action.title);
        }]];
        alertController.actions.firstObject.enabled = NO;
        [alertController addAction:[TLAlertAction actionWithTitle:@"Action3" style:TLAlertActionStyleDestructive handler:^(TLAlertAction * _Nonnull action) {
            NSLog(@"%@", action.title);
        }]];

        UIView *redView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
        redView.userInteractionEnabled = YES;
        [alertController addAction:[TLAlertAction actionWithCustomView:redView style:TLAlertActionStyleDestructive handler:^(TLAlertAction * _Nonnull action) {
            NSLog(@"CustomView");
        }]];
        
        [alertController addAction:[TLAlertAction actionWithTitle:@"Cancel" style:TLAlertActionStyleCancel handler:nil]];
        [alertController showInViewController:self];
        
    }else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"故乡的云" message:@"Copyright © 2020 故乡的云. All rights reserved." preferredStyle:UIAlertControllerStyleActionSheet];
             
        [alertController addAction:[UIAlertAction actionWithTitle:@"Action1" style:UIAlertActionStyleDefault handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Action2" style:UIAlertActionStyleDestructive handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Action3" style:UIAlertActionStyleDefault handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Action4" style:UIAlertActionStyleDefault handler:nil]];
       /* [alertController addAction:[UIAlertAction actionWithTitle:@"Action5" style:UIAlertActionStyleDestructive handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Action6" style:UIAlertActionStyleDestructive handler:nil]];
        alertController.actions.firstObject.enabled = NO;
        [alertController addAction:[UIAlertAction actionWithTitle:@"Action3" style:UIAlertActionStyleDefault handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Action4" style:UIAlertActionStyleDefault handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Action5" style:UIAlertActionStyleDestructive handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Action6" style:UIAlertActionStyleDestructive handler:nil]];*/
        [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
/*
        [alertController addAction:[UIAlertAction actionWithTitle:@"Action3" style:UIAlertActionStyleDefault handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Action4" style:UIAlertActionStyleDefault handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Action5" style:UIAlertActionStyleDestructive handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Action6" style:UIAlertActionStyleDestructive handler:nil]];

        [alertController addAction:[UIAlertAction actionWithTitle:@"Action3" style:UIAlertActionStyleDefault handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Action4" style:UIAlertActionStyleDefault handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Action6" style:UIAlertActionStyleDefault handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Action5" style:UIAlertActionStyleDestructive handler:nil]];

      */
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
@end
