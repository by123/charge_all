//
//  RefundViewModel.m
//  manage
//
//  Created by by.huang on 2018/11/19.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "RefundViewModel.h"
#import "STNetUtil.h"

@implementation RefundViewModel


-(void)requestRefund:(NSString *)reason refundMoney:(NSString *)refundMoney{
    if(IS_NS_STRING_EMPTY(reason)){
        [LCProgressHUD showMessage:@"请输入退款原因"];
        return;
    }
    if(IS_NS_STRING_EMPTY(refundMoney)){
        [LCProgressHUD showMessage:@"请输入退款金额"];
        return;
    }
    if(!_delegate)  return;
    [_delegate onRequestBegin];
    WS(weakSelf)
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"orderId"] = _model.orderId;
    dic[@"reason"] = reason;
    dic[@"refundMoney"] = refundMoney;
    [STNetUtil post:URL_REFUND content:dic.mj_JSONString success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            [weakSelf.delegate onRequestSuccess:respondModel data:respondModel.data];
        }else{
            [weakSelf.delegate onRequestFail:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf.delegate onRequestFail:[NSString stringWithFormat:MSG_ERROR,errorCode]];
    }];
}
    
    


@end
