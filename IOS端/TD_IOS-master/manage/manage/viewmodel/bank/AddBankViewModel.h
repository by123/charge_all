//
//  AddBankViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BankCommitModel.h"
#import "BankSelectModel.h"

@protocol AddBankViewDelegate<BaseRequestDelegate>

@end


@interface AddBankViewModel : NSObject

@property(weak, nonatomic)id<AddBankViewDelegate> delegate;
@property(strong,nonatomic)BankCommitModel *model;

//保存公账信息
-(void)doSaveCorporateBank;

//保存个人账户信息
-(void)doSavePersonBank;
    
//卡bin校验
-(void)checkCardNum:(NSString *)cardNum;


@end


