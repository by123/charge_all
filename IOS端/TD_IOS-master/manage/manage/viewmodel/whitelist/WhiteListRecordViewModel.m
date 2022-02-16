//
//  WhiteListRecordViewModel.m
//  manage
//
//  Created by by.huang on 2019/3/15.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "WhiteListRecordViewModel.h"
#import "STNetUtil.h"
#import "WTRecordRespondModel.h"
#import "WTScopeModel.h"

@interface WhiteListRecordViewModel()

@property(assign, nonatomic)int record_PID;

@end

@implementation WhiteListRecordViewModel

-(instancetype)init{
    if(self == [super init]){
        _record_PID = 1;
        _recordDatas = [[NSMutableArray alloc]init];
        _scopeDatas = [[NSMutableArray alloc]init];
    }
    return self;
}

//白名单记录
-(void)requestRecordList:(Boolean)refreshNew{
    if(!_delegate)  return;
    [_delegate onRequestBegin];
    if(refreshNew){
        _record_PID = 1;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"pageId"] = @(_record_PID);
    dic[@"pageSize"] = @(PAGESIZE);
    WS(weakSelf)
    [STNetUtil get:URL_WHITELIST_RECORD parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id data = respondModel.data;
            id row = [data objectForKey:@"rows"];
            if(row == [NSNull null]){
                [weakSelf.recordDatas removeAllObjects];
                [weakSelf.delegate onRequestNoData];
                return;
            }
            NSMutableArray *rows = [weakSelf parseDatas:row];
            if(refreshNew){
                weakSelf.recordDatas = rows;
            }else{
                [weakSelf.recordDatas addObjectsFromArray:rows];
            }
            
            //如果还有数据
            BOOL nextPage = [[data objectForKey:@"nextPage"] boolValue];
            if(nextPage){
                weakSelf.record_PID += 1;
                [weakSelf.delegate onRequestSuccess:respondModel data:respondModel.data];
            }else{
                [weakSelf.delegate onRequestNoData];
            }
            
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}

//白名单记录解析数据
-(NSMutableArray *)parseDatas:(id)row{
    NSMutableArray *rows = [[NSMutableArray alloc]init];
    NSMutableArray *responds = [WTRecordRespondModel mj_objectArrayWithKeyValuesArray:row];
    if(!IS_NS_COLLECTION_EMPTY(responds)){
        for(WTRecordRespondModel *temp in responds){
            if(temp.tblOrderWhiteList && temp.tblUserUnionid){
                WTRecordModel *model = [WTRecordModel mj_objectWithKeyValues:temp.tblOrderWhiteList];
                model.headUrl = [temp.tblUserUnionid objectForKey:@"headUrl"];
                [rows addObject:model];
            }
        }
    }
    return rows;
}

//启用/暂停白名单
-(void)changeWhiteListStatu:(Boolean)statu wtId:(NSString *)whiteListId{
    if(!_delegate)  return;
    [_delegate onRequestBegin];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    //1启用 2禁用
    dic[@"whiteListState"] = statu ? @(1) : @(2);
    dic[@"orderWhiteListId"] = whiteListId;
    WS(weakSelf)
    [STNetUtil post:URL_WHITELIST_CHANGE_STATU content:dic.mj_JSONString success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            WTRecordModel *model = [[WTRecordModel alloc]init];
            model.orderWhiteListId = whiteListId;
            model.whiteListState = statu ? 1 : 2;
            [weakSelf.delegate onRequestSuccess:respondModel data:model];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}


//查询使用范围
-(void)requestScopeList:(NSString *)mchId orderWhiteListId:(NSString *)orderWhiteListId purpose:(int)purpose{
    if(!_delegate)  return;
    [_delegate onRequestBegin];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"orderWhiteListId"] = orderWhiteListId;
    dic[@"mchId"] = mchId;
    WS(weakSelf)
    [STNetUtil get:URL_WHITELIST_QUERY_SCOPE parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            [weakSelf.scopeDatas removeAllObjects];
            NSMutableArray *datas = [WTScopeModel mj_objectArrayWithKeyValuesArray:respondModel.data];
            [self parseScopeDatas:datas];
            NSArray *sendDatas = @[@(purpose),orderWhiteListId];
            [weakSelf.delegate onRequestSuccess:respondModel data:sendDatas];
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

-(void)goWhiteListPage{
    if(_delegate){
        [_delegate onGoWhiteListPage];
    }
}


//改变状态
-(void)doChangeState:(WTRecordModel *)model{
    if(_delegate){
        [_delegate onDoChangeState:model];
    }
}


//编辑
-(void)doEditScope:(NSString *)mchId model:(WTRecordModel *)model{
    if(_delegate){
        [_delegate onDoEditScope:mchId model:model];
    }
}

////改变适用范围
//-(void)doChangeScope:(NSString *)mchId model:(WTRecordModel *)model{
//    if(_delegate){
//        [_delegate onDoChangeScope:mchId model:model];
//    }
//}


//复制
-(void)doCopy:(WTRecordModel *)model{
    if(_delegate){
        [_delegate onDoCopy:model];
    }
}



@end
