//
//  TJLPopView.m
//  TJLPopView
//
//  Created by Future on 2016/11/19.
//  Copyright © 2016年 Future. All rights reserved.
//

#import "TJLPopView.h"
#import "PopCell.h"

#define KRowHeight 40   // cell行高
#define KDefaultMaxValue 4  // 菜单项最大值
#define KNavigationBar_H 64 // 导航栏64
#define KIPhoneSE_ScreenW 375
#define KIPhone4_Transverse  480
#define KMargin 15

#define MENU_TAG 99999  // MenuView的tag
#define BACKVIEW_TAG 88888  // 背景遮罩view的tag

@interface TJLPopView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UITableView *popTable;
@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,strong) UIView * backView;
@property (nonatomic,strong) NSMutableArray * dataArray;

@end

@implementation TJLPopView

- (void)setMaxValueForItemCount:(NSInteger)maxValueForItemCount{
    if (maxValueForItemCount <= KDefaultMaxValue) {
        _maxValueForItemCount = maxValueForItemCount;
    }else{
        _maxValueForItemCount = KDefaultMaxValue;
    }
}

+ (TJLPopView *)createMenuWithFrame:(CGRect)frame dataArray:(NSArray *)dataArray itemsClickBlock:(void (^)(NSString *, NSInteger))itemsClickBlock backViewTap:(void (^)())backViewTapBlock
{
    // 计算frame
    CGFloat factor = [UIScreen mainScreen].bounds.size.width < KIPhoneSE_ScreenW ? 0.36 : 0.3; // 适配比例
    CGFloat width = frame.size.width ? frame.size.width : ([UIScreen mainScreen].bounds.size.width > 480 ? 120 : [UIScreen mainScreen].bounds.size.width * factor);
//    [UIScreen mainScreen].bounds.size.width * factor;
    CGFloat height = dataArray.count > KDefaultMaxValue ? KDefaultMaxValue * KRowHeight : dataArray.count * KRowHeight;
    CGFloat x = frame.origin.x ? frame.origin.x : [UIScreen mainScreen].bounds.size.width - width - KMargin * 0.5;
    CGFloat y = frame.origin.y ? frame.origin.y : KNavigationBar_H - KMargin * 0.5;
    CGRect rect = CGRectMake(x, y, width, height);    // 菜单中tableView的frame
    frame = CGRectMake(x, y, width, height + KMargin); // 菜单的整体frame
    
    TJLPopView *menuView = [[TJLPopView alloc] init];
    menuView.tag = MENU_TAG;
    menuView.frame = frame;
    menuView.layer.anchorPoint = CGPointMake(0.9, 0);
    menuView.layer.position = CGPointMake(frame.origin.x + frame.size.width - KMargin, frame.origin.y);
    menuView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    menuView.dataArray = [NSMutableArray arrayWithArray:dataArray];
    menuView.itemsClickBlock = itemsClickBlock;
    menuView.backViewTapBlock = backViewTapBlock;
    menuView.maxValueForItemCount = dataArray.count;
    
    [menuView setUpUIWithFrame:rect];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:menuView];
    return menuView;
}

- (void)setUpUIWithFrame:(CGRect)frame{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.image = [UIImage imageNamed:@"pop_black_backGround"];
    imageView.layer.anchorPoint = CGPointMake(1, 0);
    imageView.layer.position = CGPointMake(self.bounds.size.width, 0);
    self.imageView = imageView;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 15, frame.size.width, frame.size.height)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.bounces = NO;
    self.tableView.rowHeight = KRowHeight;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"PopCell" bundle:nil] forCellReuseIdentifier:@"Popcell"];
    
    UIView *backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.userInteractionEnabled = YES;
    backView.alpha = 0.0;
    backView.tag = BACKVIEW_TAG;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [backView addGestureRecognizer:tap];
    self.backView = backView;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:backView];
    
    [self addSubview:imageView];
    [self addSubview:self.tableView];
}

#pragma mark -- Show With Animation
+ (void)showMenuWithAnimation:(BOOL)isShow{
    
    TJLPopView *menuView = [[UIApplication sharedApplication].keyWindow viewWithTag:MENU_TAG];
    UIView *backView = [[UIApplication sharedApplication].keyWindow viewWithTag:BACKVIEW_TAG];
    menuView.tableView.contentOffset = CGPointZero;
    [UIView animateWithDuration:0.25 animations:^{
        if (isShow) {
            menuView.alpha = 1;
            backView.alpha = 0.1;
            menuView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }else{
            menuView.alpha = 0;
            backView.alpha = 0;
            menuView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        }
    }];
}


#pragma mark -- UITapGestureRecognizer
- (void)tap:(UITapGestureRecognizer *)sender{
    [TJLPopView showMenuWithAnimation:NO];
    if (self.backViewTapBlock) {
        self.backViewTapBlock();
    }
    [TJLPopView clearMenu];
}

#pragma mark -- UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    PopCell *cell = (PopCell *)[tableView dequeueReusableCellWithIdentifier:@"Popcell" forIndexPath:indexPath];
    cell.titleImage.image = [UIImage imageNamed:dict[@"image"]];
    cell.titleLabel.text = dict[@"name"];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    NSInteger tag = indexPath.row + 1;
    if (self.itemsClickBlock) {
        self.itemsClickBlock(dict[@"name"],tag);
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [TJLPopView clearMenu];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KRowHeight;
}


+ (void)clearMenu{
    [TJLPopView showMenuWithAnimation:NO];
    TJLPopView *menuView = [[UIApplication sharedApplication].keyWindow viewWithTag:MENU_TAG];
    UIView *backView = [[UIApplication sharedApplication].keyWindow viewWithTag:BACKVIEW_TAG];
    [menuView removeFromSuperview];
    [backView removeFromSuperview];
}

@end
