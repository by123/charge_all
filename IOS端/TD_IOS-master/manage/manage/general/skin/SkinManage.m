//
//  SkinManage.m
//  manage
//
//  Created by by.huang on 2019/4/24.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "SkinManage.h"

@interface SkinManage()

@property(assign, nonatomic)SKinType type;

@end

@implementation SkinManage

SINGLETON_IMPLEMENTION(SkinManage)

-(void)useSkin:(SKinType)type{
    self.type = type;
}

-(SKinType)getSkinType{
    return self.type;
}

@end
