//
//  STRecentDateView.h
//  manage
//
//  Created by by.huang on 2019/6/18.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol STRecentDateViewDelegate

-(void)onRecentDateViewSelected:(NSInteger)positon str:(NSString *)str;

@end

@interface STRecentDateView : UIView

@property(weak,nonatomic)id<STRecentDateViewDelegate> delegate;

-(void)clearAllDateSelect;
-(void)setRecentDateSelect:(int)position;

@end

NS_ASSUME_NONNULL_END
