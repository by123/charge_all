//
//  MerchantUnBindViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UnBindModel.h"
#import "MerchantModel.h"

@protocol MerchantUnBindViewDelegate<BaseRequestDelegate>

-(void)onOpenDialog;

@end


@interface MerchantUnBindViewModel : NSObject

@property(weak, nonatomic)id<MerchantUnBindViewDelegate> delegate;
@property(strong, nonatomic)MerchantModel *mchModel;
@property(strong, nonatomic)UnBindModel *model;


-(void)queryMerchantDetail;
-(void)doUnbindMerchant;
-(void)openDialog;

@end


