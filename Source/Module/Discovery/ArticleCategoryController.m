//
//  ArticleCategoryController.m
//  rehab
//
//  Created by herson on 2016/9/22.
//  Copyright © 2016年 WELL. All rights reserved.
//

#import "ArticleCategoryController.h"
#import "ArticleListController.h"
#import "ShareData.h"
#import <YYKit/YYKit.h>
#define top_height 0

@interface ArticleCategoryController ()<UIScrollViewDelegate>

@property(nonatomic)NSMutableArray<UIView*>* subjectViewsArray, *subjectTitleViewsArray;

@property(nonatomic)UIScrollView* scrollView;
@property(nonatomic)UIView *detailView;

@property(nonatomic)ArticleListController *detailController;

@end

@implementation ArticleCategoryController

-(instancetype)init {
    if (self = [super init]) {
        /*
        UIImage *image = [UIImage imageNamed:@"main_discovery_bg"] ;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, imageView.width*2/3, imageView.height*2/3);
        [self.view addSubview:imageView];
        self.view.backgroundColor = [UIColor wr_lightGray];
        */
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [WRNetworkService pwiki:@"专题"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
#if 0
    if (!_detailController) {
        /*
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        [self.view addSubview:scrollView];
        self.scrollView = scrollView;
        */
        __weak __typeof(self) weakSelf = self;
        NSUInteger count = [ShareData data].categoryArray.count;
        
        UIImage *placeHolderImage = [UIImage imageNamed:@"well_default_video"];
        for(NSUInteger index = 0; index < count; index++)
        {
            WRCategory *object = [ShareData data].categoryArray[index];
            
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.tag = index;
            imageView.userInteractionEnabled = YES;
            imageView.contentMode =  UIViewContentModeScaleToFill;
            //imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            //imageView.clipsToBounds  = YES;
            //[imageView wr_setShadow];
            
            imageView.layer.shadowColor = [UIColor blackColor].CGColor;
            imageView.layer.shadowOffset = CGSizeMake(4,4);
            imageView.layer.shadowOpacity = 0.8;
            imageView.layer.shadowRadius = 4;
            [imageView bk_whenTapped:^{
                if (imageView.left > 0) {
                    [weakSelf showSubjectWithIndex:imageView.tag];
                } else {
                    [UIView animateWithDuration:0.5 animations:^{
                        [weakSelf rawLayout];
                        [weakSelf resetScrollView];
                        //weakSelf.scrollView.panGestureRecognizer.delaysTouchesBegan = NO;
                    }];
                }
                
            }];
            
            //[self.scrollView addSubview:imageView];
            [self.view addSubview:imageView];
            
            [imageView setImageWithUrlString:object.logoImgUrl holderImage:placeHolderImage];
            [self.subjectViewsArray addObject:imageView];
            
            UILabel *label = [UILabel new];
            label.text = object.name;
            label.font = [UIFont wr_smallFont];
            label.textColor = [UIColor darkGrayColor];
            label.tag = index;
            label.textAlignment = NSTextAlignmentCenter;
            [label sizeToFit];
            label.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
            [imageView addSubview:label];
            
            [self.subjectTitleViewsArray addObject:label];
        }
        
        ArticleListController *viewController = [[ArticleListController alloc] init];
        viewController.rootController = self;
        _detailController = viewController;
        _detailView = _detailController.tableView;
        _detailView.backgroundColor = [UIColor clearColor];
        [_detailController.tableView removeFromSuperview];
        [self.view addSubview:_detailView];
        
        [self rawLayout];
        [self resetScrollView];
    }
#endif
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        [self.view addSubview:scrollView];
        self.scrollView = scrollView;
        
        CGFloat offset = WRUIOffset, x = 0, y = offset, cx = self.scrollView.width, cy;
        
        //__weak __typeof(self) weakSelf = self;
        NSUInteger count = [ShareData data].categoryArray.count;
        UIImage *placeHolderImage = [UIImage imageNamed:@"well_default_video"];
        cy = cx*placeHolderImage.size.height/placeHolderImage.size.width;
        
        for(NSUInteger index = 0; index < count; index++)
        {
            WRCategory *object = [ShareData data].categoryArray[index];
            
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.tag = index;
            imageView.userInteractionEnabled = YES;
            imageView.contentMode =  UIViewContentModeScaleToFill;
            imageView.frame = CGRectMake(x, y, cx, cy);
            [imageView bk_whenTapped:^{
                   WRCategory *object = [ShareData data].categoryArray[index];
                ArticleListController *listController = [[ArticleListController alloc] init];
                listController.category = object;
                listController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:listController animated:YES];
                listController.title = object.name;
            }];
            
            //imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            //imageView.clipsToBounds  = YES;
            //[imageView wr_setShadow];
            
            //imageView.layer.shadowColor = [UIColor blackColor].CGColor;
            //imageView.layer.shadowOffset = CGSizeMake(4,4);
            //imageView.layer.shadowOpacity = 0.8;
            //imageView.layer.shadowRadius = 4;
//            [imageView bk_whenTapped:^{
//                if (imageView.left > 0) {
//                    [weakSelf showSubjectWithIndex:imageView.tag];
//                } else {
//                    [UIView animateWithDuration:0.5 animations:^{
//                        [weakSelf rawLayout];
//                        [weakSelf resetScrollView];
//                        //weakSelf.scrollView.panGestureRecognizer.delaysTouchesBegan = NO;
//                    }];
//                }
//                
//            }];
//            
            //[self.scrollView addSubview:imageView];
            [self.scrollView addSubview:imageView];
            [imageView setImageWithUrlString:object.logoImgUrl holderImage:placeHolderImage];
            
//            [self.subjectViewsArray addObject:imageView];
            
            UILabel *label = [UILabel new];
            label.text = object.name;
            label.font = [[UIFont wr_bigFont] fontWithBold];
            label.textColor = [UIColor colorWithHexString:@"f0f0f0"];
            label.tag = index;
            label.textAlignment = NSTextAlignmentCenter;
            [label sizeToFit];
            [imageView addSubview:label];
            label.center = CGPointMake(cx/2, cy/2);
            UILabel *titleLabel = label;
            
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cx - 2 * offset, 0)];
            label.numberOfLines = 0;
            label.text = object.subtitle;
            label.font = [UIFont wr_lightFont];
            label.textColor = [UIColor colorWithHexString:@"eeeeee"];
            label.tag = index;
            label.textAlignment = NSTextAlignmentCenter;
            [label sizeToFit];
            [imageView addSubview:label];
            label.frame = [Utility resizeRect:label.frame cx:-1 height:label.height];
            label.center = CGPointMake(cx/2, titleLabel.bottom + offset + label.height/2);
//            [self.subjectTitleViewsArray addObject:label];
            
            y = imageView.bottom + offset;
        }
        self.scrollView.contentSize = CGSizeMake(self.scrollView.width, MAX(y, self.scrollView.height));
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat value = self.subjectViewsArray.firstObject.height*0.6 - top_height;
    if (scrollView.contentOffset.y < 0) {
        CGFloat y = fabs(scrollView.contentOffset.y);
        if (!scrollView.isDragging && y > value) {
            __weak __typeof(self) weakSelf = self;
            [UIView animateWithDuration:0.5 animations:^{
                [weakSelf rawLayout];
                [weakSelf resetScrollView];
                //weakSelf.scrollView.panGestureRecognizer.delaysTouchesBegan = NO;
            }];
        }
    }
}

#pragma mark - getter & setter
-(NSMutableArray<UIView *> *)subjectViewsArray {
    if (!_subjectViewsArray) {
        _subjectViewsArray = [NSMutableArray array];
        _subjectTitleViewsArray = [NSMutableArray array];
    }
    return _subjectViewsArray;
}

#pragma mark - animations
-(void)rawLayout
{
    UIImage *placeHolderImage = [UIImage imageNamed:@"well_default_video"];
    CGFloat cy = 144;
    if ([UIScreen mainScreen].bounds.size.width > 320) {
        cy = 120;
    }
    if ([UIScreen mainScreen].scale >= 3) {
        cy = 160;
    }
    CGFloat cx = cy*placeHolderImage.size.width/placeHolderImage.size.height;
    
    NSInteger count = self.subjectViewsArray.count;
    CGRect frame = self.view.bounds;
    CGFloat offset = WRUIOffset;
    CGFloat x = frame.size.width - cx - 3, y = (frame.size.height - count*cy - (count - 1)*offset)/2 - top_height - 22;
    NSInteger index = 0;
    for(UIView *view in self.subjectViewsArray)
    {
        view.frame = CGRectMake(x, y, cx, cy);
        
        UILabel *label = (UILabel*)self.subjectTitleViewsArray[index++];
        label.frame = CGRectMake(0, cy - label.height, cx, label.height);
        label.alpha = 1;

        y = view.bottom + offset;
    }
}

-(void)resetScrollView
{
    //self.scrollView.contentSize = CGSizeMake(0, self.scrollView.height - top_height);
    //self.detailView.frame = CGRectMake(0, self.scrollView.contentSize.height, self.scrollView.width, self.scrollView.height);
    self.detailView.frame = CGRectMake(0, self.view.height, self.view.width, self.view.height);
}

-(void)showSubjectWithIndex:(NSInteger)index
{
    __weak __typeof(self) weakSelf = self;
    //self.scrollView.panGestureRecognizer.delaysTouchesBegan = true;
    
    [UIView animateWithDuration:0.35 animations:^{
        //CGFloat cx = weakSelf.scrollView.width, cy = cx*2/5, x;
        CGFloat cx = weakSelf.view.width, cy = 0, x;
        NSInteger i = 0;
        for(UIView *subjectView in weakSelf.subjectViewsArray)
        {
            if (cy == 0) {
                cy = cx*subjectView.height/subjectView.width;
            }
            x = (subjectView.tag - index)*cx;
            subjectView.frame = CGRectMake(x, 0 - top_height, cx, cy);
            subjectView.layer.cornerRadius = 0;
            
            UILabel *label = (UILabel*)self.subjectTitleViewsArray[i++];
            label.frame = CGRectMake(0, cy - label.height, cx, label.height);
            label.alpha = 0;
        }
        weakSelf.detailView.frame = CGRectMake(0, cy + 3, weakSelf.detailView.width, weakSelf.view.height - cy - 3);
    } completion:^(BOOL finished) {
        //weakSelf.scrollView.contentSize = CGSizeMake(0, weakSelf.detailView.bottom + 30);
        weakSelf.detailController.category = [ShareData data].categoryArray[index];
    }];
}

@end
