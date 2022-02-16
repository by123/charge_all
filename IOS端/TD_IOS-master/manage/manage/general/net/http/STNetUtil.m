//
//  STNetUtil.m
//  framework
//
//  Created by 黄成实 on 2018/4/18.
//  Copyright © 2018年 黄成实. All rights reserved.
//

#import "STNetUtil.h"
#import <AFNetworking/AFNetworking.h>
#import "RespondModel.h"
#import <MJExtension/MJExtension.h>
#import "AccountManager.h"
#import "STConvertUtil.h"
#import "STObserverManager.h"
#import "STUserDefaults.h"
#import "LoginPage.h"
@implementation STNetUtil


#pragma mark get传参
+(void)get:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(RespondModel *))success failure:(void (^)(int))failure{
    
    [self checkNetwork];
    [LCProgressHUD showLoading:nil];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    //header
    [manager.requestSerializer setValue:[[AccountManager sharedAccountManager] getUserModel].token forHTTPHeaderField:@"authorization"];
    
    [STLog print:[[AccountManager sharedAccountManager] getUserModel].token];
    [STLog print:url];

    //content-type
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/xml",@"text/html", nil ];
    
    NSMutableDictionary *header = [[NSMutableDictionary alloc]init];
    header[@"authorization"] = [[AccountManager sharedAccountManager] getUserModel].token;
    //get
    [manager GET:url parameters:parameters headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleSuccess:responseObject success:success url:url];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleFail:task.response failure:failure url:url];
    }];
}


#pragma mark post传参
+ (void)post:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(RespondModel *))success failure:(void (^)(int))failure{
    [self checkNetwork];
    [LCProgressHUD showLoading:nil];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    //header
    [manager.requestSerializer setValue:[[AccountManager sharedAccountManager] getUserModel].token forHTTPHeaderField:@"authorization"];
//    [manager.requestSerializer setValue:sKeyReferer forHTTPHeaderField:sBusInfoHeaders];
//    [manager.requestSerializer setValue:sCookie forHTTPHeaderField:sKeyCookie];
//

    //content-type
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/xml",@"text/html", nil ];
    
    NSMutableDictionary *header = [[NSMutableDictionary alloc]init];
    header[@"authorization"] = [[AccountManager sharedAccountManager] getUserModel].token;
    //post
    [manager POST:url parameters:parameters headers:header progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleSuccess:responseObject success:success url:url];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleFail:task.response failure:failure url:url];
    }];
}



#pragma mark post传递body
+(void)post:(NSString *)url content:(NSString *)content success:(void (^)(RespondModel *))success failure:(void (^)(int))failure{
    [self checkNetwork];
    [LCProgressHUD showLoading:nil];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    //header
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    [request addValue:[[AccountManager sharedAccountManager] getUserModel].token forHTTPHeaderField:@"authorization"];
//    [STUserDefaults saveKeyValue:@"by666" value:[[AccountManager sharedAccountManager] getUserModel].token];
//    UserModel *model =[[AccountManager sharedAccountManager]getUserModel];
//    if(!IS_NS_STRING_EMPTY(model.token) && !IS_NS_STRING_EMPTY(model.userUid)){
//        [request addValue:model.token forHTTPHeaderField:@"token"];
//        [request addValue:model.userUid forHTTPHeaderField:@"uid"];
//    }
    
    //content-type
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    //body
    NSData *body  =[content dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:body];
    
    
    //post
    [[manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error){
        if(error){
            [self handleFail:response failure:failure url:url];
        }else{
            [self handleSuccess:responseObject success:success url:url];
        }
    }] resume];
}


#pragma mark 上传
+(void)upload:(UIImage *)image url:(NSString *)url success:(void (^)(RespondModel *))success failure:(void (^)(int))errorCode{
    
    [self checkNetwork];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    NSData *data = UIImageJPEGRepresentation(image,1.0);
    
    NSMutableDictionary *header = [[NSMutableDictionary alloc]init];
    header[@"Content-Type"] = @"multipart/form-data";
    
    [manager POST:url parameters:nil headers:header constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:@"upload.png" mimeType:@"image/png"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleSuccess:responseObject success:success url:url];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleFail:task.response failure:errorCode url:url];
    }];
    
    
}
#pragma mark 下载
+(void)download : (NSString *)url callback : (ByDownloadCallback) callback{
    [self checkNetwork];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    [downloadTask resume];
}


#pragma mark 成功处理
+(void)handleSuccess:(id)responseObject success:(void (^)(RespondModel *))success url:(NSString *)url{
    RespondModel *model = [RespondModel mj_objectWithKeyValues:responseObject];
    model.requestUrl = url;

    NSString *jsonStr = [NSString stringWithFormat:@"\n------------------------------------\n***请求成功:%@\n%@\n------------------------------------",url,[STConvertUtil dataToString:responseObject]];
    [STLog print:jsonStr];
    success(model);
    if(!IS_NS_STRING_EMPTY(model.msg)){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [LCProgressHUD showMessage:model.msg];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabelText = model.msg;
            hud.detailsLabelFont = [UIFont boldSystemFontOfSize:16.0f];
            hud.margin = 10.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
            
            [LCProgressHUD hide];

        });
    }else{
        //特殊处理
//        if([url containsString:URL_UPDATE_PSW]){
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [LCProgressHUD hide];
//            });
//        }else{
            [LCProgressHUD hide];
//        }

    }
    if([model.status isEqualToString:STATU_INVALID]){
        LoginPage *page = [[LoginPage alloc]init];
        UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:page];
        navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
        if(![[self getCurrentVC] isKindOfClass:[LoginPage class]]){
            [[self getCurrentVC] presentViewController:navigationController animated:YES completion:nil];
        }
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;

}


#pragma mark 失败处理
+(void)handleFail : (NSURLResponse *)response failure:(void (^)(int))failure url:(NSString *)url{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    NSInteger errorCode = httpResponse.statusCode;
    if(errorCode == 502){
        dispatch_main_async_safe(^{
         [LCProgressHUD showMessage:@"服务器异常"];
        });
    }else if(errorCode == 0){
        dispatch_main_async_safe(^{
            [LCProgressHUD showMessage:MSG_NET_ERROR];
        });
    }
    NSString *errorInfo = [NSString stringWithFormat:@"\n------------------------------------\n***url:%@\n***网络错误码:%ld\n------------------------------------",url,errorCode];
    [STLog print:errorInfo];
    dispatch_main_async_safe(^{
        failure((int)errorCode);
    });
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [LCProgressHUD hide];
    });
}


#pragma mark 打印请求错误信息
+(void)printErrorInfo:(RespondModel *)model url:(NSString *)url{
    NSString *body = MSG_EMPTY;
    if([model.data isKindOfClass:[NSData class]]){
        body = [STConvertUtil dataToString:model.data];
    }
    if([model.data isKindOfClass:[NSDictionary class]]){
        body = [model.data mj_JSONString];
    }
    NSString *errorInfo = [NSString stringWithFormat:@"\n------------------------------------\n***url:%@ \n***请求错误码:%@ \n***错误信息:%@\n------------------------------------\n%@",url,model.status,model.msg,body];
    
    [STLog print:errorInfo];
}




+(Boolean)getNetStatu{
    int netStatu = [[ STUserDefaults getKeyValue:UD_NET_STATU] intValue];
    return (netStatu == 1) ? YES : NO;
}


#pragma mark 监听网络状态
+(void)startListenNetWork{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusUnknown) {
            NSLog(@"当前网络：未知网络");
            [STUserDefaults saveKeyValue:UD_NET_STATU value:@(0)];
            [LCProgressHUD showMessage:MSG_NET_ERROR];
        } else if (status == AFNetworkReachabilityStatusNotReachable) {
            NSLog(@"当前网络：没有网络");
            [STUserDefaults saveKeyValue:UD_NET_STATU value:@(0)];
            [LCProgressHUD showMessage:MSG_NET_ERROR];
        } else if (status == AFNetworkReachabilityStatusReachableViaWWAN) {
            NSLog(@"当前网络：手机流量");
            [STUserDefaults saveKeyValue:UD_NET_STATU value:@(1)];
        } else if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
            NSLog(@"当前网络：WiFi");
            [STUserDefaults saveKeyValue:UD_NET_STATU value:@(1)];
        }
    }];
    [manager startMonitoring];
}

#pragma mark 请求前网络检查
+(void)checkNetwork{
//    if(![self getNetStatu]){
//        dispatch_main_async_safe(^{
//            [LCProgressHUD showMessage:MSG_NET_ERROR];
//        });
//    }
}


#pragma mark 获取当前controller
+ (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    return result;
}


+(void)getConfig:(NSString *)key success:(void (^)(NSString *))result{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"cfgKey0"]= key;
    [STNetUtil get:URL_SPECIAL_SETTING parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id data = respondModel.data;
            NSString *content = [data objectForKey:@"cfgValue"];
            result(content);
        }
    } failure:^(int errorCode) {
        
    }];
}

@end
