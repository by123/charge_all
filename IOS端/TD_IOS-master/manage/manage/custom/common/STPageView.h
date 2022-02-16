//
//  STPageView.h
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STPageViewDelegate <NSObject>

-(void)onPageViewSelect:(NSInteger)position view:(id)view;

@end

@interface STPageView : UIView

@property(weak, nonatomic)id<STPageViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame views:(NSMutableArray *)views titles:(NSArray *)titles;
-(instancetype)initWithFrame:(CGRect)frame views:(NSMutableArray *)views titles:(NSArray *)titles perLine:(CGFloat)perLine;
-(void)setCurrentTab:(NSInteger)tab;
-(void)changeFrame:(CGFloat)height;
-(void)fastenTopView:(CGFloat)top;
-(id)getCurrentView;


@end

