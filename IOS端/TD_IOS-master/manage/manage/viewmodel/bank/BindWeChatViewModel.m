//
//  BindWeChatViewModel.m
//  manage
//
//  Created by by.huang on 2019/4/29.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "BindWeChatViewModel.h"
#import "STNetUtil.h"

@implementation BindWeChatViewModel

-(void)doWeChatAuth{
    if(_delegate){
       [_delegate onDoWeChatAuth];
    }
}

-(void)bindWeChat:(NSString *)code{
    if(!_delegate)  return;
    [_delegate onRequestBegin];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"code"] = code;
    WS(weakSelf)
    [STNetUtil get:URL_BIND_WECAHT parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            [weakSelf.delegate onRequestSuccess:respondModel data:respondModel.data];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}
@end
