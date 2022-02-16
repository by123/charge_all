//
//  WithdrawView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WithdrawViewModel.h"


@interface WithdrawView : UIView

-(instancetype)initWithViewModel:(WithdrawViewModel *)viewModel;
-(void)updateBankView;
-(void)updateRuleView:(Boolean)isWechat;
-(void)updateAuxiliary;

@end

