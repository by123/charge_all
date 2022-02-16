//
//  MsgDetailViewModel.m
//  manage
//
//  Created by by.huang on 2019/7/19.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "MsgDetailViewModel.h"
#import "STNetUtil.h"

@implementation MsgDetailViewModel

-(void)requesMsgDetail{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"id"] = _msgId;
    if(!_delegate)  return;
    [_delegate onRequestBegin];
    WS(weakSelf)
    [STNetUtil get:URL_MSG_DETAIL parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            weakSelf.model = [MsgModel mj_objectWithKeyValues:respondModel.data];
            [weakSelf.delegate onRequestSuccess:respondModel data:respondModel.data];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}
@end
