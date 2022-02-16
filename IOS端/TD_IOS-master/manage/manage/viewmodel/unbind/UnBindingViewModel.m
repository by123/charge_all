//
//  UnBindingViewModel.m
//  manage
//
//  Created by by.huang on 2019/5/16.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "UnBindingViewModel.h"

@implementation UnBindingViewModel


-(void)goScanBindPage{
    if(_delegate){
        [_delegate onGoScanBindPage];
    }
}

-(void)goMerchantBindPage{
    if(_delegate){
        [_delegate onGoMerchantBindPage];
    }
}

@end
