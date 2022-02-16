//
//  ScaleModel.h
//  manage
//
//  Created by by.huang on 2018/11/3.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TitleContentModel.h"
#import "ScaleItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ScaleModel : NSObject

@property(copy, nonatomic)NSString *title;
@property(strong, nonatomic)TitleContentModel *timeModel;
@property(strong, nonatomic)NSString *price;
@property(assign, nonatomic)Boolean isDelete;

+(ScaleModel *)build:(NSString *)title timeModel:(TitleContentModel *)timeModel price:(NSString *)price isDelete:(Boolean)isDelete;


+(NSMutableArray *)getTimesData;

@end

NS_ASSUME_NONNULL_END
