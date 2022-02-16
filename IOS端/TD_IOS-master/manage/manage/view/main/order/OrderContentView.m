//
//  OrderContentView.m
//  manage
//
//  Created by by.huang on 2018/11/19.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "OrderContentView.h"
#import "TouchScrollView.h"
#import "OrderContentViewModel.h"
#import "OrderCell.h"
#import "OrderPaidCell.h"
#import "OrderCompeleCell.h"
#import "STNetUtil.h"

@interface OrderContentView()<UITableViewDelegate,UITableViewDataSource,OrderContentViewDelegate,OrderCompeleDelegate>

@property(assign, nonatomic)OrderType mType;
@property(strong, nonatomic)TouchScrollView *scrollView;
@property(strong, nonatomic)UITableView *tableView;
@property(strong, nonatomic)UIImageView *noDataImageView;
@property(strong, nonatomic)UILabel *noDataLabel;
@property(strong, nonatomic)OrderViewModel *orderViewModel;
@property(strong, nonatomic)OrderContentViewModel *orderContentViewModel;


@end

@implementation OrderContentView{
    CGFloat homeHeight;
    CGFloat bodyHeight;
    NSString *configTips;
}

-(instancetype)initWithType:(OrderType)type viewModel:(nonnull OrderViewModel *)orderViewModel{
    if(self == [super init]){
        _orderViewModel = orderViewModel;
        _orderContentViewModel = [[OrderContentViewModel alloc]init];
        _orderContentViewModel.startDate = orderViewModel.startDate;
        _orderContentViewModel.endDate = orderViewModel.endDate;
        _mType = type;
        _orderContentViewModel.delegate = self;
        if (@available(iOS 11.0, *)) {
            homeHeight = HomeIndicatorHeight;
        } else {
            homeHeight = 0;
        }
        bodyHeight = ScreenHeight - StatuBarHeight - STHeight(50) - homeHeight;
        [self initView];
    }
    return self;
}



-(void)initView{
    
    self.backgroundColor = cbg;
    _scrollView = [[TouchScrollView alloc]initWithParentView:self delegate:nil];
    if(_mType == OrderType_Completed || _mType == OrderType_Paid || _mType == OrderType_All){
        _scrollView.frame = CGRectMake(0, STHeight(20), ScreenWidth, bodyHeight - STHeight(246) - STHeight(20));
        configTips = [STUserDefaults getKeyValue:CONFIG_ORDER_TIPS];
        if(!IS_NS_STRING_EMPTY(configTips)){
            UILabel *tipsLabel = [[UILabel alloc]initWithFont:STFont(12) text:configTips textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
            tipsLabel.frame = CGRectMake(0, 0, ScreenWidth, STHeight(20));
            tipsLabel.backgroundColor = cbg;
            [self addSubview:tipsLabel];
        }
    }else{
        _scrollView.frame = CGRectMake(0, 0, ScreenWidth, bodyHeight - STHeight(246));
    }
//    _scrollView.backgroundColor = cbg;
    _scrollView.scrollEnabled = NO;
    [self addSubview:_scrollView];
    

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, bodyHeight - STHeight(246))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = cbg;
    _tableView.scrollEnabled = NO;
    [_tableView useDefaultProperty];
    
    
    [_scrollView addSubview:_tableView];
    
    
    _noDataImageView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - STWidth(100))/2, STHeight(70), STWidth(100), STWidth(100))];
    _noDataImageView.image = [UIImage imageNamed:IMAGE_NO_ORDER];
    _noDataImageView.hidden = YES;
    [self addSubview:_noDataImageView];
    
    NSString *noDataStr = MSG_NO_ORDER;
    _noDataLabel = [[UILabel alloc]initWithFont:STFont(16) text:noDataStr textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    _noDataLabel.frame = CGRectMake(0, STHeight(180), ScreenWidth, STHeight(22));
    _noDataLabel.hidden = YES;
    [self addSubview:_noDataLabel];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
  return [_orderContentViewModel.datas count];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = cbg;
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return STHeight(15);
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_mType == OrderType_All){
        OrderModel *model = [_orderContentViewModel.datas objectAtIndex:indexPath.section];
        if(model.orderStateWeb == OrderType_Paid || model.orderStateWeb == OrderType_Completed){
//            return STHeight(313);
//        }else if(model.orderStateWeb == OrderType_Completed){
            return STHeight(357);
        }
    }else if(_mType == OrderType_Paid || _mType == OrderType_Completed){
//        return STHeight(313);
//    }else if(_mType == OrderType_Completed){
        return STHeight(357);
    }
    return STHeight(282);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_mType == OrderType_All){
        OrderModel *model = [_orderContentViewModel.datas objectAtIndex:indexPath.section];
        if(model.orderStateWeb == OrderType_Completed || model.orderStateWeb == OrderType_Paid){
            OrderCompeleCell  *cell = [self buildOrderCompleteCell:tableView cellForRowAtIndexPath:indexPath];
//            return cell;
//        }else if(model.orderStateWeb == OrderType_Paid){
//            OrderPaidCell *cell = [self buildOrderPaidCell:tableView cellForRowAtIndexPath:indexPath];
            return cell;
        }
    }
    else if(_mType == OrderType_Completed || _mType == OrderType_Paid){
        OrderCompeleCell  *cell = [self buildOrderCompleteCell:tableView cellForRowAtIndexPath:indexPath];
        return cell;
//    }else if(_mType == OrderType_Paid){
//        OrderPaidCell *cell = [self buildOrderPaidCell:tableView cellForRowAtIndexPath:indexPath];
//        return cell;
    }
    OrderCell *cell = [self buildOrderCell:tableView cellForRowAtIndexPath:indexPath];
    return cell;
    


}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_orderViewModel.delegate){
        OrderModel *model  = [_orderContentViewModel.datas objectAtIndex:indexPath.section];
        [_orderViewModel goOrderDetailPage:model.orderId];
    }
}


-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    _mType = [data intValue];
    [self updateUI];
    if(!IS_NS_COLLECTION_EMPTY(_orderContentViewModel.datas)){
        [self updateHasDataUI];
    }
}

-(void)onRequestFail:(NSString *)msg{
    [_orderViewModel.delegate onRefreshEnd];
}

-(void)onRequestNoData:(int)type{
    _mType = type;
    [self updateUI];
    [_orderViewModel.delegate noMoreData];
    if(IS_NS_COLLECTION_EMPTY(_orderContentViewModel.datas)){
        [self updateNoDataUI];
    }else{
        [self updateHasDataUI];
    }
    
}

-(void)onRequestTotalCount:(NSString *)count sum:(NSString *)sum{
    if(_orderViewModel && _orderViewModel.delegate){
        [_orderViewModel.delegate onUpdateTotalStr:count profit:sum];
    }
}


-(void)updateUI{
    CGFloat height = 0;
    if(_mType == OrderType_All){
        for(OrderModel *model in _orderContentViewModel.datas){
            if(model.orderStateWeb == OrderType_Paid || model.orderStateWeb == OrderType_Completed){
//                height +=  STHeight(328);
//            }else if(model.orderStateWeb == OrderType_Completed){
                height +=  STHeight(372);
            }else{
                height +=  STHeight(297);
            }
        }
        height += STHeight(15);
    }else if(_mType == OrderType_Paid || _mType == OrderType_Completed){
//        height = STHeight(328) * [_orderContentViewModel.datas count] + STHeight(15);
//    }else if(_mType == OrderType_Completed){
        height = STHeight(372) * [_orderContentViewModel.datas count] + STHeight(15);
    }else{
        height = STHeight(297) * [_orderContentViewModel.datas count] + STHeight(15);
    }
    _tableView.frame = CGRectMake(0, 0, ScreenWidth,height);
    
    if(!IS_NS_STRING_EMPTY(configTips) && (_mType == OrderType_Completed || _mType == OrderType_Paid || _mType == OrderType_All)){
        _scrollView.frame = CGRectMake(0, STHeight(20), ScreenWidth,height);
    }
    else{
        _scrollView.frame = CGRectMake(0, 0, ScreenWidth,height);
    }

    [_tableView reloadData];
   
    if(_orderViewModel.delegate){
        [_orderViewModel.delegate onRefreshEnd];
        [_orderViewModel.delegate onUpdateUI:_mType datas:_orderContentViewModel.datas];
    }
}




//下拉刷新
-(void)refreshNew{
    [_orderContentViewModel requestOrderList:_mType refreshNew:YES];
}

//上拉加载更多
-(void)uploadMore{
    [_orderContentViewModel requestOrderList:_mType refreshNew:NO];
}

-(void)updateNoDataUI{
    _scrollView.hidden = YES;
    _noDataImageView.hidden = NO;
    _noDataLabel.hidden = NO;
}

-(void)updateHasDataUI{
    _scrollView.hidden = NO;
    _noDataImageView.hidden = YES;
    _noDataLabel.hidden = YES;
}

-(void)updateView{
    [self updateCondition:_orderViewModel.startDate end:_orderViewModel.endDate model:_orderViewModel.model];
    [self refreshNew];
}

-(void)updateCondition:(NSString *)startDate end:(NSString *)endDate model:(MerchantModel *)model{
    _orderContentViewModel.startDate = startDate;
    _orderContentViewModel.endDate = endDate;
    _orderContentViewModel.model  = model;
}


//创建不同类型的cell
-(OrderCell *)buildOrderCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderCell identify]];
    if(!cell){
        cell = [[OrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[OrderCell identify]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(!IS_NS_COLLECTION_EMPTY(_orderContentViewModel.datas)){
        [cell updateData:[_orderContentViewModel.datas objectAtIndex:indexPath.section]];
    }
    return cell;
}

-(OrderPaidCell *)buildOrderPaidCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderPaidCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderPaidCell identify]];
    if(!cell){
        cell = [[OrderPaidCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[OrderPaidCell identify]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(!IS_NS_COLLECTION_EMPTY(_orderContentViewModel.datas)){
        [cell updateData:[_orderContentViewModel.datas objectAtIndex:indexPath.section]];
    }
    return cell;
}

-(OrderCompeleCell *)buildOrderCompleteCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderCompeleCell  *cell = [tableView dequeueReusableCellWithIdentifier:[OrderCompeleCell identify]];
    if(!cell){
        cell = [[OrderCompeleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[OrderCompeleCell identify]];
    }
    cell.delegate = self;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(!IS_NS_COLLECTION_EMPTY(_orderContentViewModel.datas)){
        [cell updateData:[_orderContentViewModel.datas objectAtIndex:indexPath.section] position:indexPath.section];
    }
    return cell;
}


//点击退款
-(void)OnClickRefundBtn:(NSInteger)position{
    OrderModel *model = [_orderContentViewModel.datas objectAtIndex:position];
    [_orderViewModel goRefundPage:model];
}




@end
