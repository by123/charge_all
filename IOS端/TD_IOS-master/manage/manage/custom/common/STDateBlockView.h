//
//  STDateBlockView.h
//  manage
//
//  Created by by.huang on 2019/6/18.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STDateBlockViewDelegate

-(void)onDateBlockSelected:(NSString *)startDate endDate:(NSString *)endDate;

@end

@interface STDateBlockView : UIButton

@property(weak, nonatomic)id<STDateBlockViewDelegate> delegate;

-(void)setController:(UIViewController *)controller;
-(void)setDate:(NSString *)startDate endDate:(NSString *)endDate;
-(void)setMaxSelectDays:(int)days;
@end

