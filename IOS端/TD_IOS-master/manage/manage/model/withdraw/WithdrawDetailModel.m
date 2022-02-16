//
//  WithdrawDetailModel.m
//  manage
//
//  Created by by.huang on 2018/12/6.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "WithdrawDetailModel.h"

@implementation WithdrawDetailModel

//-3，审核不通过, -2:挂起,-1:待审核, 0:审核通过，1:tx中, 2:tx成功, 3:tx失败, 4需要人工确认
+(NSString *)getStatuStr:(int)withdrawState{
    NSString *result = @"申请成功";
    switch (withdrawState) {
        case -3:
            result = MSG_TXING ;;
            break;
        case 3:
            result = MSG_TX_FAIL;
            break;
        case 2:
            result = MSG_TX_FINISH;
            break;
        case -2:
        case -1:
        case 0:
        case 1:
        case 4:
            result = MSG_TXING;
            break;
        default:
            break;
    }
    
    return result;
}
@end
