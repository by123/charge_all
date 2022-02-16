//
//  NewYearView.h
//  manage
//
//  Created by by.huang on 2019/1/18.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NewYearViewDelegate <NSObject>

-(void)onCloseNewYearView;

@end

@interface NewYearView : UIView

@property(weak, nonatomic)id<NewYearViewDelegate> delegate;

-(void)setText:(NSString *)text;
-(void)setImgUrl:(NSString *)imgUrl;

@end

NS_ASSUME_NONNULL_END
