

//
//  ComulitModel.m
//  rehab
//
//  Created by yongen zhou on 2018/8/9.
//  Copyright © 2018年 WELL. All rights reserved.
//

#import "ComulitModel.h"

@implementation ComulitModel
-(void)getBannerCompletion:(void (^)(NSError * _Nonnull ))completion
{
    NSString *formatString = [WRNetworkService getFormatURLString:comBanner];
    NSString *urlString = [NSString stringWithFormat:@"%@", formatString];
    [WRBaseRequest request:urlString shouldUseCache:NO result:^(id responseObject, NSError *error)
     {
         NSString *errorString = nil;
         do {
             if(error)
             {
                 error = [WRViewModel defaultNetworkError];
                 break;
             }
             
             WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
             if(!parser.isSuccess)
             {
                 errorString = parser.errorString;
                 error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                 break;
             }
             
             
             NSArray *array = parser.resultObject;
             NSMutableArray *dataArray = [NSMutableArray array];
             for (NSDictionary* dic in array ) {
                 WRBanner* banner = [[WRBanner alloc]initWithDictionary:dic];
                 [dataArray addObject:banner];
             }
             self.bannerArr = dataArray;
             error = nil;
         } while (NO);
         if (completion) {
             completion(error);
         }
     }];
    
}

-(void)getCirclesCompletion:(void (^)(NSError * _Nonnull ,NSArray*  crArry))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@", [WRNetworkService getFormatURLString:comCircleList]];
    [WRBaseRequest request:urlString shouldUseCache:NO result:^(id responseObject, NSError *error) {
        
        NSString *errorString = nil;
        NSArray* circles;
        do {
            if(error)
            {
                error = [WRViewModel defaultNetworkError];
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            
            NSArray* result = parser.resultObject;
            NSMutableArray* arr = [NSMutableArray array];
            if (result.count==2) {
            
            
            NSArray* circleArr = [result objectAtIndex:0];
            for (NSDictionary* circleDic in circleArr) {
                WRCircle* circle = [[WRCircle alloc]initWithDictionary:circleDic];
                [arr addObject:circle];
            }
            self.circleArr = arr;
            arr = [NSMutableArray array];
           
            NSArray* mycircleArr = [result objectAtIndex:1];
            for (NSDictionary* mycircleDic in mycircleArr) {
                WRCircle* circle = [[WRCircle alloc]initWithDictionary:mycircleDic];
                [arr addObject:circle];
            }
            self.myCircleArr = arr;
            }
        } while (NO);
        if (completion) {
            completion(error,circles);
        }
    }];
    
}
-(void)getarticleSort:(NSString*)sort page:(int)page rows:(int)rows circleId:(NSString*)circleId isown:(NSString*)isown articleId:(NSString*)articleId   Completion:(void (^)(NSError * _Nonnull ))completion
{
    NSString *urlString =  [WRNetworkService getFormatURLString:ComArticle];
    NSString *requst = [NSString stringWithFormat:urlString,sort,page,rows,circleId,isown,articleId];
    
    
    [WRBaseRequest request:requst shouldUseCache:NO result:^(id responseObject, NSError *error) {
        
        NSString *errorString = nil;
        do {
            if(error)
            {
                error = [WRViewModel defaultNetworkError];
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            NSDictionary * arr1 = parser.resultObject;
            if (![arr1 isKindOfClass:[NSDictionary class]]) {
                
                break;
                
            }
            NSArray* dicarr = arr1[@"result"];
            
            NSMutableArray* arry = [NSMutableArray array];
            for (NSDictionary* dic in dicarr) {
                WRCOMArticle* ar = [[WRCOMArticle alloc]initWithDictionary:dic];
                NSDictionary* userdic = dic[@"user"];
                WRUser* user=  [[WRUser alloc]initWithDictionary:userdic];
                ar.user = user;
                [arry addObject:ar];
            }
            self.articleArr = arry;
            
            
        } while (NO);
        if (completion) {
            completion(error);
        }
    }];
}



-(void)getCommentlistSort:(NSString*)sort ariticleId:(NSString*)articleId Completion:(void (^)(NSError * _Nonnull ))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@", [WRNetworkService getFormatURLString:comments]];
    NSString* request = [NSString stringWithFormat:urlString,sort,articleId];
    [WRBaseRequest request:request shouldUseCache:NO result:^(id responseObject, NSError *error) {
        
        NSString *errorString = nil;
    
        do {
            if(error)
            {
                error = [WRViewModel defaultNetworkError];
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            NSDictionary* arr = parser.resultObject;
            NSArray* result  = arr[@"result"];
            NSMutableArray* arry = [NSMutableArray array];
            for (NSDictionary* dic in result) {
                WRCOMcomment* com = [[WRCOMcomment alloc]initWithDictionary:dic];
                [arry addObject:com];
            }
            
            self.CommentArr = arry;
            
            
        } while (NO);
        if (completion) {
            completion(error);
        }
    }];
    
}


-(void)sendCommentArticleId:(NSString*)ArticleId parentId:(NSString*)parentId text:(NSString*)text Completion:(void (^)(NSError * _Nonnull ))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@", [WRNetworkService getFormatURLString:saveComment]];
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    dic [@"articleId"]=ArticleId;
    dic [@"parentId"]=parentId;
    dic [@"text"]=text;
    [WRNetworkService fillPostParam:dic];
    
    
    
    [WRBaseRequest post:urlString params:dic result:^(id responseObject, NSError *error) {
        
        NSString *errorString = nil;
        
        do {
            if(error)
            {
                error = [WRViewModel defaultNetworkError];
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            
            
   
            
            
        } while (NO);
        if (completion) {
            completion(error);
        }
    }];
    
}




-(void)getCircleDetail:(NSString*)circleId Completion:(void (^)(NSError * _Nonnull ))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@", [WRNetworkService getFormatURLString:circleDetail]];
    
    urlString = [NSString stringWithFormat:urlString,circleId];
    
    [WRBaseRequest request:urlString shouldUseCache:NO result:^(id responseObject, NSError *error) {
        
        NSString *errorString = nil;
        
        do {
            if(error)
            {
                error = [WRViewModel defaultNetworkError];
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            NSDictionary* dic =parser.resultObject;
            WRCircle* cir = [[WRCircle alloc]initWithDictionary:dic];
            self.circle = cir;
            
        } while (NO);
        if (completion) {
            completion(error);
        }
    }];
    
}






-(void)deletComentId:(NSString*)uuid Completion:(void (^)(NSError * _Nonnull ))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@", [WRNetworkService getFormatURLString:removeComment]];
    
    urlString =[NSString stringWithFormat:urlString,uuid];
    
    [WRBaseRequest request:urlString shouldUseCache:NO result:^(id responseObject, NSError *error) {
        
        NSString *errorString = nil;
        
        do {
            if(error)
            {
                error = [WRViewModel defaultNetworkError];
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            
            
            
            
            
        } while (NO);
        if (completion) {
            completion(error);
        }
    }];
    
}

-(void)deletArticle:(NSString*)uuid Completion:(void (^)(NSError * _Nonnull ))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@", [WRNetworkService getFormatURLString:removeArticle]];
    
    urlString = [NSString stringWithFormat:urlString,uuid];
    
    [WRBaseRequest request:urlString shouldUseCache:NO result:^(id responseObject, NSError *error) {
        
        NSString *errorString = nil;
        
        do {
            if(error)
            {
                error = [WRViewModel defaultNetworkError];
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            
            
            
            
            
        } while (NO);
        if (completion) {
            completion(error);
        }
    }];
    
}

-(void)getMessageCompletion:(void (^)(NSError * _Nonnull ))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@", [WRNetworkService getFormatURLString:notifyList]];
    [WRBaseRequest request:urlString shouldUseCache:NO result:^(id responseObject, NSError *error) {
        
        NSString *errorString = nil;
        
        do {
            if(error)
            {
                error = [WRViewModel defaultNetworkError];
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            NSDictionary* dic = parser.resultObject;
            NSArray* arr = dic[@"result"];
            if (![arr isKindOfClass:[NSArray class]]) {
                break;
            }
            NSMutableArray* arry = [NSMutableArray array];
            for (NSDictionary* dic in arr) {
                WRMessage* com = [[WRMessage alloc]initWithDictionary:dic];
                [arry addObject:com];
            }
            
            self.messageArr = arry;
            
            
        } while (NO);
        if (completion) {
            completion(error);
        }
    }];
    
}


-(void)deletMessage:(NSString*)uuid Completion:(void (^)(NSError * _Nonnull ))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@", [WRNetworkService getFormatURLString:removeNotify]];
    
    
    
    [WRBaseRequest request:urlString shouldUseCache:NO result:^(id responseObject, NSError *error) {
        
        NSString *errorString = nil;
        
        do {
            if(error)
            {
                error = [WRViewModel defaultNetworkError];
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            
            
            
            
            
        } while (NO);
        if (completion) {
            completion(error);
        }
    }];
    
}

-(void)upvoteArticle:(NSString*)uuid Completion:(void (^)(NSError * _Nonnull ))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@", [WRNetworkService getFormatURLString:upvote]];
    urlString = [NSString stringWithFormat:urlString,uuid];
    
    
    [WRBaseRequest request:urlString shouldUseCache:NO result:^(id responseObject, NSError *error) {
        
        NSString *errorString = nil;
        
        do {
            if(error)
            {
                error = [WRViewModel defaultNetworkError];
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            
            
            
            
            
        } while (NO);
        if (completion) {
            completion(error);
        }
    }];
    
}

-(void)joinCircle:(NSString*)circle isJoin:(NSString*)isjoin  Completion:(void (^)(NSError * _Nonnull ))completion
{
    NSString *urlString = [NSString stringWithFormat:@"%@", [WRNetworkService getFormatURLString:joinCircle]];
    urlString = [NSString stringWithFormat:urlString,circle,isjoin];
    
    
    [WRBaseRequest request:urlString shouldUseCache:NO result:^(id responseObject, NSError *error) {
        
        NSString *errorString = nil;
        
        do {
            if(error)
            {
                error = [WRViewModel defaultNetworkError];
                break;
            }
            
            WRJsonParser *parser = [WRJsonParser ParserFromDictionary:responseObject];
            if(!parser.isSuccess)
            {
                errorString = parser.errorString;
                error = [NSError errorWithDomain:errorString code:-1 userInfo:nil];
                break;
            }
            
            
            
            
            
        } while (NO);
        if (completion) {
            completion(error);
        }
    }];
}
-(void)getreportuserId:(NSString *)userId region:(NSString *)region tag:(NSString *)tag block:(void(^)(bool success,NSMutableArray *blockArray))block
{
    NSString *urlString;
    if ([tag isEqualToString:@"0"]) {
        urlString = [NSString stringWithFormat:@"%@", [WRNetworkService getFormatURLString:getQuestionnairJOA]];
    }else{
        
        urlString = [NSString stringWithFormat:@"%@", [WRNetworkService getFormatURLString:getQuestionnairODI]];
    }
    
    //        NSString *requst = [NSString stringWithFormat:urlString,userId,region];
    
    //    NSLog(@"POST %@", serv);
    //    NSLog(@"Params %@", params.description);
    urlString = [NSString stringWithFormat:urlString, userId];
    AFHTTPSessionManager*manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer= [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes=[manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];//Very Important
    
    
    
    // 2.封装请求参数
    
    // 3.发送POST请求
    
    
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 请求成功，解析数据
        //        NSLog(@"%@", responseObject);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@", dic);
        if ([dic[@"msg"] isEqualToString:@"成功"]) {
            NSArray *requeicArr = [dic objectForKey:@"extra"];
           
            
            
//            NSArray *adImageArray1 = model.objectArray;
            NSMutableArray *blockArray1 = [NSMutableArray array];
            
            for (NSDictionary *dic in requeicArr) {
                 reportViewModel *model = [[reportViewModel alloc]initWithDic:dic];
                [blockArray1 addObject:model];
            }

            
            block(YES,blockArray1);
        }else{
            
            
            block(NO,nil);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
        [Utility Alert:[error localizedDescription]];
    }];
}
-(void)submitadminWithuserId:(NSString *)userId   block:(void(^)(bool success,NSString *result))block
{
     NSString *urlString;
     
            
            urlString = [NSString stringWithFormat:@"%@", [WRNetworkService getFormatURLString:isTrueSpan]];
        
        
        //        NSString *requst = [NSString stringWithFormat:urlString,userId,region];
        
        //    NSLog(@"POST %@", serv);
        //    NSLog(@"Params %@", params.description);
        urlString = [NSString stringWithFormat:urlString, userId];
        AFHTTPSessionManager*manager = [AFHTTPSessionManager manager];
        //manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer= [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes=[manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];//Very Important
        
        
        
        // 2.封装请求参数
        
        // 3.发送POST请求
        
        
        [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 请求成功，解析数据
            //        NSLog(@"%@", responseObject);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@", dic);
            NSString *msg = [NSString stringWithFormat:@"%@",dic[@"msg"]];
            if ([dic[@"msg"] isEqualToString:@"成功"]) {
 
                
                block(YES,msg);
            }else{
                
                
                block(NO,msg);
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", [error localizedDescription]);
            [Utility Alert:[error localizedDescription]];
        }];
    
}
-(void)submitGrade:(NSString *)jsonStr  block:(void(^)(bool success,NSString *msg ))block
{
    
    
        
          NSString * urlString = [NSString stringWithFormat:@"%@", [WRNetworkService getFormatURLString:submitGrade]];
                   
                   
                   //        NSString *requst = [NSString stringWithFormat:urlString,userId,region];
                   
                   //    NSLog(@"POST %@", serv);
                   //    NSLog(@"Params %@", params.description);
//            urlString = [NSString stringWithFormat:urlString, jsonStr];
        
        
        //        NSString *requst = [NSString stringWithFormat:urlString,userId,region];
        
        //    NSLog(@"POST %@", serv);
        //    NSLog(@"Params %@", params.description);
        NSDictionary *dic =@{@"extra":jsonStr};
        AFHTTPSessionManager*manager = [AFHTTPSessionManager manager];
        //manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer= [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes=[manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];//Very Important
        
        
        
        // 2.封装请求参数
        
        // 3.发送POST请求
        
        
        [manager POST:urlString parameters:dic progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 请求成功，解析数据
            //        NSLog(@"%@", responseObject);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@", dic);
            if ([dic[@"msg"] isEqualToString:@"成功"]) {
                NSArray *requeicArr = [dic objectForKey:@"extra"];
               
                
                
    //            NSArray *adImageArray1 = model.objectArray;
                NSMutableArray *blockArray1 = [NSMutableArray array];
                
                for (NSDictionary *dic in requeicArr) {
                     reportViewModel *model = [[reportViewModel alloc]initWithDic:dic];
                    [blockArray1 addObject:model];
                }

                
                block(YES,dic[@"msg"]);
            }else{
                
                
                block(NO,dic[@"msg"]);
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", [error localizedDescription]);
            [Utility Alert:[error localizedDescription]];
        }];
}

-(void)submitresultWithuserId:(NSString *)userId withpartCode:(NSString *)partCode  block:(void(^)(bool success,resultModel *mdoel))block
{
     NSString * urlString = [NSString stringWithFormat:@"%@", [WRNetworkService getFormatURLString:getGredeStatement]];
                      
                      
                      //        NSString *requst = [NSString stringWithFormat:urlString,userId,region];
                      
                      //    NSLog(@"POST %@", serv);
                      //    NSLog(@"Params %@", params.description);
                      urlString = [NSString stringWithFormat:urlString, partCode,userId];
        
        
        //        NSString *requst = [NSString stringWithFormat:urlString,userId,region];
        
        //    NSLog(@"POST %@", serv);
        //    NSLog(@"Params %@", params.description);
//        NSDictionary *dic =@{@"userId":userId,@"partCode":partCode};
        AFHTTPSessionManager*manager = [AFHTTPSessionManager manager];
        //manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer= [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes=[manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];//Very Important
        
        
        
        // 2.封装请求参数
        
        // 3.发送POST请求
        
        
        [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 请求成功，解析数据
            //        NSLog(@"%@", responseObject);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers| NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@", dic);
            if ([dic[@"msg"] isEqualToString:@"成功"]) {
                NSDictionary *requeicArr = [dic objectForKey:@"result"];
               
                
    
                
              
                     resultModel *model = [[resultModel alloc]initWithDic:requeicArr];
                  
               

                
                block(YES,model);
            }else{
                
                
                block(NO,nil);
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@", [error localizedDescription]);
            [Utility Alert:[error localizedDescription]];
        }];
    
}



@end





