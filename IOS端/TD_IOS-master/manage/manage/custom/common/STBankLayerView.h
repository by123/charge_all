//
//  STBankLayerView.h
//  manage
//
//  Created by by.huang on 2018/12/4.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankSelectModel.h"

@protocol STBankLayerViewDelegte <NSObject>

-(void)onSelectResult:(BankSelectModel *)data layerView:(UIView *)layerView position:(NSInteger)position;

@end


@interface STBankLayerView : UIView

@property(weak, nonatomic)id<STBankLayerViewDelegte> delegate;

-(BankSelectModel *)getCurrentModel;
-(void)updatePosition:(BankSelectModel *)model;

@end
