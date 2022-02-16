//
//  STPriceView.h
//  manage
//
//  Created by by.huang on 2018/11/3.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface STPriceView : UIButton

-(UITextField *)getPriceTF;
-(void)setPrice:(NSString *)price;

@end

NS_ASSUME_NONNULL_END
