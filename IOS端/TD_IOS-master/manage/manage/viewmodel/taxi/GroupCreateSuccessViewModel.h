//
//  GroupCreateSuccessViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GroupCreateSuccessViewDelegate<BaseRequestDelegate>

-(void)onBackListPage;
-(void)onGoScanPage:(NSString *)groupId groupName:(NSString *)groupName;

@end


@interface GroupCreateSuccessViewModel : NSObject

@property(weak, nonatomic)id<GroupCreateSuccessViewDelegate> delegate;
@property(copy, nonatomic)NSString *groupId;
@property(copy, nonatomic)NSString *groupName;

-(void)backListPage;
-(void)goScanPage;

@end



