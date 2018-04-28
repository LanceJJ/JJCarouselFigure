//
//  ViewController.m
//  JJCarousel
//
//  Created by Lance on 2018/4/28.
//  Copyright © 2018年 Lance. All rights reserved.
//

#import "ViewController.h"
#import "JJCarouselFigure.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //创建
    JJCarouselFigure *view = [[JJCarouselFigure alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.width * 488 / 750) pageType:JJPageMiddle];
    //图片（本地+网络）
    NSArray *images = @[[UIImage imageNamed:@"20170406135300.jpg"],
                        [UIImage imageNamed:@"20170406135400.jpg"],
                        [UIImage imageNamed:@"20140306110441515.jpg"],
                        @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2047158/beerhenge.jpg",
                        @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2016158/avalanche.jpg",
                        @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1839353/pilsner.jpg"];
    //标题（可以不设置）
    NSArray *titles = @[@"图片一",
                        @"图片二",
                        @"图片三",
                        @"图片四",
                        @"图片五",
                        @"图片六"];
    
    view.titlesArray = titles;
    
    //加载数据源，网络图片回调加载
    [view setImages:images loadingImageBlock:^(UIImageView *imageView, NSString *imageUrlStr) {
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] completed:nil];
        
    }];
    
    //点击图片回调
    [view tapFigureBlock:^(NSInteger index) {
        
        NSLog(@"%ld", (long)index);
        
    }];
    
    //添加
    [self.view addSubview:view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
