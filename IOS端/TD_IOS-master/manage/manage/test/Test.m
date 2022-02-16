//
//  Test.m
//  manage
//
//  Created by by.huang on 2019/7/8.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "Test.h"
#import "STFileUtil.h"
#import "STConvertUtil.h"

#define TestTag @"test"

@implementation Test

-(instancetype)init{
    if(self == [super init]){
        [self blockTest];
        [self rubbish];
    }
    return self;
}

-(void)blockTest{
    //带参数block
    int (^add)(int,int) = ^(int a, int b){
        [STLog print:TestTag content:@"有参数block"];
        return a+b;
    };
    [STLog print:TestTag content:IntStr(add(1,2))];

    //无参block
    void (^none)(void) = ^{
        [STLog print:TestTag content:@"无参数block"];
    };
    none();

    //拆分写法
    void (^blockSplit)(void);
    blockSplit = ^{
        [STLog print:TestTag content:@"无参数block拆分写法"];
    };
    blockSplit();
    
    //block作为函数参数
    [self blockFuc:^(int result) {
        [STLog print:TestTag content:[NSString stringWithFormat:@"%d",result]];
    } mulitypleBlock:^(int result){
        [STLog print:TestTag content:[NSString stringWithFormat:@"%d",result]];
    } a:10 b:3];
    
}


- (void)blockFuc:(void (^)(int result))addBlock mulitypleBlock:(void (^)(int result))mulitypleBlock a:(int)a b:(int)b{
    addBlock(a+b);
    mulitypleBlock(a*b);
}




-(void)rubbish{
    NSString *jsonStr = [STFileUtil loadFile:@"rubbish.json"];
    NSMutableArray *datas =  [STConvertUtil jsonToDic:jsonStr];
    NSMutableArray *newDatas =  [[NSMutableArray alloc]init];
    for(int i = 0 ; i < datas.count; i++){
        NSDictionary *dic = [datas objectAtIndex:i];
        NSString *name = [dic objectForKey:@"name"];
        NSString *cname = [dic objectForKey:@"cname"];
        NSString *cid = [dic objectForKey:@"cid"];
        
        Boolean isAdd = YES;
        for(NSMutableDictionary *dic in newDatas){
            if([dic[@"name"] isEqualToString:name]){
                isAdd = NO;
                break;
            }
        }
        if(isAdd){
            NSMutableDictionary *newDic = [[NSMutableDictionary alloc]init];
            newDic[@"name"] = name;
            newDic[@"cname"] = cname;
            newDic[@"cid"] = cid;
            newDic[@"rid"] = IntStr(i);
            [newDatas addObject:newDic];
        }
    }
    
    NSSet *set = [NSSet setWithArray:newDatas];
    [STLog print:@"结果" content:[set allObjects].mj_JSONString];

}

@end
