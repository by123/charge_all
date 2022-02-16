//
//  STConfirmLayerView.h
//  manage
//
//  Created by by.huang on 2018/12/3.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TitleContentModel.h"

@protocol STConfirmLayerViewDelegate

-(void)onUpdateBtnClicked;
-(void)onConfirmBtnClicked;

@end

@interface STConfirmLayerView : UIView

@property(weak, nonatomic)id<STConfirmLayerViewDelegate> delegate;

-(instancetype)initWithTitle:(NSString *)title datas:(NSMutableArray *)datas;


-(void)updateContents:(NSMutableArray *)datas;

@end

