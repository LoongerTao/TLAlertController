# TLAlertController
仿UIAlertController


### 支持
- 高仿系统原生样式效果，有Alert和Sheet两种模式
- 支持自定义文本字体和颜色等
- 支持自定义view作为Action
- 支持横屏
- 支持深色模式
- 不支持文本输入，但可以采用自定义view作为Action的方式实现
- 只支持iOS 9.0及以上系统
- 支持pod

### 用法
- 与UIAlertController的用法高度一致
- 直接将demo中`Lib文件夹中的文件`导入到项目即可使用
- 也可以pod
```
    'TLAlertLib', '~> 1.0.2'
```
- 示例代码
```objc
TLAlertController *alertController = [TLAlertController alertControllerWithTitle:@"故乡的云" message:@"Copyright © 2020 故乡的云. All rights reserved" preferredStyle:TLAlertControllerStyleActionSheet];
                 
[alertController addAction:[TLAlertAction actionWithTitle:@"Action (Enabel = NO)" style:TLAlertActionStyleDefault handler:^(TLAlertAction * _Nonnull action) {
    NSLog(@"%@", action.title);
}]];
        
[alertController addAction:[TLAlertAction actionWithTitle:@"Action2 (Default)" style:TLAlertActionStyleDefault handler:^(TLAlertAction * _Nonnull action) {
    NSLog(@"%@", action.title);
}]];
[alertController addAction:[TLAlertAction actionWithTitle:@"Action3 (Destructive)" style:TLAlertActionStyleDestructive handler:^(TLAlertAction * _Nonnull action) {
    NSLog(@"%@", action.title);
}]];

/// 用自定义view作为Action
UIView *redView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
redView.userInteractionEnabled = YES;
[alertController addAction:[TLAlertAction actionWithCustomView:redView style:TLAlertActionStyleDestructive handler:^(TLAlertAction * _Nonnull action) {
    NSLog(@"CustomView");
}]];

[alertController addAction:[TLAlertAction actionWithTitle:@"Cancel" style:TLAlertActionStyleCancel handler:nil]];

[alertController showInViewController:self];
```

### 示例图
- Alert普通模式

![2.jpg](https://upload-images.jianshu.io/upload_images/3333500-fbe5073faae9be73.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- Alert普通多Action模式

![1.jpg](https://upload-images.jianshu.io/upload_images/3333500-daf92e4d14c5c347.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


- Alert带自定义Action模式

![3.jpg](https://upload-images.jianshu.io/upload_images/3333500-845a4857e44f38ea.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


- ActionSheet带自定义Action模式

![4.jpg](https://upload-images.jianshu.io/upload_images/3333500-c92eb1f3a4e65fd2.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

