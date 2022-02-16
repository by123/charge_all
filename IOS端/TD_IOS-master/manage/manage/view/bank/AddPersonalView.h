//
//  AddPersonalBankView.h
//  manage
//
//  Created by by.huang on 2018/12/1.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddBankViewModel.h"


@interface AddPersonalView : UIView

-(instancetype)initWithViewModel:(AddBankViewModel *)viewModel;
-(void)updateView;
-(void)updateBankName:(BankSelectModel *)bankModel;

@end

