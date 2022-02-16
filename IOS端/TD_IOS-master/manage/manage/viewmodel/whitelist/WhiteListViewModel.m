//
//  WhiteListViewModel.m
//  manage
//
//  Created by by.huang on 2019/3/15.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "WhiteListViewModel.h"
#import "AccountManager.h"
#import "WXApi.h"
#import "STNetUtil.h"
#import "WTScopeModel.h"

@implementation WhiteListViewModel


-(void)createWhiteList:(NSMutableArray *)datas userName:(NSString *)userName orderWhiteListId:(NSString *)orderWhiteListId scale:(int)scale time:(NSString *)time{
    if(!_delegate) return;
    [_delegate onRequestBegin];
    NSMutableArray *mchIds = [[NSMutableArray alloc]init];
    if(!IS_NS_COLLECTION_EMPTY(datas)){
        for(WTScopeModel *model in datas){
            if(model.selected == WHITELIST_SELECT_ALL){
                Boolean add = YES;
                //如果为全选中，则只选择父级
                for(WTScopeModel *temp in datas){
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
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"userName"] = userName;
    dic[@"timeLevel"] = @(scale);
    dic[@"duration"] = time;
    if(IS_NS_STRING_EMPTY(orderWhiteListId)){
        dic[@"mchIds"] = mchIds;
    }else{
        dic[@"orderWhiteListId"] = orderWhiteListId;
    }
    WS(weakSelf)
    [STNetUtil post:URL_WHITELIST_CREATE content:dic.mj_JSONString success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            NSString *data = respondModel.data;
            [weakSelf.delegate onRequestSuccess:respondModel data:data];
            [self invite:data];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
        
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}


-(void)invite:(NSString *)data{
    UIImage *inviteImage = [UIImage imageNamed:IMAGE_SHATE_WHITELIST];
    
    NSString *url = [NSString stringWithFormat:@"pages/whitelist/whitelist?data=%@",data];
    WXMiniProgramObject *object = [WXMiniProgramObject object];
    object.webpageUrl = url;
    object.userName = MINIAPP_ID;
    object.path =  url;
    object.hdImageData = UIImagePNGRepresentation(inviteImage);
    object.withShareTicket = YES;
    object.miniProgramType = MINIAPP_ENV;

    WXMediaMessage *message = [WXMediaMessage message];
    message.title = MSG_INVITE;
    message.mediaObject = object;

    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    [WXApi sendReq:req completion:^(BOOL success) {
        
    }];
}

-(void)goWhiteListScopePage:(NSString *)orderWhiteListId{
    if(_delegate){
        [_delegate onGoWhiteListScopePage:orderWhiteListId];
    }
}

-(void)goWhiteListChargeTimePage:(NSString *)scale{
    if(_delegate){
        [_delegate onGoWhiteListChargeTimePage:scale];
    }
}

@end
