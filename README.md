# JJCarouselFigure

## 一款简单实用的无限轮播图

* 可以设置UIPageControl在不同位置显示，左侧，中间，右侧，当UIPageControl在中间显示时，默认不显示文本
* 可以同时支持本地图片与网络图片
* 当有网络图片时，在数组中添加图片路径，加载网络图片的方法，可以在外放的回调中进行维护
* 新增缩放模式

```objc
    //图片（本地+网络）
    NSArray *images = @[[UIImage imageNamed:@"20170406135300.jpg"],
                        [UIImage imageNamed:@"20170406135400.jpg"],
                        [UIImage imageNamed:@"20140306110441515.jpg"],
                        @"https://s-media-cache-ak0.pinimg.com/1200x/2e/0c/c5/2e0cc5d86e7b7cd42af225c29f21c37f.jpg"];
```	

```objc
     //网络图片回调加载
    [view loadingImageBlock:^(UIImageView *imageView, NSString *url) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:url] completed:nil];
    }];
```	

## 使用方法
* JJCycleScrollView，按步骤创建即可

```objc
    
    //创建
    JJCycleScrollView *view = [[JJCycleScrollView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.width * 180 / 375)];
    view.delegate = self;
    view.pageControlAliment = JJPageControlAlimentCenter;
    view.itemZoomScale = 1;//缩放比为1时，普通样式（可以更改缩放比来实现轮播图的缩放效果）
    //    view.itemSpacing = 10;图片之间的间距
    //    view.itemSize = CGSizeMake(view.frame.size.width - 50, view.frame.size.width);//图片的尺寸
    //    view.currentPageIndicatorTintColor = [UIColor redColor];
    //    view.pageIndicatorTintColor = [UIColor blueColor];
    //    view.bottomViewColor = [UIColor colorWithWhite:0 alpha:0.5];
    ////    //标题（可以不设置）
    //    NSArray *titles = @[@"图片一",
    //                        @"图片二",
    //                        @"图片三"];
    
    //    view.titlesArray = titles;
    
    //网络图片回调加载（可以使用block，也可以使用代理）
    [view loadingImageBlock:^(UIImageView *imageView, NSString *url) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:url] completed:nil];
    }];
    
    //点击图片回调（可以使用block，也可以使用代理）
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
    
    
    #pragma mark -- JJCycleScrollViewDelegate Delegate
    //（可以使用block，也可以使用代理）
    - (void)jj_cycleScrollLoadingImage:(UIImageView *)imageView url:(NSString *)url
    {
    //    [imageView sd_setImageWithURL:[NSURL URLWithString:url] completed:nil];
    }

    //（可以使用block，也可以使用代理）
    - (void)jj_cycleScrollDidSelectItemAtIndex:(NSInteger)index
    {
        NSLog(@"点击了-%ld", (long)index);
    }
    
```	

## 效果图

![](https://github.com/LanceJJ/JJCycleScrollView/raw/master/JJCycleScrollView/Image/IMG_0319.PNG)

