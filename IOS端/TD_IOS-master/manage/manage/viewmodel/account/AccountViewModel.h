//
//  AccountViewModel.h
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountModel.h"

@protocol AccountViewDelegate <BaseRequestDelegate>

@end

@interface AccountViewModel : NSObject

@property(weak, nonatomic)id<AccountViewDelegate> delegate;

//-(void)getMyDetailData;

@end

