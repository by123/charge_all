//
//  ScaleViewCell.h
//  manage
//
//  Created by by.huang on 2018/11/3.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ScaleModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol ScaleViewCellDelegate <NSObject>

-(void)OnClickScaleBtn:(NSInteger)position;
-(void)OnClickDeleteBtn:(NSInteger)position;

@end

@interface ScaleViewCell : UITableViewCell

@property(weak, nonatomic)id<ScaleViewCellDelegate> delegate;

-(void)updateData:(ScaleModel *)model positon:(NSInteger)position;
-(void)updateTime:(TitleContentModel *)model;
-(UITextField *)getPriceTF;
+(NSString *)identify;

@end

NS_ASSUME_NONNULL_END
