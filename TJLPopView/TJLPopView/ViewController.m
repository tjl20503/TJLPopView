//
//  ViewController.m
//  TJLPopView
//
//  Created by Future on 2016/11/19.
//  Copyright © 2016年 Future. All rights reserved.
//

#import "ViewController.h"
#import "TJLPopView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}   

- (IBAction)popView:(UIBarButtonItem *)sender
{
    NSArray *array = @[@{@"image" : @"icon_button_affirm",@"name" : @"撤回"},
                                        @{@"image" : @"icon_button_recall",@"name" : @"确认"},
                                        @{@"image" : @"icon_button_record", @"name" : @"记录"}];
    __weak __typeof(&*self)weakSelf = self;
    [TJLPopView createMenuWithFrame:CGRectZero dataArray:array itemsClickBlock:^(NSString *str, NSInteger tag) {
        [weakSelf doSomething:(NSString *)str tag:(NSInteger)tag];
    } backViewTap:^{
        
    }];
    
    [TJLPopView showMenuWithAnimation:YES];
}

#pragma mark -- 回调事件
- (void)doSomething:(NSString *)str tag:(NSInteger)tag{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:str message:[NSString stringWithFormat:@"点击了第%ld个菜单项",tag] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
