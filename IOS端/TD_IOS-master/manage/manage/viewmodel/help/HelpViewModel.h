//
//  HelpViewModel.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HelpViewDelegate<BaseRequestDelegate>

@end


@interface HelpViewModel : NSObject

@property(weak, nonatomic)id<HelpViewDelegate> delegate;
@property(copy, nonatomic)NSString *content;


@end


