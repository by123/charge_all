//
//  GroupCreateViewModel.m
//  manage
//
//  Created by by.huang on 2019/4/2.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "GroupCreateViewModel.h"
#import "STNetUtil.h"
@implementation GroupCreateViewModel


-(instancetype)init{
    if(self == [super init]){
        _model = [[GroupModel alloc]init];
        _salemanDatas = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)createGroup{
    if(!_delegate) return;
    [_delegate onRequestBegin];
    WS(weakSelf)
    [STNetUtil post:URL_GROUP_ADD content:_model.mj_JSONString success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id data = respondModel.data;
            weakSelf.model = [GroupModel mj_objectWithKeyValues:data];
            [weakSelf.delegate onRequestSuccess:respondModel data:data];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
        
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}

-(void)requestSaleMans{
    if(!_delegate)  return;
    [_delegate onRequestBegin];
    WS(weakSelf)
    [STNetUtil get:URL_ALL_USER parameters:nil success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            weakSelf.salemanDatas = [SalemanModel mj_objectArrayWithKeyValuesArray:respondModel.data];
            [weakSelf.delegate onRequestSuccess:respondModel data:respondModel.data];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}


@end
