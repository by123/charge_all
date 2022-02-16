//
//  OrderDetailModel.m
//  manage
//
//  Created by by.huang on 2018/11/19.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "OrderDetailModel.h"

@implementation OrderDetailModel


+(NSString *)getOrderStatu:(int)orderStatu{
    NSString *result = MSG_EMPTY;
    switch (orderStatu) {
        case OrderType_WaitPay:
            result = @"待支付";
            break;
        case OrderType_Paid:
            result = @"已支付";
            break;
        case OrderType_Completed:
            result = @"已完成";
            break;
        case OrderType_Cancel:
            result = @"已取消";
            break;
        case OrderType_Refunding:
            result = @"退款中";
            break;
        case OrderType_Refunded:
            result = @"已退款";
            break;
        default:
            break;
    }
    
    return result;
}


+(NSString *)getRefundStatu:(int)refundStatu{
    NSString *result =MSG_EMPTY;
    switch (refundStatu ) {
        case 0:
            result = @"未发起退款";
            break;
        case 1:
            result = @"退款中";
            break;
        case 2:
            result = @"退款成功";
            break;
        case 3:
            result = @"退款失败";
            break;
            
        default:
            break;
    }
    return  result;
}




@end
