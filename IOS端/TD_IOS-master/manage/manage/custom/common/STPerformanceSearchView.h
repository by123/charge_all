//
//  STPerformanceSearchView.h
//  manage
//
//  Created by by.huang on 2019/6/18.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STPerformanceSearchDelegate <NSObject>

-(void)onPerformanceSearchBtnSelected:(NSInteger)position content:(NSString *)content;
-(void)onPerformanceSearchTextFieldChange:(NSString *)content;
-(void)onPerformanceSearchClicked:(NSString *)key;

@end


@interface STPerformanceSearchView : UIView

-(instancetype)initWithSearchView:(CGRect)frame searchBtn:(Boolean)hidden;

@property(weak, nonatomic)id<STPerformanceSearchDelegate> delegate;

-(void)hiddenKeyboard;

@end

