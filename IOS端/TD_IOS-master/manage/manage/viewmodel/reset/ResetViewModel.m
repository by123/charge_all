//
//  ResetViewModel.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "ResetViewModel.h"
#import "STNetUtil.h"

@implementation ResetViewModel


-(void)doReset{
    if(!_delegate)  return;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"deviceSn"] = _deviceSNStr;
    [_delegate onRequestBegin];
    WS(weakSelf)
    [STNetUtil get:URL_RESET_PSW parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            [weakSelf.delegate onRequestSuccess:respondModel data:respondModel.data];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}

-(void)confirmReset{
    if(!_delegate)  return;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"deviceSn"] = _deviceSNStr;
    [_delegate onRequestBegin];
    WS(weakSelf)
    [STNetUtil get:URL_CONFIRM_RESET parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            [weakSelf.delegate onRequestSuccess:respondModel data:respondModel.data];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}

-(void)doCall{
    NSString *callPhone = IS_YELLOW_SKIN ? [NSString stringWithFormat:@"telprompt://%@",@"4008818319"] : [NSString stringWithFormat:@"telprompt://%@",@"4008915518"];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
    }
}


@end
