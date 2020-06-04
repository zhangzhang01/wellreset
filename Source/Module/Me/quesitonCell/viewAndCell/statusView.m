//
//  statusView.m
//  rehab
//
//  Created by matech on 2019/11/18.
//  Copyright © 2019 WELL. All rights reserved.
//

#import "statusView.h"

@implementation statusView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpAllView];
    }
    return self;
}
-(void)setUpAllView{
//    NSArray *imageArr = [NSArray arrayWithObjects:@"ODI评分",@"JOA评分",@"改善率", nil];

   
       
}
-(void)setDataWith:(NSString *)str
{
    if ([self.str isEqualToString:@"0"]) {
            NSArray *imageArr = [NSArray arrayWithObjects:@"ODI评分", nil];
                   NSArray *titleArr = [NSArray arrayWithObjects:@"ODI评分(%)", nil];
               for (int i =0; i<1; i++) {
                      UIImageView *imageV = [[UIImageView alloc]init];
                   
                  
           //           imageV.contentMode = UIViewContentModeScaleAspectFill;
           //           imageV.clipsToBounds = YES;
           //           imageV.userInteractionEnabled = YES;
                      imageV.tag = i;
                      imageV.image = IMAGE(imageArr[i]);
           //           imageV.layer.cornerRadius = 5.0;
           //           imageV.layer.masksToBounds = YES;

                   UILabel *titleLabel = [[UILabel alloc]init];
                  
                   titleLabel.font = FONT_13;
                   titleLabel.textColor = [UIColor blackColor];
                   titleLabel.text = titleArr[i];
                    titleLabel.textAlignment = NSTextAlignmentCenter;
                   
                  
                       if (i ==0 ) {
                            imageV.frame = CGRectMake(20, 0, 60, 10);
                           titleLabel.frame = CGRectMake(10, MaxY(imageV),  80, 20);
                       }if (i ==1) {
                           imageV.frame = CGRectMake((ScreenW-30)/2-20, 0, 60, 10);
                           titleLabel.frame = CGRectMake((ScreenW-30)/2-30, MaxY(imageV),  80, 20);
                       }if (i ==2) {
                           imageV.frame = CGRectMake((ScreenW-20)-60, 0, 60, 10);
                           titleLabel.frame = CGRectMake((ScreenW-20)-60, MaxY(imageV),  70, 20);
                       }
                   
                   
                   
                   
                    [self addSubview:imageV];
                   [self addSubview:titleLabel];
                  }
       }if ([self.str isEqualToString:@"1"])
           
       {
               NSArray *titleArr = [NSArray arrayWithObjects:@"JOA评分",@"改善率(%)", nil];
               NSArray *imageArr = [NSArray arrayWithObjects:@"JOA评分",@"改善率", nil];
     
               for (int i =0; i<2; i++) {
                      UIImageView *imageV = [[UIImageView alloc]init];
                   
                  
           //           imageV.contentMode = UIViewContentModeScaleAspectFill;
           //           imageV.clipsToBounds = YES;
           //           imageV.userInteractionEnabled = YES;
                      imageV.tag = i;
                      imageV.image = IMAGE(imageArr[i]);
           //           imageV.layer.cornerRadius = 5.0;
           //           imageV.layer.masksToBounds = YES;

                   UILabel *titleLabel = [[UILabel alloc]init];
                  
                   titleLabel.font = FONT_13;
                   titleLabel.textColor = [UIColor blackColor];
                   titleLabel.text = titleArr[i];
                    titleLabel.textAlignment = NSTextAlignmentCenter;
                   
                  
                       if (i ==0 ) {
                            imageV.frame = CGRectMake(20, 0, 60, 10);
                           titleLabel.frame = CGRectMake(10, MaxY(imageV),  80, 20);
                       }if (i ==1) {
                           imageV.frame = CGRectMake((ScreenW-30)/2-20, 0, 60, 10);
                           titleLabel.frame = CGRectMake((ScreenW-30)/2-30, MaxY(imageV),  80, 20);
                       }if (i ==2) {
                           imageV.frame = CGRectMake((ScreenW-20)-60, 0, 60, 10);
                           titleLabel.frame = CGRectMake((ScreenW-20)-60, MaxY(imageV),  70, 20);
                       }
                   
                   
                   
                   
                    [self addSubview:imageV];
                   [self addSubview:titleLabel];
                  }
       
       }

}
@end
