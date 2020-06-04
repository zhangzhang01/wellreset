//
//  WRCitySelectorView.h
//  rehab
//
//  Created by Matech on 3/16/16.
//  Copyright © 2016 Matech. All rights reserved.
//

#import "WRSheetView.h"

@interface WRLocation : NSObject

@property (copy, nonatomic) NSString *country;
@property (copy, nonatomic) NSString *state;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *district;
@property (copy, nonatomic) NSString *street;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@end

@interface WRCitySelectorView : WRSheetView

@property(nonatomic)WRLocation* locate;
+ (void)showWithCompletion:(void (^)(WRLocation*))completion;

@end
