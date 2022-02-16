//
//  ChainViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddChainModel.h"

@protocol ChainViewDelegate<BaseRequestDelegate>

-(void)onGoLocationPage;

@end


@interface ChainViewModel : NSObject
    
@property(weak, nonatomic)id<ChainViewDelegate> delegate;
@property(strong, nonatomic)AddChainModel *model;
    
-(void)addChain;
-(void)goLocationPage;

@end


