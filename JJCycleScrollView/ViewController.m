//
//  ViewController.m
//  JJCycleScrollView
//
//  Created by Lance on 2019/11/3.
//  Copyright © 2019 Lance. All rights reserved.
//

#import "ViewController.h"
#import "JJCycleScrollView.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface ViewController () <JJCycleScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self setupCycleScrollViewType1];
    [self setupCycleScrollViewType2];
    [self setupCycleScrollViewType3];
}

- (void)setupCycleScrollViewType1
{
    //创建
    JJCycleScrollView *view = [[JJCycleScrollView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.width * 180 / 375)];
    view.delegate = self;
    view.pageControlAliment = JJPageControlAlimentCenter;
    view.itemZoomScale = 1;
    //    view.currentPageIndicatorTintColor = [UIColor redColor];
    //    view.pageIndicatorTintColor = [UIColor blueColor];
    //    view.bottomViewColor = [UIColor colorWithWhite:0 alpha:0.5];
    ////    //标题（可以不设置）
    //    NSArray *titles = @[@"图片一",
    //                        @"图片二",
    //                        @"图片三"];
    
    //    view.titlesArray = titles;
    
    //网络图片回调加载
    [view loadingImageBlock:^(UIImageView *imageView, NSString *url) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:url] completed:nil];
    }];
    
    //点击图片回调
    [view selectItemBlock:^(NSInteger index) {
        NSLog(@"%ld", (long)index);
    }];
    
    //添加
    [self.view addSubview:view];
    
    //图片（本地+网络）
    NSArray *images = @[[UIImage imageNamed:@"20170406135300.jpg"],
                        [UIImage imageNamed:@"20170406135400.jpg"],
                        [UIImage imageNamed:@"20140306110441515.jpg"],
                        @"https://s-media-cache-ak0.pinimg.com/1200x/2e/0c/c5/2e0cc5d86e7b7cd42af225c29f21c37f.jpg"];

    
    
    view.imagesArray = images;
}

- (void)setupCycleScrollViewType2
{
    //创建
    JJCycleScrollView *view = [[JJCycleScrollView alloc] initWithFrame:CGRectMake(0, 220, self.view.frame.size.width, self.view.frame.size.width * 180 / 375)];
    view.delegate = self;
    view.pageControlAliment = JJPageControlAlimentCenter;
    view.itemZoomScale = 1;
    view.itemSpacing = 10;
    view.itemSize = CGSizeMake(view.frame.size.width - 50, view.frame.size.width);
    //    view.currentPageIndicatorTintColor = [UIColor redColor];
    //    view.pageIndicatorTintColor = [UIColor blueColor];
    //    view.bottomViewColor = [UIColor colorWithWhite:0 alpha:0.5];
    ////    //标题（可以不设置）
    //    NSArray *titles = @[@"图片一",
    //                        @"图片二",
    //                        @"图片三"];
    
    //    view.titlesArray = titles;
    
    //网络图片回调加载
    [view loadingImageBlock:^(UIImageView *imageView, NSString *url) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:url] completed:nil];
    }];
    
    //点击图片回调
    [view selectItemBlock:^(NSInteger index) {
        NSLog(@"%ld", (long)index);
    }];
    
    //添加
    [self.view addSubview:view];
    
    //图片（本地+网络）
    NSArray *images = @[[UIImage imageNamed:@"20170406135300.jpg"],
                        [UIImage imageNamed:@"20170406135400.jpg"],
                        [UIImage imageNamed:@"20140306110441515.jpg"],
                        @"https://s-media-cache-ak0.pinimg.com/1200x/2e/0c/c5/2e0cc5d86e7b7cd42af225c29f21c37f.jpg"];
    
    view.imagesArray = images;
}

- (void)setupCycleScrollViewType3
{
    //创建
    JJCycleScrollView *view = [[JJCycleScrollView alloc] initWithFrame:CGRectMake(0, 420, self.view.frame.size.width, self.view.frame.size.width * 180 / 375)];
    view.delegate = self;
    view.pageControlAliment = JJPageControlAlimentCenter;
    view.imageCornerRadius = 5;
    view.itemZoomScale = 1;
    view.itemZoomScale = 0.9;
    view.itemSize = CGSizeMake(view.frame.size.width - 50, view.frame.size.width);
    //    view.currentPageIndicatorTintColor = [UIColor redColor];
    //    view.pageIndicatorTintColor = [UIColor blueColor];
    //    view.bottomViewColor = [UIColor colorWithWhite:0 alpha:0.5];
    ////    //标题（可以不设置）
    //    NSArray *titles = @[@"图片一",
    //                        @"图片二",
    //                        @"图片三"];
    
    //    view.titlesArray = titles;
    
    //网络图片回调加载
    [view loadingImageBlock:^(UIImageView *imageView, NSString *url) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:url] completed:nil];
    }];
    
    //点击图片回调
    [view selectItemBlock:^(NSInteger index) {
        NSLog(@"%ld", (long)index);
    }];
    
    //添加
    [self.view addSubview:view];
    
    //图片（本地+网络）
    NSArray *images = @[[UIImage imageNamed:@"20170406135300.jpg"],
                        [UIImage imageNamed:@"20170406135400.jpg"],
                        [UIImage imageNamed:@"20140306110441515.jpg"],
                        @"https://s-media-cache-ak0.pinimg.com/1200x/2e/0c/c5/2e0cc5d86e7b7cd42af225c29f21c37f.jpg"];
    
    view.imagesArray = images;
}

#pragma mark -- JJCycleScrollViewDelegate Delegate
- (void)jj_cycleScrollLoadingImage:(UIImageView *)imageView url:(NSString *)url
{
//    [imageView sd_setImageWithURL:[NSURL URLWithString:url] completed:nil];
}

- (void)jj_cycleScrollDidSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"点击了-%ld", (long)index);
}

@end
