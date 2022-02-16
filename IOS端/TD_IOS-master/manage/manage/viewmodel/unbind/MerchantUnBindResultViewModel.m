//
//  MerchantUnBindResultViewModel.m
//  manage
//
//  Created by by.huang on 2019/5/20.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "MerchantUnBindResultViewModel.h"

@implementation MerchantUnBindResultViewModel

-(void)bankHome{
    if(_delegate){
        [_delegate onBankHome];
    }
}
@end
