//
//  LTDownListView.h
//  LTCarouselView
//
//  Created by Jonny on 16/3/14.
//  Copyright © 2016年 Jonny. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LTDownListViewDelegate;

/* 侧滑菜单 二级列表 */

@class LTClassifyModel;
@interface LTDownListView : UIView

@property(nonatomic,weak) id<LTDownListViewDelegate> delegate;

@property(nonatomic,strong)NSArray *classifyArr;     ///< 分类数组

/* 隐藏 */
- (void)hideView;

/* 显示 */
- (void)showPhotoActionSheet;

@end

@protocol LTDownListViewDelegate <NSObject>

/**
 *  动画消失之后方法
 *
 *  @param downListView 本类
 */
- (void)hideAnimationWithOver:(LTDownListView *)downListView;

/**
 *  选择分类回调
 *
 *  @param downListView 本类
 */
- (void)selectorClassifyWithRow:(LTDownListView *)downListView classifyModel:(LTClassifyModel *)classifyModel;

@end






