//
//  JJCycleScrollView.h
//  JJCycleScrollView
//
//  Created by Lance on 2019/11/3.
//  Copyright © 2019 Lance. All rights reserved.
//  v1.0.1

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
Description PageControl控件的位置（默认居中）

- JJPageControlAlimentCenter: 居中
- JJPageControlAlimentLeft: 靠左
- JJPageControlAlimentRight: 靠右
*/
typedef NS_ENUM(NSUInteger, JJPageControlAliment) {
    JJPageControlAlimentCenter,
    JJPageControlAlimentLeft,
    JJPageControlAlimentRight
};

@protocol JJCycleScrollViewDelegate <NSObject>

@optional
- (void)jj_cycleScrollDidScrollToIndex:(NSInteger)index;//图片滚动的回调
- (void)jj_cycleScrollDidSelectItemAtIndex:(NSInteger)index;//点击回调
- (void)jj_cycleScrollLoadingImage:(UIImageView *)imageView url:(NSString *)url;//加载网络图片

@end

@interface JJCycleScrollView : UIView

@property (nonatomic, weak) id<JJCycleScrollViewDelegate> delegate;

/**
Description 图片滚动的回调
*/
@property (nonatomic, copy) void(^jj_cycleScrollDidScrollToIndexBlock)(NSInteger index);

/**
Description 点击回调
*/
@property (nonatomic, copy) void(^jj_cycleScrollDidSelectItemAtIndexBlock)(NSInteger index);

/**
Description 加载网络图片
*/
@property (nonatomic, copy) void(^jj_cycleScrollLoadingImageBlock)(UIImageView *imageView, NSString *url);

/**
 Description PageControl控件的位置（默认居中）
 */
@property (nonatomic, assign) JJPageControlAliment pageControlAliment;


/**
 Description 自动滚动时间间隔（默认3s）
 */
@property (nonatomic, assign) NSTimeInterval autoScrollInterval;

/**
 Description 是否隐藏PageControl控件（默认不隐藏）
 */
@property (nonatomic, assign) BOOL hiddenPageControl;

/**
 Description PageControl选中颜色（默认系统颜色）
 */
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;

/**
 Description PageControl非选中颜色（默认系统颜色）
 */
@property (nonatomic, strong) UIColor *pageIndicatorTintColor;

/**
 Description 动画缩放比（范围0～1，默认1）
 */
@property (nonatomic, assign) CGFloat itemZoomScale;

/**
 Description 图片间距（默认0）
 */
@property (nonatomic, assign) CGFloat itemSpacing;

/**
 Description 图片尺寸（范围最大为父控件尺寸）
 */
@property (nonatomic, assign) CGSize itemSize;

/**
 Description 底部背景颜色
 */
@property (nonatomic, strong) UIColor *bottomViewColor;

/**
 Description 轮播文字label字体颜色（默认白色）
 */
@property (nonatomic, strong) UIColor *titleLabelTextColor;

/**
 Description 轮播文字label字体大小（默认12）
 */
@property (nonatomic, strong) UIFont *titleLabelTextFont;

/**
 Description 图片圆角
 */
@property (nonatomic, assign) CGFloat imageCornerRadius;

/**
 Description 图片数组（url或者本地图片）
 */
@property (nonatomic, strong) NSArray *imagesArray;

/**
 Description 标题数组
 */
@property (nonatomic, strong) NSArray *titlesArray;


@end

NS_ASSUME_NONNULL_END
