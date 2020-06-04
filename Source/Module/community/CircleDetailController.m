//
//  CircleDetailController.m
//  rehab
//
//  Created by yongen zhou on 2018/11/1.
//  Copyright © 2018年 WELL. All rights reserved.
//

#import "CircleDetailController.h"
#import "ComulitModel.h"
@interface CircleDetailController ()
@property (weak, nonatomic) IBOutlet UILabel *circleTItle;
@property (weak, nonatomic) IBOutlet UILabel *circleDetail;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (weak, nonatomic) IBOutlet UIView *members;
@property ComulitModel* viewModel;
@end

@implementation CircleDetailController

-(instancetype)init
{
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"MyStoryboard" bundle:nil];
    
    self = [sb instantiateViewControllerWithIdentifier:@"circledetail"];
    return self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [ComulitModel new];

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.viewModel getCircleDetail:self.circleId Completion:^(NSError * error) {
        self.circle = self.viewModel.circle;
        self.circleTItle.text = self.circle.name;
        self.circleDetail.text = self.circle.resume;
        self.count.text = [NSString stringWithFormat:@"共有%ld人",self.circle.usercnt];
        
        CGFloat imageSize = 36;
        CGFloat xOffset = 22-36;
        
        
        UIScrollView *iconScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0,ScreenW-114-145, 36)];
        iconScrollView.backgroundColor = [UIColor clearColor];
        iconScrollView.showsVerticalScrollIndicator = NO;
        iconScrollView.showsHorizontalScrollIndicator = NO;
        CGFloat y = 0;
        CGFloat x = 0;
        for(NSUInteger index = 0; index < self.circle.circleUserImgs.count; index++)
        {
            NSString* image = self.circle.circleUserImgs[index];
            if ((x +imageSize) > (iconScrollView.width - xOffset)) {
                break;
            }
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, imageSize, imageSize)];
            imageView.layer.cornerRadius = imageView.width/2;
            imageView.layer.masksToBounds = YES;
            imageView.layer.borderWidth = 2;
            imageView.layer.borderColor = [UIColor whiteColor].CGColor;
            [imageView setImageWithUrlString:image holderImage:[WRUIConfig defaultHeadImage]];
            [iconScrollView addSubview:imageView];
            iconScrollView.height = 36;
            x = imageView.right + xOffset;
        }
        iconScrollView.contentSize = CGSizeMake(x+36, imageSize);
        iconScrollView.width = x+36>ScreenW-114-145?ScreenW-114-145:x+36;
        [self.members addSubview:iconScrollView];
        
        
    }];
    
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
