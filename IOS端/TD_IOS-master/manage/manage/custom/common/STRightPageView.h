//
//  STRightPageVIew.h
//  manage
//
//  Created by by.huang on 2019/1/15.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol STRightPageViewDelegate <NSObject>

-(void)onPageViewSelect:(NSInteger)position view:(id)view;

@end

@interface STRightPageView : UIView

@property(weak, nonatomic)id<STRightPageViewDelegate> delegate;

-(instancetype)initWithFrame:(CGRect)frame views:(NSMutableArray *)views titles:(NSArray *)titles;
-(instancetype)initWithFrame:(CGRect)frame views:(NSMutableArray *)views titles:(NSArray *)titles perLine:(CGFloat)perLine;
-(void)setCurrentTab:(NSInteger)tab;
-(void)changeFrame:(CGFloat)height;
-(void)fastenTopView:(CGFloat)top;
-(id)getCurrentView;


@end

