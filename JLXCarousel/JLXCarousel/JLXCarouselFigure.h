//
//  JLXCarouselFigure.h
//  JLXCarousel
//
//  Created by Huatan on 17/8/14.
//  Copyright © 2017年 huatan. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Description page所在位置类型(默认中间)
 
 - JLXPageMiddle: 中间
 - JLXPageLeft: 左侧
 - JLXPageRight: 右侧
 */
typedef NS_ENUM(NSUInteger, JLXPageType) {
    
    JLXPageMiddle = 0,
    JLXPageLeft = 1,
    JLXPageRight = 2
    
};

@interface JLXCarouselFigure : UIView

@property (nonatomic, strong) NSArray *titlesArray;

- (instancetype)initWithFrame:(CGRect)frame pageType:(JLXPageType)pageType;

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
