//
//  TitleContentModel.m
//  framework
//
//  Created by 黄成实 on 2018/5/16.
//  Copyright © 2018年 黄成实. All rights reserved.
//

#import "TitleContentModel.h"

@implementation TitleContentModel


+(TitleContentModel *)buildModel:(NSString *)title content:(NSString *)content{
    TitleContentModel *model = [[TitleContentModel alloc]init];
    model.title = title;
    model.content = content;
    return model;
}

+(TitleContentModel *)buildModel:(NSString *)title content:(NSString *)content extra:(NSString *)extra{
    TitleContentModel *model = [[TitleContentModel alloc]init];
    model.title = title;
    model.content = content;
    model.extra = extra;
    return model;
}

+(TitleContentModel *)buildModel:(NSString *)title content:(NSString *)content extra:(NSString *)extra extra2:(NSString *)extra2{
    TitleContentModel *model = [[TitleContentModel alloc]init];
    model.title = title;
    model.content = content;
    model.extra = extra;
    model.extra2 = extra2;
    return model;
}

+(TitleContentModel *)buildModel:(NSString *)title content:(NSString *)content extra:(NSString *)extra hidden:(Boolean)hidden{
    TitleContentModel *model = [[TitleContentModel alloc]init];
    model.title = title;
    model.content = content;
    model.extra = extra;
    model.hidden = hidden;
    return model;
}

+(TitleContentModel *)buildModel:(NSString *)title content:(NSString *)content isSwitch:(Boolean)isSwitch{
    TitleContentModel *model = [[TitleContentModel alloc]init];
    model.title = title;
    model.content = content;
    model.isSwitch = isSwitch;
    return model;
}
@end
