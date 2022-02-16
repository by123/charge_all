//
//  BankDetailViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BankDetailViewModel.h"
#import "BankModel.h"
@protocol BankDetailViewDelegate<BaseRequestDelegate>

@end


@interface BankDetailViewModel : NSObject

-(instancetype)initWithModel:(BankModel *)bankModel;

@property(weak, nonatomic)id<BankDetailViewDelegate> delegate;
@property(strong, nonatomic)NSMutableArray *datas;
@property(strong, nonatomic)BankModel *bankModel;

@end


