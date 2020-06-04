//
//  TreatDiseaseSelectorController.m
//  rehab
//
//  Created by 何寻 on 8/21/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "TreatDiseaseSelectorController.h"
#import "WRTreat.h"
#import "ShareData.h"
#import "WRView.h"

@implementation TreatDiseaseSelectorController

-(instancetype)init {
    if (self = [super init]) {
        [self layout];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = NSLocalizedString(@"快速缓解", nil);
    [self createBackBarButtonItem];
}

-(void)layout
{
    NSMutableSet<NSString*> *codeSets = [NSMutableSet set];
    NSMutableDictionary<NSString*, NSMutableArray<WRRehabDisease*>*> *collections = [NSMutableDictionary dictionary];
    
    for(WRRehabDisease *obj in [ShareData data].treatDisease)
    {
        NSString *codes = obj.bodyCode;
        if ([Utility IsEmptyString:codes]) {
            continue;
        }
        [codeSets addObject:obj.specialty];
        NSMutableArray *array = collections[obj.specialty];
        if (!array) {
            array = [NSMutableArray array];
            collections[obj.specialty] = array;
        }
        
        [array addObject:obj];
    }
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
    UIView *container = scrollView;
    
    __weak __typeof(self) weakSelf = self;
    
    CGRect frame = container.bounds;
    CGFloat offset = WRUIOffset, x = offset, y = x, cx, cy;
    UILabel *label;
    UIView *lineView;
    UIFont *titleFont = [UIFont wr_lightFont];
    const NSUInteger rowCount = 3;
    CGFloat itemHeight = 0;
    UIColor *sectionColor = [UIColor colorWithHexString:@"d3e8fd"];
    const CGFloat sectionHeight = 5;
    NSString *placeHolderImageName = @"well_default_4_3";
    
    for(NSString *code in codeSets)
    {
        x = offset;
        
        NSString *codeDesc = code;
        label = [[UILabel alloc] init];
        label.text = codeDesc;
        label.font = titleFont;
        [label sizeToFit];
        label.frame = CGRectMake(x, y, label.width, label.height);
        [container addSubview:label];
        y = label.bottom + offset;
        
        cx = (frame.size.width - 2*offset);
        CGFloat imageWidth = (cx - (rowCount - 1)*offset)/rowCount;
        
        CGFloat y0 = y;
        NSMutableArray<WRRehabDisease*> *array = collections[code];
        if (array.count > 0) {
            NSInteger j = 0;
            for(WRRehabDisease *disease in array)
            {
                GridThumbView *item = [[GridThumbView alloc] initWithFrame:CGRectMake(x, y, imageWidth, itemHeight)
                                                                     style:GridThumbViewStyleDefault
                                                          placeHolderImage:[UIImage imageNamed:placeHolderImageName]];
                [item.imageView setImageWithUrlString:disease.imageUrl holder:placeHolderImageName];
                item.titleLabel.text = disease.diseaseName;
                item.titleLabel.textColor = [UIColor lightGrayColor];
                item.tag = [[ShareData data].treatDisease indexOfObject:disease];
                if (itemHeight == 0)
                {
                    [item sizeToFit];
                    itemHeight = item.height;
                }
                [item bk_whenTapped:^{
                    if([weakSelf checkUserLogState:nil]) {
                        NSInteger position = item.tag;
                        WRRehabDisease *diseae = [ShareData data].treatDisease[position];
                        [weakSelf actionOnDisease:diseae];
                    }
                    
                }];
                
                [container addSubview:item];
                j++;
                
                if (j%rowCount == 0)
                {
                    x = offset;
                    y += item.bounds.size.height;
                }
                else
                {
                    x += item.bounds.size.width + offset;
                }
                y0 = item.bottom;
            }
            y = y0;
        }
        
        x = 0, cx = frame.size.width, cy = sectionHeight;
        lineView = [[UIView alloc] initWithFrame:CGRectMake(x, y, cx, cy)];
        lineView.backgroundColor = sectionColor;
        [container addSubview:lineView];
        y = lineView.bottom + offset;
    }
    scrollView.contentSize = CGSizeMake(scrollView.width, y);
}

-(void)actionOnDisease:(WRRehabDisease*)disease
{
    [self pushTreatRehabWithDisease:disease isTreat:YES];
}
@end
