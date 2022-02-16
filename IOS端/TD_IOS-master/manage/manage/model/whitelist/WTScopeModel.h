//
//  WTScopeModel.h
//  manage
//
//  Created by by.huang on 2019/3/17.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WTScopeModel : NSObject

//只查下级使用范围
@property(copy, nonatomic)NSString *mchName;
@property(copy, nonatomic)NSString *mchId;
@property(copy, nonatomic)NSString *parentAgencyId;
@property(assign, nonatomic)int mchType;
@property(assign, nonatomic)int level;
//层级是否展开
@property(assign, nonatomic)Boolean isExpand;
//该层级数据是否被查询过
@property(assign, nonatomic)Boolean isQuery;
//数据是否隐藏
@property(assign, nonatomic)Boolean isHidden;
//是否显示分割线
@property(assign, nonatomic)Boolean showLine;


//查询所有使用范围
@property(assign, nonatomic)Boolean has;
@property(assign, nonatomic)Boolean hasChild;
@property(strong, nonatomic)id child;

@property(assign, nonatomic)WhiteListSelectStatu selected;

@end

NS_ASSUME_NONNULL_END
