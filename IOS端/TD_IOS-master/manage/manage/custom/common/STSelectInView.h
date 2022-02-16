//
//  STSelectInView.h
//  manage
//
//  Created by by.huang on 2018/11/30.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STSelectInViewDelegate<NSObject>

-(void)onSelectClicked:(id)selectInView;

@end

@interface STSelectInView : UIView

@property(weak, nonatomic)id<STSelectInViewDelegate> delegate;

-(instancetype)initWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder frame:(CGRect)frame;

-(void)setContent:(NSString *)content;

-(NSString *)getContent;

@end



