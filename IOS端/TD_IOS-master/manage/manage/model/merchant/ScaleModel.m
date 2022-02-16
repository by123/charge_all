//
//  ScaleModel.m
//  manage
//
//  Created by by.huang on 2018/11/3.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "ScaleModel.h"

@implementation ScaleModel

+(ScaleModel *)build:(NSString *)title timeModel:(TitleContentModel *)timeModel price:(NSString *)price isDelete:(Boolean)isDelete{
    ScaleModel *model = [[ScaleModel alloc]init];
    model.title = title;
    model.timeModel = timeModel;
    model.price = price;
    model.isDelete = isDelete;
    return model;
}

+(NSMutableArray *)getTimesData{
    NSMutableArray *datas = [[NSMutableArray alloc]init];
    //关机充电开机档位
//    [datas addObject:[TitleContentModel buildModel:@"0" content:@"5" extra:@"分钟" extra2:@"5"]];
    //预留
//    [datas addObject:[TitleContentModel buildModel:@"1" content:@"30" extra:@"分钟" extra2:@"30"]];
    //部分商户起步档
    [datas addObject:[TitleContentModel buildModel:@"2" content:@"1" extra:@"小时"  extra2:@"60"]];
    [datas addObject:[TitleContentModel buildModel:@"3" content:@"2" extra:@"小时"  extra2:@"120"]];
    //部分商户起步档，餐饮类商户封顶档
    [datas addObject:[TitleContentModel buildModel:@"4" content:@"3" extra:@"小时" extra2:@"180"]];
    //餐饮类商户封顶档
    [datas addObject:[TitleContentModel buildModel:@"5" content:@"4" extra:@"小时" extra2:@"240"]];
    //棋牌，茶馆类商户封顶档
    [datas addObject:[TitleContentModel buildModel:@"6" content:@"6" extra:@"小时" extra2:@"360"]];
    //部分足浴、会所类商户封顶档
    [datas addObject:[TitleContentModel buildModel:@"7" content:@"8" extra:@"小时" extra2:@"480"]];
    //网吧网咖，酒吧类商户封顶档
    [datas addObject:[TitleContentModel buildModel:@"8" content:@"12" extra:@"小时" extra2:@"720"]];
    //酒店、部分会所封顶档
    [datas addObject:[TitleContentModel buildModel:@"9" content:@"24" extra:@"小时" extra2:@"1440"]];
    
    return datas;
}
@end
