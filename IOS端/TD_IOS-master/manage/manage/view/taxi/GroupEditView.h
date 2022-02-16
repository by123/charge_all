//
//  GroupEditView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupEditViewModel.h"


@interface GroupEditView : UIView

-(instancetype)initWithViewModel:(GroupEditViewModel *)viewModel;
-(void)updateSaleSelectView;

@end

