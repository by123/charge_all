//
//  BankSelectPage.h
//  by
//
//  Created by by.huang on block.
//  Copyright © 2018 by.huang. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface BankSelectPage : BaseViewController

+(void)show:(BaseViewController *)controller datas:(NSMutableArray *)datas;
-(void)goAddBankHomePage;

@end

