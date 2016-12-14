//
//  TJLPopView.h
//  TJLPopView
//
//  Created by Future on 2016/11/19.
//  Copyright © 2016年 Future. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ItemsClickBlock)(NSString *str, NSInteger tag);
typedef void(^BackViewTapBlock)();

@interface TJLPopView : UIView

@property (nonatomic,copy) ItemsClickBlock itemsClickBlock;
@property (nonatomic,copy) BackViewTapBlock backViewTapBlock;

@property (nonatomic,assign) NSInteger maxValueForItemCount;  // 最多菜单项个数，默认值：6;
/**
 *  menu
 *
 *  @param frame            菜单frame
 *  @param dataArray        菜单项内容
 *  @param itemsClickBlock  点击某个菜单项的blick
 *  @param backViewTapBlock 点击背景遮罩的block
 *
 *  @return 返回创建对象
 */
+ (TJLPopView *)createMenuWithFrame:(CGRect)frame dataArray:(NSArray *)dataArray itemsClickBlock:(void(^)(NSString *str, NSInteger tag))itemsClickBlock backViewTap:(void(^)())backViewTapBlock;

/**
 *  展示菜单
 *
 *  @param isShow YES:展示  NO:隐藏
 */
+ (void)showMenuWithAnimation:(BOOL)isShow;

/* 移除菜单 */
+ (void)clearMenu;

@end
