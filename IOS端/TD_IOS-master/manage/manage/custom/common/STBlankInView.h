//
//  STBlankInView.h
//  manage
//
//  Created by by.huang on 2018/11/30.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STBlankInViewDelegate<NSObject>

- (void)onTextFieldDidChange:(UITextField *)textField;

@end

@interface STBlankInView : UIView

@property(weak, nonatomic)id<STBlankInViewDelegate> delegate;

-(instancetype)initWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder;

-(void)setContent:(NSString *)content;

-(NSString *)getContent;

-(void)inputNumber;

-(BOOL)resign;

@end

