//
//  GroupCreateSuccessViewModel.m
//  manage
//
//  Created by by.huang on 2019/4/3.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "GroupCreateSuccessViewModel.h"

@implementation GroupCreateSuccessViewModel


-(void)backListPage{
    if(_delegate){
        [_delegate onBackListPage];
    }
}
-(void)goScanPage{
    if(_delegate){
        [_delegate onGoScanPage:_groupId groupName:_groupName];
    }
}


@end
