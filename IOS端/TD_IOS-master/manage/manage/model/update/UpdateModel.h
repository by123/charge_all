//
//  UpdateModel.h
//  manage
//
//  Created by by.huang on 2018/12/20.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UpdateModel : NSObject

@property(copy, nonatomic)NSString *downloadUrl;
@property(copy, nonatomic)NSString *version;
@property(assign, nonatomic)int versionNum;
@property(copy, nonatomic)NSString *versionSize;
@property(assign, nonatomic)int recommend;
@property(copy, nonatomic)NSString *versionDesc;

@end

NS_ASSUME_NONNULL_END
