//
//  MeCategoryCell.h
//  rehab
//
//  Created by 何寻 on 6/18/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeCategoryCell : UITableViewCell

@property(nonatomic, copy) void(^itemAction)(NSUInteger);

+(void)getlayoutInfoWithItemCount:(NSUInteger)count
                        position:(CGPoint*)position
                           offset:(CGFloat*)offset
                        itemSize:(CGSize*)itemSize
                   containerSize:(CGSize)containerSize;

-(instancetype)initWithTitles:(NSArray*)titles images:(NSArray*)images reuseIdentifier:(NSString*)reuseIdentifier;

@end
