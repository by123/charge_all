//
//  WhiteListChargeTimeViewModel.m
//  manage
//
//  Created by by.huang on 2019/6/19.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "WhiteListChargeTimeViewModel.h"

@implementation WhiteListChargeTimeViewModel

-(instancetype)init{
    if(self == [super init]){
        _datas = [[NSMutableArray alloc]init];
        NSString *dataStr = [STUserDefaults getKeyValue:CONFIG_WHITELIST_TIME];
        _datas=[WTChargeTimeModel mj_objectArrayWithKeyValuesArray:dataStr];
        if(!IS_NS_COLLECTION_EMPTY(_datas)){
            WTChargeTimeModel *firstModel = [_datas objectAtIndex:0];
            firstModel.isSelect = YES;
        }
    }
    return self;
}

-(void)goBack{
    if(_delegate){
        [_delegate onGoBack];
    }
}

@end
