//
//  GroupEditViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupModel.h"

@protocol GroupEditViewDelegate<BaseRequestDelegate>

@end


@interface GroupEditViewModel : NSObject

@property(weak, nonatomic)id<GroupEditViewDelegate> delegate;
@property(strong, nonatomic)GroupModel *model;
@property(strong, nonatomic)NSMutableArray *salemanDatas;

-(void)requestSaleMans;
-(void)editGroup;

@end


