//
//  BaseIndexController.m
//  rehab
//
//  Created by 何寻 on 6/18/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "BaseIndexController.h"

@interface BaseIndexController ()<UIScrollViewDelegate>
@end

@implementation BaseIndexController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - network
-(void)layout {
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    BOOL biPad = [WRUIConfig IsHDApp];
    CGRect frame = self.scrollView.frame;
    UIImage *bannerImage = [UIImage imageNamed:@"well_default_video"];
    CGFloat x = biPad ? 100 : 0, y = 0, cx = frame.size.width - 2*x, cy = cx*bannerImage.size.height/bannerImage.size.width, offset = WRUILittleOffset;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
    scrollView.clipsToBounds = !biPad;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = YES;
    scrollView.delegate = self;
    [self.scrollView addSubview:scrollView];
    _bannerScrollView = scrollView;
    
    UIColor *crBackground = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.65];
    if(biPad)
    {
        if(x > 0)
        {
            cx = x;
            x = 0;
            UIImage *image = PNG_IMAGE_NAMED(@"left");
            UIImage *imageFocus = PNG_IMAGE_NAMED(@"left_focus");
            for(int index = 0; index < 2; index++)
            {
                image = [image imageByResizeToSize:CGSizeMake(80, 80)];
                imageFocus = [imageFocus imageByResizeToSize:CGSizeMake(80, 80)];
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
                view.backgroundColor = crBackground;
                [self.scrollView addSubview:view];
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setImage:image forState:UIControlStateDisabled];
                [btn setImage:imageFocus forState:UIControlStateNormal];
                btn.frame = CGRectMake((cx - image.size.width)/2, (cy - image.size.height)/2, image.size.width, image.size.height);
                btn.tag = index;
                [btn addTarget:self action:@selector(onClickedBannerPositionButton:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:btn];
                if(index == 0)
                {
                    _leftButton = btn;
                }
                else
                {
                    _rightButton = btn;
                }
                image = PNG_IMAGE_NAMED(@"right");
                imageFocus = PNG_IMAGE_NAMED(@"right_focus");
                x = CGRectGetMaxX(_bannerScrollView.frame);
            }
        }
    }
    x = CGRectGetMinX(_bannerScrollView.frame);
    cx = CGRectGetWidth(_bannerScrollView.bounds);
    cy = [UIFont labelFontSize] + 2*offset;
    y = CGRectGetMaxY(_bannerScrollView.frame) - cy;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
    label.numberOfLines = 1;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = crBackground;
    label.textColor = [UIColor whiteColor];
    if(!biPad)
    {
        label.font = [UIFont wr_textFont];
    }
    label.hidden = YES;
    [self.scrollView addSubview:label];
    _bannerDetailLabel = label;
    
    NSInteger tag = 0;
    if(_bannerInfoArray.count > 0)
    {
        [_bannerScrollTimer invalidate];
        _bannerScrollTimer = nil;
        
        x = 0, y = 0, cx = _bannerScrollView.frame.size.width, cy = _bannerScrollView.frame.size.height;
        for(int i = 0; i < (_bannerInfoArray.count + 2); i++)
        {
            id item = nil;
            if(i == 0)
            {
                tag = _bannerInfoArray.count - 1;
                item = [_bannerInfoArray lastObject];
            }
            else if(i == (_bannerInfoArray.count + 1))
            {
                tag = 0;
                item = [_bannerInfoArray objectAtIndex:0];
            }
            else
            {
                tag =  i - 1;
                item = [_bannerInfoArray objectAtIndex:(i - 1)];
            }
            
            NSString* imgUrl = [self getBannerImageUrlString:item];
            UIImageView *bannerView = [[UIImageView alloc] init];
            /*
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:imgUrl] placeholderImage:bannerImage];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
            button.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
            */
            bannerView.frame = CGRectMake(x, y, cx, cy);
            bannerView.tag = tag;
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickedBannerImage:)];
            bannerView.userInteractionEnabled = YES;
            [bannerView addGestureRecognizer:tapGestureRecognizer];
            //[button addTarget:self action:@selector(onClickedBannerImage:) forControlEvents:UIControlEventTouchUpInside];
            [_bannerScrollView addSubview:bannerView];
            [bannerView setImageWithUrlString:imgUrl holder:@"well_default_video"];
            
            x += cx;
        }
        _bannerScrollView.contentSize = CGSizeMake(x, _bannerScrollView.frame.size.height);
        
        UIPageControl *pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectZero];
        pageCtrl.backgroundColor = [UIColor clearColor];
        pageCtrl.userInteractionEnabled = YES;
        pageCtrl.pageIndicatorTintColor = [UIColor whiteColor];
        pageCtrl.currentPageIndicatorTintColor = [UIColor wr_themeColor];
        
        //[pageCtrl setImagePageStateNormal:PNG_IMAGE_NAMED(img_point)];
        //[pageCtrl setImagePageStateHighlighted:PNG_IMAGE_NAMED(img_point_focus)];
        
        [pageCtrl sizeToFit];
        [pageCtrl addTarget:self action:@selector(onPageChanged:) forControlEvents:UIControlEventValueChanged];
        [self.scrollView addSubview:pageCtrl];
        _bannerPageCtrl = pageCtrl;
        
        _bannerPageCtrl.numberOfPages = _bannerInfoArray.count;
        _bannerPageCtrl.currentPage = 0;
        cx = _bannerPageCtrl.frame.size.width;
        cy = _bannerPageCtrl.frame.size.height;
        x = CGRectGetMidX(_bannerScrollView.frame) - cx/2;
        y = CGRectGetMinY(_bannerDetailLabel.frame);// -  _bannerDetailLabel.bounds.size.height;
        if(!biPad)
        {
            y += 3*offset;
        }
        _bannerPageCtrl.frame = CGRectMake(x, y, cx ,cy);
        
        _bannerScrollView.contentOffset = CGPointMake(_bannerScrollView.frame.size.width, 0);
        [self showBanner:0];
        
        _bannerScrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
    }
    y = CGRectGetMaxY(_bannerScrollView.frame) + offset;
    y = [self layoutOtherViews:y];
    
    self.scrollView.contentSize = CGSizeMake(frame.size.width, y);
}

#pragma mark - UIScrollView Delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(scrollView == _bannerScrollView)
    {
        [_bannerScrollTimer invalidate];
        _bannerScrollTimer = nil;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == _bannerScrollView)
    {
        [self updateBannerInfo];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView == _bannerScrollView)
    {
        if(_bannerScrollTimer == nil)
        {
            _bannerScrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if(scrollView == _bannerScrollView)
    {
        [self updateBannerInfo];
    }
}

#pragma mark - Controls Events
-(IBAction)onClickedBannerPositionButton:(UIButton*)sender
{
    [_bannerScrollTimer invalidate];
    _bannerScrollTimer = nil;
    if(sender == _leftButton)
    {
        CGFloat x = (floorf(_bannerScrollView.contentOffset.x/_bannerScrollView.bounds.size.width) - 1)*_bannerScrollView.bounds.size.width;
        [_bannerScrollView setContentOffset:CGPointMake(x, _bannerScrollView.contentOffset.y) animated:YES];
        //[_bannerScrollView setContentOffset:CGPointMake(_bannerScrollView.contentOffset.x - _bannerScrollView.bounds.size.width, _bannerScrollView.contentOffset.y) animated:YES];
    }
    else if(sender == _rightButton)
    {
        
        [self scrollToNextPage:nil];
        //[_bannerScrollView setContentOffset:CGPointMake(_bannerScrollView.contentOffset.x + _bannerScrollView.bounds.size.width, _bannerScrollView.contentOffset.y) animated:YES];
    }
    if(!_bannerScrollView.dragging)
    {
        _bannerScrollTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:YES];
    }
}

-(void)onPageChanged:(id)sender
{
    CGSize viewSize = _bannerScrollView.frame.size;
    [_bannerScrollView setContentOffset:CGPointMake((_bannerScrollView.contentOffset.x + viewSize.width), 0) animated:YES];
    NSInteger index = _bannerPageCtrl.currentPage;
    [self showBanner:index];
}

-(IBAction)onClickedBannerImage:(UITapGestureRecognizer*)sender
{
    [self actionOnItem:_bannerInfoArray index:sender.view.tag];
}

#pragma mark -
-(void)updateBannerInfo
{
    CGFloat pageWidth = _bannerScrollView.frame.size.width;
    if((_bannerScrollView.contentOffset.x + pageWidth) >= _bannerScrollView.contentSize.width)
    {
        [_bannerScrollView setContentOffset:CGPointMake(pageWidth, 0)];
    }
    else if(_bannerScrollView.contentOffset.x <= 0)
    {
        [_bannerScrollView setContentOffset:CGPointMake(_bannerScrollView.contentSize.width - 2*pageWidth, 0)];
    }
    int pageIndex = _bannerScrollView.contentOffset.x/pageWidth;
    if(pageIndex >= 1)
    {
        pageIndex--;
    }
    _bannerPageCtrl.currentPage = pageIndex;
    [self showBanner:_bannerPageCtrl.currentPage];
}

-(void)scrollToNextPage:(id)sender
{
    [_bannerScrollView setContentOffset:CGPointMake((_bannerPageCtrl.currentPage + 1 + 1)*_bannerScrollView.bounds.size.width, _bannerScrollView.contentOffset.y) animated:YES];
}

-(void)showBanner:(NSUInteger)index {
    [self showBannerInfo:index];
    _leftButton.enabled = (index != 0);
    _rightButton.enabled = (index != (_bannerInfoArray.count - 1));
}

-(CGFloat)layoutOtherViews:(CGFloat)y {
    return 0;
}

-(NSString *)getBannerImageUrlString:(id)item
{
    return @"";
}

-(void)showBannerInfo:(NSUInteger)index {
    
}

-(void)actionOnItem:(NSArray*)data index:(NSUInteger)index
{
    
}

@end
