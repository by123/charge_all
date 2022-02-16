//
//  GroupCreateViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupModel.h"
#import "SalemanModel.h"

@protocol GroupCreateViewDelegate<BaseRequestDelegate>

@end


@interface GroupCreateViewModel : NSObject

@property(strong, nonatomic)GroupModel *model;
@property(strong, nonatomic)NSMutableArray *salemanDatas;

@property(weak, nonatomic)id<GroupCreateViewDelegate> delegate;

-(void)createGroup;
-(void)requestSaleMans;

@end


