# JJCarouselFigure

## 一款简单实用的无限轮播图

* 可以设置UIPageControl在不同位置显示，左侧，中间，右侧，当UIPageControl在中间显示时，默认不显示文本
* 可以同时支持本地图片与网络图片
* 当有网络图片时，在数组中添加图片路径，加载网络图片的方法，可以在外放的回调中进行维护

```objc
    //图片（本地+网络）
    NSArray *images = @[[UIImage imageNamed:@"20170406135300.jpg"],
                        [UIImage imageNamed:@"20170406135400.jpg"],
                        [UIImage imageNamed:@"20140306110441515.jpg"],
                        @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2047158/beerhenge.jpg",
                        @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2016158/avalanche.jpg",
                        @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1839353/pilsner.jpg"];
```	

```objc
     //加载数据源，网络图片回调加载
    [view setImages:images loadingImageBlock:^(UIImageView *imageView, NSString *imageUrlStr) {
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr] completed:nil];
        
    }];
```	

## 使用方法
* 导入JJCarousel文件，按步骤创建即可

```objc
    
    //创建
    JJCarouselFigure *view = [[JJCarouselFigure alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.width * 488 / 750) pageType:JJPageMiddle];
    //图片（本地+网络）
    NSArray *images = @[[UIImage imageNamed:@"20170406135300.jpg"],
                        [UIImage imageNamed:@"20170406135400.jpg"],
                        [UIImage imageNamed:@"20140306110441515.jpg"],
                        @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2047158/beerhenge.jpg",
                        @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2016158/avalanche.jpg",
                        @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1839353/pilsner.jpg"];
    //图片标题（可以不设置）（当标题个数与图片个数不一致时，也不显示标题）
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
    
```	

## 效果图

![](https://github.com/LanceJJ/JJCarouselFigure/raw/master/JJCarousel/Image/SimulatorScreenShot20171017102218.png)
![](https://github.com/LanceJJ/JJCarouselFigure/raw/master/JJCarousel/Image/SimulatorScreenShot20171017102417.png)
![](https://github.com/LanceJJ/JJCarouselFigure/raw/master/JJCarousel/Image/SimulatorScreenShot20171017102317.png)
![](https://github.com/LanceJJ/JJCarouselFigure/raw/master/JJCarousel/Image/ezgif-1-365bd769d5.gif)
