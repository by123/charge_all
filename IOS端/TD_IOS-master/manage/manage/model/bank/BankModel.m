//
//  BankModel.m
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "BankModel.h"

@implementation BankModel

+(Boolean)hasAllType:(NSMutableArray *)datas{
    Boolean hasWeChatType = NO;
    Boolean hasGeRenType = NO;
    Boolean hasDuiGongType = NO;
    for(BankModel *model in datas){
        if(model.isPublic == 0){hasGeRenType = YES;}
        else if(model.isPublic == 1){hasDuiGongType = YES;}
        else if(model.isPublic == 2){hasWeChatType = YES;}
    }
    if(IS_RED_SKIN){
        return hasGeRenType && hasDuiGongType;
    }
    return hasWeChatType && hasGeRenType && hasDuiGongType;
}


@end
