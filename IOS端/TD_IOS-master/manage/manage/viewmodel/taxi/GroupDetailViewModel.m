
//
//  GroupDetailViewModel.m
//  manage
//
//  Created by by.huang on 2019/4/4.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "GroupDetailViewModel.h"
#import "STNetUtil.h"

@implementation GroupDetailViewModel

-(instancetype)init{
    if(self == [super init]){
        _groupModel = [[GroupModel alloc]init];
    }
    return self;
}

-(void)goGroupEditPage{
    if(_delegate){
        [_delegate onGoGroupEditPage:_groupModel];
    }
}

-(void)requestGroupDetail{
    if(!_delegate)  return;
    [_delegate onRequestBegin];
    WS(weakSelf)
    [STNetUtil get:[NSString stringWithFormat:@"%@/%@",URL_GROUP_DETAIL,_groupModel.groupId] parameters:nil success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            weakSelf.groupModel = [GroupModel mj_objectWithKeyValues:respondModel.data];
            [weakSelf.delegate onRequestSuccess:respondModel data:respondModel.data];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}
@end
