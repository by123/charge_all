//
//  ResultViewModel.m
//  manage
//
//  Created by by.huang on 2018/10/29.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "ResultViewModel.h"

@implementation ResultViewModel

-(void)doCopy{
    if(_delegate){
        [_delegate onCopyCallback:_mUserNameStr psw:_mPswStr];
    }
}

-(void)doConfirm{
    if(_delegate){
        [_delegate onConfirmCallBack];
    }
}
@end
