//
//  STConvertUtil.m
//  framework
//
//  Created by 黄成实 on 2018/4/26.
//  Copyright © 2018年 黄成实. All rights reserved.
//

#import "STConvertUtil.h"

@implementation STConvertUtil


+(NSString *)dataToString:(NSData *)data{
  return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+(NSData *)stringToData:(NSString *)str{
    return [str dataUsingEncoding:NSUTF8StringEncoding];
}

+(NSString *)base64Encode:(NSString *)str{
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSData *base64Data = [data base64EncodedDataWithOptions:0];
    return[[NSString alloc]initWithData:base64Data encoding:NSUTF8StringEncoding];
}

+(NSString *)base64Decode:(NSString *)str{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}


+ (id)jsonToDic:(NSString *)jsonStr {
    if (jsonStr == nil) {
        return nil;
    }
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if(error) {
        [STLog print:@"json解析失败"];
        return nil;
    }
    return result;
}

+ (NSString*)dicToJson:(id)dic{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return result;
}

+(NSString *)arrayToJson:(NSMutableArray *)array{
    if(IS_NS_COLLECTION_EMPTY(array)){
        return MSG_EMPTY;
    }
    NSString *result = @"[";
    for(int i = 0 ; i < array.count ; i++){
        id obj = [array objectAtIndex:i];
        result = [result stringByAppendingString:[obj mj_JSONString]];
        if(i != array.count - 1){
            result = [result stringByAppendingString:@","];
        }
    }
    result = [result stringByAppendingString:@"]"];
    return result;
}


+(UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize{
    CGFloat scale = [[UIScreen mainScreen]scale];
    
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
