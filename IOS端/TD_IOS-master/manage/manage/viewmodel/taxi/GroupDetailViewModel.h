//
//  GroupDetailViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupModel.h"

@protocol GroupDetailViewDelegate<BaseRequestDelegate>

-(void)onGoGroupEditPage:(GroupModel *)groupModel;

@end


@interface GroupDetailViewModel : NSObject

@property(weak, nonatomic)id<GroupDetailViewDelegate> delegate;
@property(strong, nonatomic)GroupModel *groupModel;

-(void)goGroupEditPage;
-(void)requestGroupDetail;

@end


