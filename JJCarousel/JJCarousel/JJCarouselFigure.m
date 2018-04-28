//
//  JJCarouselFigure.m
//  JJCarousel
//
//  Created by Lance on 2018/4/28.
//  Copyright © 2018年 Lance. All rights reserved.
//

#import "JJCarouselFigure.h"

#define HT_Figure_BottomViewH 40
#define HT_Figure_TimeInterval 3


typedef void(^TapBlock) (NSInteger index);
typedef void(^LoadImageBlock) (UIImageView *imageView, NSString *imageUrlStr);

@interface JJCarouselFigure()<UIScrollViewDelegate>

@property (nonatomic, copy) TapBlock tapBlock;
@property (nonatomic, copy) LoadImageBlock loadImageBlock;
@property (nonatomic, assign) JJPageType pageType;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel *text;
@property (nonatomic, strong) NSMutableArray *currentImageArray;
@property (nonatomic, strong) NSMutableArray *currentTitleArray;
@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, weak) NSTimer *timer;

@end

static CGFloat figureWidth;
static CGFloat figureHeight;
@implementation JJCarouselFigure

- (NSMutableArray *)currentImageArray
{
    if (!_currentImageArray) {
        _currentImageArray = [NSMutableArray array];
    }
    return _currentImageArray;
}

- (NSMutableArray *)currentTitleArray
{
    if (!_currentTitleArray) {
        _currentTitleArray = [NSMutableArray array];
    }
    return _currentTitleArray;
}

- (instancetype)initWithFrame:(CGRect)frame pageType:(JJPageType)pageType
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.pageType = pageType;
        figureWidth = frame.size.width;
        figureHeight = frame.size.height;
        
    }
    return self;
}

/**
 Description 初始化scrollView
 */
- (void)setupScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.contentSize = CGSizeMake(figureWidth * 3, figureHeight);
    self.scrollView.contentOffset = CGPointMake(figureWidth, 0);
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    [self createCarouselFigureView];
    
}

/**
 Description 初始化imageView
 */
- (void)createCarouselFigureView
{
    for (NSInteger i = 0; i < 3; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(figureWidth * i, 0, figureWidth, figureHeight)];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tap];
        
        [self.scrollView addSubview:imageView];
    }
}

/**
 Description 轻拍方法
 
 @param tap UITapGestureRecognizer
 */
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    if (self.tapBlock) {
        self.tapBlock(self.currentPage);
    }
}

/**
 Description 初始化控件
 */
- (void)setupBottomView
{
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, figureHeight - HT_Figure_BottomViewH, figureWidth, HT_Figure_BottomViewH)];
    self.bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [self addSubview:_bottomView];
    
    //(figureWidth - self.imagesArray.count * 20) / 2
    
    NSInteger pageW = self.imagesArray.count * 20;
    NSInteger textL = 10;
    
    self.pageControl = [[UIPageControl alloc] init];
    [self.bottomView addSubview:_pageControl];
    
    
    self.text = [[UILabel alloc] init];
    self.text.textColor = [UIColor whiteColor];
    [self.bottomView addSubview:_text];
    
    switch (self.pageType) {
        case JJPageMiddle:
        {
            self.pageControl.frame = CGRectMake((figureWidth - pageW) / 2, 0, pageW, HT_Figure_BottomViewH);
            self.text.hidden = YES;
            
        }
            break;
        case JJPageLeft:
        {
            self.pageControl.frame = CGRectMake(0, 0, pageW, HT_Figure_BottomViewH);
            self.text.frame = CGRectMake(pageW, 0, figureWidth - pageW - textL, HT_Figure_BottomViewH);
            self.text.textAlignment = NSTextAlignmentRight;
        }
            break;
        case JJPageRight:
        {
            self.pageControl.frame = CGRectMake(figureWidth - pageW, 0, pageW, HT_Figure_BottomViewH);
            self.text.frame = CGRectMake(textL, 0, figureWidth - pageW - textL, HT_Figure_BottomViewH);
            self.text.textAlignment = NSTextAlignmentLeft;
        }
            break;
            
        default:
            break;
    }
}

/**
 Description 更新页码
 
 @param page page
 @return 当前页
 */
- (NSInteger)updatePage:(NSInteger)page
{
    NSInteger count = self.imagesArray.count;
    return (count + page) % count;
}

/**
 Description 更新当前页的图片
 
 @param page 当前页码
 */
- (void)updateCurrentViewWithCurrentPage:(NSInteger)page
{
    NSInteger pre = [self updatePage:page - 1];
    self.currentPage = [self updatePage:page];
    NSInteger last = [self updatePage:page + 1];
    
    [self.currentImageArray removeAllObjects];
    [self.currentTitleArray removeAllObjects];
    
    [self.currentImageArray addObject:self.imagesArray[pre]];
    [self.currentImageArray addObject:self.imagesArray[_currentPage]];
    [self.currentImageArray addObject:self.imagesArray[last]];
    
    if (self.titlesArray.count == self.imagesArray.count) {
        
        [self.currentTitleArray addObject:self.titlesArray[pre]];
        [self.currentTitleArray addObject:self.titlesArray[_currentPage]];
        [self.currentTitleArray addObject:self.titlesArray[last]];
    }
    
    NSArray *subArray = self.scrollView.subviews;
    for (NSInteger i = 0; i < 3; i++) {
        UIImageView *imageView = subArray[i];
        
        NSObject *object = self.currentImageArray[i];
        
        if ([object isKindOfClass:[UIImage class]]) {
            
            imageView.image = (UIImage *)object;
            
        } else {
            
            if (self.loadImageBlock) {
                self.loadImageBlock(imageView, self.currentImageArray[i]);
            }
        }
        
        if (self.titlesArray.count == self.imagesArray.count) {
            self.text.text = _currentTitleArray[1];
        }
    }
    
    self.scrollView.contentOffset = CGPointMake(figureWidth, 0);
    self.pageControl.currentPage = self.currentPage;
    
}


/**
 Description 设置scrollView偏移量
 */
- (void)play
{
    [self.scrollView setContentOffset:CGPointMake(figureWidth * 2, 0) animated:YES];
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat x = scrollView.contentOffset.x;
    
    if (x >= figureWidth * 2) {
        
        [self updateCurrentViewWithCurrentPage:self.currentPage + 1];
        
    } else if (x <= 0) {
        
        [self updateCurrentViewWithCurrentPage:self.currentPage - 1];
        
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
    
    [self.timer setFireDate:[NSDate dateWithTimeInterval:HT_Figure_TimeInterval sinceDate:[NSDate date]]];
}

/**
 Description 点击回调
 
 @param block block description
 */
- (void)tapFigureBlock:(void (^)(NSInteger))block
{
    if (block) {
        self.tapBlock = block;
    }
}

/**
 Description 设置图片
 
 @param images 网络图片路径或者本地图片
 @param block 网络图片加载回调
 */
- (void)setImages:(NSArray *)images loadingImageBlock:(void (^)(UIImageView *, NSString *))block
{
    if (images == nil || images.count == 0) return;
    
    self.imagesArray = images;
    
    [self setupScrollView];
    [self setupBottomView];
    
    if (block) {
        self.loadImageBlock = block;
    }
    
    self.pageControl.numberOfPages = images.count;
    [self updateCurrentViewWithCurrentPage:0];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:HT_Figure_TimeInterval target:self selector:@selector(play) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}


@end
