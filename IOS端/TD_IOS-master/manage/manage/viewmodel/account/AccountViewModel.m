//
//  AccountViewModel.m
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "AccountViewModel.h"
#import "STNetUtil.h"

@implementation AccountViewModel

//-(void)getMyDetailData{
//    if(!_delegate)  return;
//    [_delegate onRequestBegin];
//    WS(weakSelf)
//    [STNetUtil get:URL_MYDETAIL parameters:nil success:^(RespondModel *respondModel) {
//        if([respondModel.status isEqualToString:STATU_SUCCESS]){
//            id user = [respondModel.data objectForKey:@"user"];
//            AccountModel *model = [AccountModel mj_objectWithKeyValues:user];
//            [weakSelf.delegate onRequestSuccess:respondModel data:model];
//        }else{
//            [weakSelf.delegate onRequestFail:respondModel.msg];
//        }
//    } failure:^(int errorCode) {
//        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
//    }];
//}



@end
