//
//  SalemanViewModel.h
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddSalemanModel.h"

@protocol SalemanViewDelegate <BaseRequestDelegate>

@end

@interface SalemanViewModel : NSObject

@property(weak, nonatomic)id<SalemanViewDelegate> delegate;
@property(strong, nonatomic)AddSalemanModel *model;

-(void)addSaleman;

@end

