//
//  UserModel.m
//  manage
//
//  Created by by.huang on 2018/10/26.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel





-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self == [super init]){
        self.token = [aDecoder decodeObjectForKey:@"token"];

        self.mchId = [aDecoder decodeObjectForKey:@"mchId"];
        self.mchType = (int)[aDecoder decodeIntegerForKey:@"mchType"];
        self.userId = [aDecoder decodeObjectForKey:@"userId"];
        self.roleType = (int)[aDecoder decodeIntegerForKey:@"roleType"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.creid = [aDecoder decodeObjectForKey:@"creid"];
        self.cretype = (int)[aDecoder decodeIntegerForKey:@"cretype"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        
        self.level = (int)[aDecoder decodeIntegerForKey:@"level"];
        self.mchName = [aDecoder decodeObjectForKey:@"mchName"];
        self.contactUser = [aDecoder decodeObjectForKey:@"contactUser"];
        self.contactPhone = [aDecoder decodeObjectForKey:@"contactPhone"];
        self.province = [aDecoder decodeObjectForKey:@"province"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.area = [aDecoder decodeObjectForKey:@"area"];
        self.detailAddr = [aDecoder decodeObjectForKey:@"detailAddr"];
        self.createTime = (long)[aDecoder decodeIntegerForKey:@"createTime"];
        self.settementPeriod = (int)[aDecoder decodeIntegerForKey:@"settementPeriod"];
        self.totalPercent = [aDecoder decodeDoubleForKey:@"totalPercent"];
        self.salesId = [aDecoder decodeObjectForKey:@"salesId"];
        self.superUser = [aDecoder decodeObjectForKey:@"superUser"];
        self.industry = [aDecoder decodeObjectForKey:@"industry"];
        self.supportSevice = (int)[aDecoder decodeIntegerForKey:@"supportSevice"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:self.token forKey:@"token"];
    
    [aCoder encodeObject:self.mchId  forKey:@"mchId"];
    [aCoder encodeInteger:self.mchType forKey:@"mchType"];
    [aCoder encodeObject:self.userId  forKey:@"userId"];
    [aCoder encodeInteger:self.roleType forKey:@"roleType"];
    [aCoder encodeObject:self.name  forKey:@"name"];
    [aCoder encodeObject:self.creid  forKey:@"creid"];
    [aCoder encodeInteger:self.cretype forKey:@"cretype"];
    [aCoder encodeObject:self.mobile  forKey:@"mobile"];
    
    [aCoder encodeInteger:self.level forKey:@"level"];
    [aCoder encodeObject:self.mchName forKey:@"mchName"];
    [aCoder encodeObject:self.contactUser forKey:@"contactUser"];
    [aCoder encodeObject:self.contactPhone forKey:@"contactPhone"];
    [aCoder encodeObject:self.province forKey:@"province"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.area forKey:@"area"];
    [aCoder encodeObject:self.detailAddr forKey:@"detailAddr"];
    [aCoder encodeInteger:self.createTime forKey:@"createTime"];
    [aCoder encodeInt:self.settementPeriod forKey:@"settementPeriod"];
    [aCoder encodeDouble:self.totalPercent forKey:@"totalPercent"];
    [aCoder encodeObject:self.salesId  forKey:@"salesId"];
    [aCoder encodeObject:self.superUser  forKey:@"superUser"];
    [aCoder encodeObject:self.industry forKey:@"industry"];
    [aCoder encodeInteger:self.supportSevice forKey:@"supportSevice"];


}

+(NSString *)getMechantName:(int)mchType level:(int)level{
    if(mchType == 0){
        NSArray *tempArray = @[ [APP_NAME stringByAppendingString:@"公司"],@"省代",@"市代",@"区/县代",@"连锁门店"];
        return tempArray[level];
    }
    if(mchType == 1){
        NSArray *tempArray = @[@"商户",@"连锁门店分店",@"出租车"];
        return tempArray[level];
    }
    if(mchType == 2){
        return @"平台";
    }
    return MSG_EMPTY;
    
}

+(NSString *)getMechantType:(int)mchType{
    if(mchType == 0){
        return @"代理商";
    }
    if(mchType == 1){
        return @"商户";
    }
    if(mchType == 2){
        return @"平台";
    }
    return MSG_EMPTY;
}
@end
