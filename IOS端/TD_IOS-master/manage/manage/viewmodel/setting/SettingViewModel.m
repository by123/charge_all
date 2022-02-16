//
//  SettingViewModel.m
//  manage
//
//  Created by by.huang on 2018/11/6.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "SettingViewModel.h"
#import "AccountManager.h"

@implementation SettingViewModel


-(void)doLogout{
    if(_delegate){
        [_delegate onLogout];
    }
}

-(void)goUpdatePswPage{
    if(_delegate){
        [_delegate onGoUpdatePswPage];
    }
}

-(void)goAboutPage{
    if(_delegate){
        [_delegate onGoAboutPage];
    }
}

@end
