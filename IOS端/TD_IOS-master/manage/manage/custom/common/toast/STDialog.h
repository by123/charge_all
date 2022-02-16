//
//  STDialog.h
//  manage
//
//  Created by by.huang on 2019/5/21.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STDialogDelegate <NSObject>

-(void)onConfirmBtnClicked;
-(void)onCancelBtnClicked;


@end


@interface STDialog : UIView

@property(weak, nonatomic)id<STDialogDelegate> delegate;

-(instancetype)initWithTitle:(NSString *)title content:(NSString *)content subContent:(NSString *)subContent size:(CGSize)size;

-(void)showConfirmBtn:(Boolean)confirm cancelBtn:(Boolean)cancel;





@end
