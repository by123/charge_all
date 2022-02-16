//
//  SkinManage.h
//  manage
//
//  Created by by.huang on 2019/4/24.
//  Copyright © 2019 by.huang. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface SkinManage : NSObject

SINGLETON_DECLARATION(SkinManage)

-(void)useSkin:(SKinType)type;
-(SKinType)getSkinType;

@end

