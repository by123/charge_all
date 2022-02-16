//
//  WhiteListEditViewModel.m
//  manage
//
//  Created by by.huang on 2019/7/2.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "WhiteListEditViewModel.h"
#import "STNetUtil.h"

@interface WhiteListEditViewModel()

@end

@implementation WhiteListEditViewModel


//编辑白名单
-(void)editWhiteListScope{
    if(!_delegate)  return;
    [_delegate onRequestBegin];
    NSMutableArray *mchIds = [[NSMutableArray alloc]init];
    if(!IS_NS_COLLECTION_EMPTY(_selectDatas)){
        for(WTScopeModel *model in _selectDatas){
            if(model.selected == WHITELIST_SELECT_ALL){
                Boolean add = YES;
                //如果为全选中，则只选择父级
                for(WTScopeModel *temp in _selectDatas){
                    if([model.parentAgencyId isEqualToString:temp.mchId] && temp.selected == WHITELIST_SELECT_ALL){
                        add = NO;
                        break;
                    }
                }
                if(add){
                    [mchIds addObject:model.mchId];
                }
            }
        }
    }
//    if(IS_NS_COLLECTION_EMPTY(mchIds)){
//        [LCProgressHUD showMessage:@"请选择一个范围"];
//        return;
//    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    if(!IS_NS_COLLECTION_EMPTY(mchIds)){
        dic[@"mchIds"] = mchIds;
    }
    dic[@"orderWhiteListId"] = _recordModel.orderWhiteListId;
    dic[@"userName"] = _recordModel.userName;
    dic[@"duration"] = @(_recordModel.duration);
    dic[@"timeLevel"] = @(_recordModel.timeLevel);
    [STLog print:dic.mj_JSONString];
    WS(weakSelf)
    [STNetUtil post:URL_WHITELIST_CHANGE_STATU content:dic.mj_JSONString success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            [weakSelf.delegate onRequestSuccess:respondModel data:respondModel.data];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}

-(void)goWhiteListChargeTimePage:(NSString *)timeLevel{
    if(_delegate){
        [_delegate onGoWhiteListChargeTimePage:timeLevel];
    }
}

-(void)goWhiteListScopePage:(NSString *)orderWhiteListId{
    if(_delegate){
        [_delegate onGoWhiteListScopePage:orderWhiteListId];
    }
}


@end
