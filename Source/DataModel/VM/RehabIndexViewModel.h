//
//  RehabIndexViewModel.h
//  rehab
//
//  Created by herson on 8/15/16.
//  Copyright © 2016 WELL. All rights reserved.
//

#import "WRViewModel.h"

@interface RehabIndexViewModel : WRViewModel

@property(nonatomic, strong, nullable) NSArray *bannerArray, *treatDiseaseArray, *proTreatDiseaseArray;

-(void)fetchDataWithCompletion:( void (^ _Nullable )(NSError * _Nullable))completion;

@end
