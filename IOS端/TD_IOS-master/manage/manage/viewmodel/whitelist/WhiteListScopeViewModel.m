//
//  WhiteListScopeViewModel.m
//  manage
//
//  Created by by.huang on 2019/3/17.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "WhiteListScopeViewModel.h"
#import "STFileUtil.h"
#import "STNetUtil.h"
#import "AccountManager.h"

@interface WhiteListScopeViewModel()

@end

@implementation WhiteListScopeViewModel{
    Boolean hasEdit;
}

-(instancetype)init{
    if(self == [super init]){
        _scopeDatas = [[NSMutableArray alloc]init];
    }
    return self;
}

//初始化最上层数据
-(void)initTopLayerDatas{
    UserModel *userModel = [[AccountManager sharedAccountManager] getUserModel];

    WTScopeModel *model = [[WTScopeModel alloc]init];
    model.mchId = userModel.mchId;
    model.mchName = userModel.mchName;
    model.isExpand = YES;
    model.isQuery = YES;
    if(_from == WHITELIST_FROM_CREATE){
        model.selected = WHITELIST_SELECT_NONE;
    }else{
        model.selected = WHITELIST_SELECT_HALF;
    }
    [_scopeDatas addObject:model];
}

//查询下一级,创建的时候
-(void)queryChildDatas:(NSString *)mchId selected:(WhiteListSelectStatu)selected position:(NSInteger)position{
    if(!_delegate)  return;
    [_delegate onRequestBegin];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"mchId"] = mchId;
    WS(weakSelf)
    [STNetUtil get:URL_WHITELIST_QUERY_CHILD parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            weakSelf.scopeDatas = [WTScopeModel mj_objectArrayWithKeyValuesArray:respondModel.data];
            //如果上级被选中或者不被选中，则下级跟随上级选中状态
            if(selected == WHITELIST_SELECT_ALL || selected == WHITELIST_SELECT_NONE){
                [weakSelf.scopeDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    WTScopeModel *model = [weakSelf.scopeDatas objectAtIndex:idx];
                    model.selected = selected;
                }];
            }
            //第一层级需要显示分割线
            UserModel *model = [[AccountManager sharedAccountManager]getUserModel];
            if([model.mchId isEqualToString:mchId]){
                [weakSelf.scopeDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    WTScopeModel *model = [weakSelf.scopeDatas objectAtIndex:idx];
                    model.showLine = YES;
                }];
            }
            [weakSelf.delegate onRequestSuccess:respondModel data:@(position)];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}

-(void)goEditWhiteListPage:(NSMutableArray *)datas{
    if(_delegate){
        [_delegate onGoEditWhiteListPage:datas];
    }
}


-(void)saveSelect:(NSMutableArray *)selectDatas{
    if(_delegate){
        [_delegate onSaveSelect:selectDatas];
    }
}


//查询使用范围,编辑的时候
-(void)requestScopeList:(NSString *)mchId selected:(WhiteListSelectStatu)selected position:(NSInteger)position{
    if(!_delegate)  return;
    [_delegate onRequestBegin];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"orderWhiteListId"] = _orderWhiteListId ;
    dic[@"mchId"] = mchId;
    WS(weakSelf)
    [STNetUtil get:URL_WHITELIST_QUERY_SCOPE parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            weakSelf.scopeDatas = [WTScopeModel mj_objectArrayWithKeyValuesArray:respondModel.data];
            //如果上级被选中或者不被选中，则下级跟随上级选中状态
            if(self->hasEdit){
                if(selected == WHITELIST_SELECT_ALL || selected == WHITELIST_SELECT_NONE){
                    [weakSelf.scopeDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        WTScopeModel *model = [weakSelf.scopeDatas objectAtIndex:idx];
                        model.selected = selected;
                    }];
                }
            }else{
                self->hasEdit = YES;
            }
 
            //第一层级需要显示分割线
            UserModel *model = [[AccountManager sharedAccountManager]getUserModel];
            if([model.mchId isEqualToString:mchId]){
                [weakSelf.scopeDatas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    WTScopeModel *model = [weakSelf.scopeDatas objectAtIndex:idx];
                    model.showLine = YES;
                }];
            }
            [weakSelf.delegate onRequestSuccess:respondModel data:@(position)];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}

//查询使用范围数据解析
-(void)parseScopeDatas:(NSMutableArray *)datas{
    for(WTScopeModel *model in datas){
        model.selected = model.selected;
        model.isExpand = YES;
        [_scopeDatas addObject:model];
        if(model.hasChild){
            NSMutableArray *childDatas =  [WTScopeModel mj_objectArrayWithKeyValuesArray:model.child];
            [self parseScopeDatas:childDatas];
        }
    }
}




@end
