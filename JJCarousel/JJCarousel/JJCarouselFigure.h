//
//  JJCarouselFigure.h
//  JJCarousel
//
//  Created by Lance on 2018/4/28.
//  Copyright © 2018年 Lance. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Description page所在位置类型(默认中间)
 
 - JJPageMiddle: 中间
 - JJPageLeft: 左侧
 - JJPageRight: 右侧
 */
typedef NS_ENUM(NSUInteger, JJPageType) {
    
    JJPageMiddle = 0,
    JJPageLeft = 1,
    JJPageRight = 2
    
};

@interface JJCarouselFigure : UIView


@property (nonatomic, strong) NSArray *titlesArray;

- (instancetype)initWithFrame:(CGRect)frame pageType:(JJPageType)pageType;

/**
 Description 点击回调
 
 @param block block description
 */
- (void)tapFigureBlock:(void(^)(NSInteger index))block;

/**
 Description 设置图片
 
 @param images 网络图片路径或者本地图片
 @param block 网络图片加载回调
 */
- (void)setImages:(NSArray *)images loadingImageBlock:(void(^)(UIImageView *imageView, NSString *imageUrlStr))block;

@end
