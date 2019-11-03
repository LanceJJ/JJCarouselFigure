//
//  JJCycleScrollView.m
//  JJCycleScrollView
//
//  Created by Lance on 2019/11/3.
//  Copyright © 2019 Lance. All rights reserved.
//

#import "JJCycleScrollView.h"

#define JJ_Figure_BottomViewH 40

typedef void(^JJSelectItemBlock) (NSInteger index);
typedef void(^JJLoadImageBlock) (UIImageView *imageView, NSString *url);

@interface JJCycleScrollView() <UIScrollViewDelegate>

@property (nonatomic, copy) JJSelectItemBlock selectItemBlock;
@property (nonatomic, copy) JJLoadImageBlock loadImageBlock;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray *currentImageArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) CGFloat itemWidth;

@end

@implementation JJCycleScrollView

- (NSMutableArray *)currentImageArray
{
    if (!_currentImageArray) {
        _currentImageArray = [NSMutableArray array];
    }
    return _currentImageArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupScrollView];
        [self setupImageView];
        [self setupBottomView];
        [self setupDefaultParameter];
        
    }
    return self;
}

/**
 Description 初始化默认参数
 */
- (void)setupDefaultParameter
{
    self.itemWidth = self.frame.size.width;
    self.itemHeight = self.frame.size.height;
    
    self.backgroundColor = [UIColor whiteColor];
    self.itemZoomScale = 1;
    self.itemSpacing = 0;
    self.itemSize = CGSizeMake(self.itemWidth, self.itemHeight);
    self.pageControlAliment = JJPageControlAlimentCenter;
    self.autoScrollInterval = 3.0;
    self.hiddenPageControl = NO;
}

/**
 Description 初始化scrollView
 */
- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.itemWidth, self.itemHeight)];
    scrollView.contentSize = CGSizeMake(self.itemWidth * 5, self.itemHeight);
    scrollView.contentOffset = CGPointMake(self.itemWidth * 2, 0);
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.clipsToBounds = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    
    self.scrollView = scrollView;
}

/**
 Description 初始化imageView
 */
- (void)setupImageView
{
    for (NSInteger i = 0; i < 5; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.itemWidth * i, 0, self.itemWidth, self.itemHeight)];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tap];
        
        [self.scrollView addSubview:imageView];
    }
}

/**
 Description 初始化控件
 */
- (void)setupBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.itemHeight - JJ_Figure_BottomViewH, self.itemWidth, JJ_Figure_BottomViewH)];
    bottomView.backgroundColor = [UIColor clearColor];
    [self addSubview:bottomView];
    
    self.bottomView = bottomView;
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    [self.bottomView addSubview:pageControl];
    
    self.pageControl = pageControl;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    [self.bottomView addSubview:titleLabel];
    
    self.titleLabel = titleLabel;
}

/**
 Description 添加定时器
 */
- (void)addTimer
{
    [self removeTimer];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollInterval target:self selector:@selector(play) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 Description 移除定时器
 */
- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

/**
 Description 更新页码
 
 @param page page
 @return 当前页
 */
- (NSInteger)updatePage:(NSInteger)page
{
    NSInteger count = self.imagesArray.count;
    return labs((count + page) % count);
}

/**
 Description 更新当前页的图片
 
 @param page 当前页码
 */
- (void)updateCurrentViewWithCurrentPage:(NSInteger)page
{
    NSInteger preRight = [self updatePage:page - 2];
    NSInteger pre = [self updatePage:page - 1];
    self.currentPage = [self updatePage:page];
    NSInteger last = [self updatePage:page + 1];
    NSInteger lastLift = [self updatePage:page + 2];
    
    [self.currentImageArray removeAllObjects];
    
    [self.currentImageArray addObject:self.imagesArray[preRight]];
    [self.currentImageArray addObject:self.imagesArray[pre]];
    [self.currentImageArray addObject:self.imagesArray[_currentPage]];
    [self.currentImageArray addObject:self.imagesArray[last]];
    [self.currentImageArray addObject:self.imagesArray[lastLift]];
    
    NSArray *subArray = self.scrollView.subviews;
    
    for (NSInteger i = 0; i < self.currentImageArray.count; i++) {
        UIImageView *imageView = subArray[i];
        
        NSObject *object = self.currentImageArray[i];
        
        if ([object isKindOfClass:[UIImage class]]) {
            
            imageView.image = (UIImage *)object;
            
        } else if ([object isKindOfClass:[NSString class]] && ([(NSString *)object hasPrefix:@"http:"] || [(NSString *)object hasPrefix:@"https:"])) {
            
            if (self.loadImageBlock) {
                self.loadImageBlock(imageView, (NSString *)object);
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(jj_cycleScrollLoadingImage:url:)]) {
                [self.delegate jj_cycleScrollLoadingImage:imageView url:(NSString *)object];
            }
        }
    }
    
    self.scrollView.contentOffset = CGPointMake(self.itemWidth * 2, 0);
    self.pageControl.currentPage = self.currentPage;
    
    if (self.titlesArray.count > self.currentPage) {
        self.titleLabel.text = self.titlesArray[self.currentPage];
    }
}

/**
 Description 更新控件布局
 */
- (void)updateSubviewsLayout
{
    self.itemWidth = self.itemSize.width;
    self.itemHeight = self.itemSize.height;
    
    CGFloat zoomScale = self.itemZoomScale;
    
    
    for (NSInteger i = 0; i < self.scrollView.subviews.count; i++) {
        UIImageView *imageView = self.scrollView.subviews[i];
        imageView.layer.transform = CATransform3DMakeScale(1, 1, 1.0);
        imageView.frame = CGRectMake((self.itemWidth - self.itemSpacing) * i + self.itemSpacing / 2.0 * (i * 2 + 1), 0, self.itemWidth - self.itemSpacing, self.itemHeight);
        imageView.layer.cornerRadius = self.imageCornerRadius;
        imageView.layer.transform = CATransform3DMakeScale(zoomScale, zoomScale, 1.0);
    }
    
    UIImageView *subview = (UIImageView *)[self.scrollView.subviews objectAtIndex:2];
    subview.layer.transform = CATransform3DMakeScale(1, 1, 1.0);
    
    CGFloat left = (self.frame.size.width - self.itemWidth) / 2;
    
    self.scrollView.frame = CGRectMake(left, (self.frame.size.height - self.itemHeight) / 2, self.itemWidth, self.itemHeight);
    self.scrollView.contentSize = CGSizeMake(self.itemWidth * 5, self.itemHeight);
    self.scrollView.contentOffset = CGPointMake(self.itemWidth * 2, 0);
    
    
    self.bottomView.frame = CGRectMake(0, self.itemHeight - JJ_Figure_BottomViewH, self.frame.size.width, JJ_Figure_BottomViewH);
    
    if (self.imagesArray.count == 0) return;
    
    NSInteger pageW = [self.pageControl sizeForNumberOfPages:self.imagesArray.count].width;
    NSInteger pageMargin = (self.frame.size.width - self.itemWidth) / 2;
    
    switch (self.pageControlAliment) {
        case JJPageControlAlimentCenter:
        {
            self.pageControl.frame = CGRectMake((self.itemWidth - pageW) / 2 + pageMargin, 0, pageW, JJ_Figure_BottomViewH);
            self.titleLabel.hidden = YES;
            
        }
            break;
        case JJPageControlAlimentLeft:
        {
            self.pageControl.frame = CGRectMake(pageMargin, 0, pageW, JJ_Figure_BottomViewH);
            self.titleLabel.frame = CGRectMake(pageW + pageMargin, 0, self.itemWidth - pageW, JJ_Figure_BottomViewH);
            self.titleLabel.textAlignment = NSTextAlignmentRight;
        }
            break;
        case JJPageControlAlimentRight:
        {
            self.pageControl.frame = CGRectMake(self.itemWidth + pageMargin - pageW, 0, pageW, JJ_Figure_BottomViewH);
            self.titleLabel.frame = CGRectMake(pageMargin, 0, self.itemWidth - pageW, JJ_Figure_BottomViewH);
            self.titleLabel.textAlignment = NSTextAlignmentLeft;
        }
            break;
            
        default:
            break;
    }
}

/**
 Description 设置scrollView偏移量
 */
- (void)play
{
    [self.scrollView setContentOffset:CGPointMake(self.itemWidth * 3, 0) animated:YES];
}

/**
 Description 轻拍方法
 
 @param tap UITapGestureRecognizer
 */
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if (self.selectItemBlock) {
        self.selectItemBlock(self.currentPage);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(jj_cycleScrollDidSelectItemAtIndex:)]) {
        [self.delegate jj_cycleScrollDidSelectItemAtIndex:self.currentPage];
    }
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    
    //    NSLog(@"%f", x);
    
    if (x >= self.itemWidth * 3) {
        
        [self updateCurrentViewWithCurrentPage:self.currentPage + 1];
        
    } else if (x <= self.itemWidth) {
        
        [self updateCurrentViewWithCurrentPage:self.currentPage - 1];
        
    }
    
    //普通类型不需要动画
    if (self.itemZoomScale >= 1) return;
    
    UIView *sub = (UIView*)[self.scrollView.subviews objectAtIndex:2];
    UIView *subRight = (UIView*)[self.scrollView.subviews objectAtIndex:3];
    UIView *subLift = (UIView*)[self.scrollView.subviews objectAtIndex:1];
    
    CGFloat sum = self.scrollView.contentOffset.x + (self.itemWidth) / 2;
    CGFloat centerX = sub.center.x;
    CGFloat diff = sum - centerX;
    CGFloat shortX = self.itemWidth;
    
    if (centerX <= sum && fabs(diff) <= shortX) {
        //向左滑动
        CGFloat scale = 1 - fabs(diff) / shortX * (1 - self.itemZoomScale);
        sub.layer.transform = CATransform3DMakeScale(scale, scale, 1.0);
        CGFloat scale1 = self.itemZoomScale + fabs(diff) / shortX * (1 - self.itemZoomScale);
        subRight.layer.transform = CATransform3DMakeScale(scale1, scale1, 1.0);
    }
    
    if (centerX >= sum && fabs(diff) <= shortX) {
        //向右滑动
        CGFloat scale = 1 - fabs(diff) / shortX * (1 - self.itemZoomScale);
        sub.layer.transform = CATransform3DMakeScale(scale, scale, 1.0);
        CGFloat scale1 = self.itemZoomScale + fabs(diff) / shortX * (1 - self.itemZoomScale);
        subLift.layer.transform = CATransform3DMakeScale(scale1, scale1, 1.0);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"开始了");
    
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"结束了");
    
    [self.timer setFireDate:[NSDate dateWithTimeInterval:self.autoScrollInterval sinceDate:[NSDate date]]];
}

/**
 Description 点击回调
 
 @param block block description
 */
- (void)selectItemBlock:(void (^)(NSInteger))block
{
    if (block) {
        self.selectItemBlock = block;
    }
}

/**
 Description 加载网络图片
 
 @param block 网络图片加载回调
 */
- (void)loadingImageBlock:(void(^)(UIImageView *imageView, NSString *url))block
{
    if (block) {
        self.loadImageBlock = block;
    }
}

- (void)setPageControlAliment:(JJPageControlAliment)pageControlAliment
{
    _pageControlAliment = pageControlAliment;
}

- (void)setAutoScrollInterval:(NSTimeInterval)autoScrollInterval
{
    _autoScrollInterval = autoScrollInterval;
    
    [self addTimer];
}

- (void)setHiddenPageControl:(BOOL)hiddenPageControl
{
    _hiddenPageControl = hiddenPageControl;
    
    self.pageControl.hidden = hiddenPageControl;
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
{
    _currentPageIndicatorTintColor = currentPageIndicatorTintColor;
    
    self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
{
    _pageIndicatorTintColor = pageIndicatorTintColor;
    
    self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}
- (void)setItemZoomScale:(CGFloat)itemZoomScale
{
    _itemZoomScale = itemZoomScale;
}

- (void)setItemSize:(CGSize)itemSize
{
    CGFloat itemWidth = itemSize.width > self.frame.size.width ? self.frame.size.width : itemSize.width;
    CGFloat itemHeight = itemSize.height > self.frame.size.height ? self.frame.size.height : itemSize.height;
    
    itemSize = CGSizeMake(itemWidth, itemHeight);
    
    _itemSize = itemSize;
}

- (void)setBottomViewColor:(UIColor *)bottomViewColor
{
    _bottomViewColor = bottomViewColor;
    
    self.bottomView.backgroundColor = bottomViewColor;
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor
{
    _titleLabelTextColor = titleLabelTextColor;
    
    self.titleLabel.textColor = titleLabelTextColor;
}

- (void)setTitleLabelTextFont:(UIFont *)titleLabelTextFont
{
    _titleLabelTextFont = titleLabelTextFont;
    
    self.titleLabel.font = titleLabelTextFont;
}

- (void)setImagesArray:(NSArray *)imagesArray
{
    _imagesArray = imagesArray;
    
    [self updateSubviewsLayout];
    
    self.pageControl.numberOfPages = imagesArray.count;
    [self updateCurrentViewWithCurrentPage:0];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self updateSubviewsLayout];
}

@end

