//
//  OrderSearchView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "OrderSearchView.h"
#import "TouchScrollView.h"
#import "OrderCell.h"
#import "OrderPaidCell.h"
#import "OrderCompeleCell.h"
#import "STListLayerView.h"
#import "MerchantSearchCell.h"
#import "STObserverManager.h"

@interface OrderSearchView()<UITableViewDelegate,UITableViewDataSource,TouchScrollViewDelegate,OrderCompeleDelegate,UITextFieldDelegate,STListLayerViewDelegate,STObserverProtocol>

@property(strong, nonatomic)OrderSearchViewModel *mViewModel;
@property(strong, nonatomic)UITextField *textfield;
@property(strong, nonatomic)TouchScrollView *scrollView;
@property(strong, nonatomic)UITableView *tableView;
@property(strong, nonatomic)UIImageView *noDataImageView;
@property(strong, nonatomic)UILabel *noDataLabel;
@property(strong, nonatomic)STListLayerView *listLayerView;
@property(strong, nonatomic)UILabel *selectLabel;
@property(strong, nonatomic)UITableView *merchantTableView;


@end

@implementation OrderSearchView{
    NSInteger current;
}

-(instancetype)initWithViewModel:(OrderSearchViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        current = SearchType_Merchant;
        [self initView];
    }
    return self;
}

-(void)initView{
    [self initContentUI];
    [self initNoDataUI];
    [self initMerchantList];
    [self initTopUI];
    [_mViewModel searchDevice:MSG_EMPTY refreshNew:YES];
    [[STObserverManager sharedSTObserverManager] registerSTObsever:NOTIFY_ORDER delegate:self];
}

-(void)dealloc{
    [[STObserverManager sharedSTObserverManager] removeSTObsever:NOTIFY_ORDER];
}

-(void)onReciveResult:(NSString *)key msg:(id)msg{
    [self refreshNew];
}

-(void)initContentUI{
    _scrollView = [[TouchScrollView alloc]initWithParentView:self delegate:self];
    _scrollView.frame = CGRectMake(0, STHeight(44), ScreenWidth, ScreenHeight - StatuBarHeight - STHeight(44));
    _scrollView.backgroundColor = cbg;
    [_scrollView enableHeader];
    [_scrollView enableFooter];
    [self addSubview:_scrollView];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - StatuBarHeight - STHeight(44))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = cbg;
    _tableView.scrollEnabled = NO;
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNew)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView.mj_header= header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(uploadMore)];
    _tableView.mj_footer = footer;
    
    [_tableView useDefaultProperty];
    
    
    [_scrollView addSubview:_tableView];
}

-(void)initNoDataUI{
    _noDataImageView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - STWidth(100))/2, STHeight(119), STWidth(100), STWidth(100))];
    _noDataImageView.image = [UIImage imageNamed:IMAGE_NO_DATA];
    _noDataImageView.hidden = YES;
    [self addSubview:_noDataImageView];
    
    NSString *noDataStr = @"暂无数据";
    _noDataLabel = [[UILabel alloc]initWithFont:STFont(16) text:noDataStr textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    _noDataLabel.frame = CGRectMake(0, STHeight(229), ScreenWidth, STHeight(22));
    _noDataLabel.hidden = YES;
    [self addSubview:_noDataLabel];
}

-(void)initMerchantList{
    _merchantTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, STHeight(44), ScreenWidth, ScreenHeight - StatuBarHeight - STHeight(44))];
    _merchantTableView.delegate = self;
    _merchantTableView.dataSource = self;
    _merchantTableView.backgroundColor = cwhite;
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshMerchantNew)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _merchantTableView.mj_header= header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(uploadMerchantMore)];
    _merchantTableView.mj_footer = footer;
    
    [_merchantTableView useDefaultProperty];
    [self addSubview:_merchantTableView];
    
}

-(void)initTopUI{
    
    NSMutableArray *items = [[NSMutableArray alloc]init];
    [items addObject:@"按商户"];
    [items addObject:@"按订单"];
    [items addObject:@"按设备"];
    
    _listLayerView = [[STListLayerView alloc]initWithDatas:items left:STWidth(15) top:STHeight(44)];
    _listLayerView.delegate = self;
    _listLayerView.hidden = YES;
    [self addSubview:_listLayerView];
    
    UIButton *selectBtn = [[UIButton alloc]init];
    selectBtn.frame = CGRectMake(0, 0, STWidth(90), STHeight(44));
    [selectBtn addTarget:self action:@selector(onSelectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:selectBtn];
    
    NSString *selectStr = [items objectAtIndex:current];
    _selectLabel = [[UILabel alloc]initWithFont:STFont(15) text:selectStr textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize nameSize = [selectStr sizeWithMaxWidth:ScreenWidth font:STFont(15) fontName:FONT_MIDDLE];
    [_selectLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(15)]];
    _selectLabel.frame = CGRectMake(STWidth(15), STHeight(11), nameSize.width, STHeight(21));
    [selectBtn addSubview:_selectLabel];
    
    UIImageView *selectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(63), (STHeight(44) - STWidth(12))/2, STWidth(12), STWidth(12))];
    selectImageView.image = [UIImage imageNamed:IMAGE_SEARCH_SELECT];
    selectImageView.contentMode = UIViewContentModeScaleAspectFill;
    [selectBtn addSubview:selectImageView];
    
    _textfield = [[UITextField alloc]initWithFont:STFont(14) textColor:c10 backgroundColor:cbg corner:4 borderWidth:0 borderColor:nil padding:STWidth(39)];
    _textfield.placeholder = @"输入商户名称";
    _textfield.delegate = self;
    _textfield.frame = CGRectMake(STWidth(90), STHeight(5), STWidth(225), STHeight(32));
    _textfield.returnKeyType = UIReturnKeySearch;
    _textfield.clearButtonMode=UITextFieldViewModeWhileEditing;
    [_textfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_textfield];
    
    UIImageView *searchImageView =[[UIImageView alloc]initWithFrame:CGRectMake(STWidth(104), (STHeight(44) - STWidth(14))/2, STWidth(14), STWidth(14))];
    searchImageView.image = [UIImage imageNamed:IMAGE_SEARCH_SMALL];
    searchImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:searchImageView];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFont:STFont(15) text:@"取消" textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil];
    cancelBtn.frame = CGRectMake(STWidth(314), STHeight(5), STWidth(61), STHeight(32));
    cancelBtn.titleLabel.font = [UIFont fontWithName:FONT_MIDDLE size:STFont(15)];
    [cancelBtn addTarget:self action:@selector(onCancelClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    
}


-(void)onCancelClicked{
    if(_mViewModel){
       [ _mViewModel closePage];
    }
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView == _merchantTableView){
        return [_mViewModel.merchantDatas count];
    }
    return [_mViewModel.datas count];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = cbg;
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(tableView == _merchantTableView){
        return 0;
    }
    return STHeight(15);
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _merchantTableView){
        return  STHeight(50);
    }
    OrderModel *model = [_mViewModel.datas objectAtIndex:indexPath.section];
    if(model.orderStateWeb == OrderType_Paid || model.orderStateWeb == OrderType_Completed){
//        return STHeight(313);
//    }else if(model.orderStateWeb == OrderType_Completed){
        return STHeight(357);
    }
    return STHeight(282);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _merchantTableView){
        MerchantSearchCell *cell = [self buildMerchantCell:tableView cellForRowAtIndexPath:indexPath];
        return cell;
    }else{
        OrderModel *model = [_mViewModel.datas objectAtIndex:indexPath.section];
        if(model.orderStateWeb == OrderType_Completed || model.orderStateWeb == OrderType_Paid){
            OrderCompeleCell  *cell = [self buildOrderCompleteCell:tableView cellForRowAtIndexPath:indexPath];
            return cell;
        }
        OrderCell *cell = [self buildOrderCell:tableView cellForRowAtIndexPath:indexPath];
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _merchantTableView){
        MerchantModel *model = [_mViewModel.merchantDatas objectAtIndex:indexPath.section];
        _textfield.text = model.mchName;
        _merchantTableView.hidden = YES;
        [_textfield resignFirstResponder];
        [_mViewModel requestOrderList:YES orderId:nil mchName:model.mchName deviceSn:nil];
    }else{
        OrderModel *model = [_mViewModel.datas objectAtIndex:indexPath.section];
        [_mViewModel goOrderDetailPage:model.orderId];
    }
}


-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    if([respondModel.requestUrl containsString:URL_QUERY_All_AGENT_AND_MERCHANT]){
        [self updateMerchantTableView];
        return;
    }
    [self updateUI];
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.datas)){
        [self updateHasDataUI];
    }
}

-(void)onRequestFail:(NSString *)msg{
    [_scrollView endRefreshNew];
    [_scrollView endUploadMore];
}

-(void)onRequestNoData{
    [self updateUI];
    [_scrollView noMoreData];
    if(IS_NS_COLLECTION_EMPTY(_mViewModel.datas)){
        [self updateNoDataUI];
    }else{
        [self updateHasDataUI];
    }
    
}

-(void)updateUI{
    CGFloat height = 0;
    for(OrderModel *model in _mViewModel.datas){
        if(model.orderStateWeb == OrderType_Paid || model.orderStateWeb == OrderType_Completed){
            height +=  STHeight(372);
        }else{
            height +=  STHeight(297);
        }
    }
    height += STHeight(15);
  
    _tableView.frame = CGRectMake(0, 0, ScreenWidth,height);
    [_scrollView setContentSize:CGSizeMake(ScreenWidth, height)];
    
    [_tableView reloadData];
    [_scrollView endRefreshNew];
    [_scrollView endUploadMore];
}



//下拉刷新
-(void)refreshNew{
    if(IS_NS_STRING_EMPTY(_textfield.text)){
        [_scrollView endRefreshNew];
        [_scrollView endUploadMore];
        return;
    }
    if(current == SearchType_Merchant){
        [_mViewModel requestOrderList:YES orderId:nil mchName:_textfield.text deviceSn:nil];
    }else if(current == SearchType_Order){
        [_mViewModel requestOrderList:YES orderId:_textfield.text mchName:nil deviceSn:nil];
    }else if(current == SearchType_Device){
        [_mViewModel requestOrderList:YES orderId:nil mchName:nil deviceSn:_textfield.text];
    }
}

//上拉加载更多
-(void)uploadMore{
    if(IS_NS_STRING_EMPTY(_textfield.text)){
        [_scrollView endRefreshNew];
        [_scrollView endUploadMore];
        return;
    }
    if(current == SearchType_Merchant){
        [_mViewModel requestOrderList:NO orderId:nil mchName:_textfield.text deviceSn:nil];
    }else if(current == SearchType_Order){
        [_mViewModel requestOrderList:NO orderId:_textfield.text mchName:nil deviceSn:nil];
    }else if(current == SearchType_Device){
        [_mViewModel requestOrderList:NO orderId:nil mchName:nil deviceSn:_textfield.text];
    }
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



//创建不同类型的cell
-(OrderCell *)buildOrderCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderCell identify]];
    if(!cell){
        cell = [[OrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[OrderCell identify]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.datas)){
        [cell updateData:[_mViewModel.datas objectAtIndex:indexPath.section]];
    }
    return cell;
}

-(OrderPaidCell *)buildOrderPaidCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderPaidCell *cell = [tableView dequeueReusableCellWithIdentifier:[OrderPaidCell identify]];
    if(!cell){
        cell = [[OrderPaidCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[OrderPaidCell identify]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.datas)){
        [cell updateData:[_mViewModel.datas objectAtIndex:indexPath.section]];
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
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.datas)){
        [cell updateData:[_mViewModel.datas objectAtIndex:indexPath.section] position:indexPath.section];
    }
    return cell;
}

-(MerchantSearchCell *)buildMerchantCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MerchantSearchCell  *cell = [tableView dequeueReusableCellWithIdentifier:[MerchantSearchCell identify]];
    if(!cell){
        cell = [[MerchantSearchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MerchantSearchCell identify]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.merchantDatas)){
        MerchantModel *model = [_mViewModel.merchantDatas objectAtIndex:indexPath.section];
        [cell updateData:model.mchName];
    }
    return cell;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(_mViewModel){
        [textField resignFirstResponder];
        if(_merchantTableView.hidden){
            [self refreshNew];
        }else{
            [_mViewModel searchDevice:textField.text refreshNew:YES];
        }
    }
    return YES;
}


-(void)onScrollViewDidScroll:(UIScrollView *)scrollView{}



//点击退款
-(void)OnClickRefundBtn:(NSInteger)position{    
    OrderModel *model = [_mViewModel.datas objectAtIndex:position];
    if(_mViewModel){
       [ _mViewModel goRefundPage:model];
    }
}


//点击切换搜索方式
-(void)onSelectBtnClick{
    if(_listLayerView.hidden){
        _listLayerView.hidden = NO;
    }else{
        _listLayerView.hidden = YES;
    }
}
                           
//选择搜索方式
-(void)onListLayerItemSelected:(NSString *)item position:(NSInteger)position{
    if(current == position){
        return;
    }
    _selectLabel.text = item;
    current = position;
    _textfield.text = MSG_EMPTY;
    [_mViewModel.datas removeAllObjects];
    [_tableView reloadData];
    if(current == SearchType_Merchant){
        _textfield.placeholder = @"输入商户名称";
        [_mViewModel searchDevice:nil refreshNew:YES];
        _merchantTableView.hidden = NO;
    }else if(current == SearchType_Order){
        _textfield.placeholder = @"输入订单号码";
        _merchantTableView.hidden = YES;
    }else if(current == SearchType_Device){
        _textfield.placeholder = @"输入设备编号";
        _merchantTableView.hidden = YES;
    }
}

- (void)textFieldDidChange:(UITextField *)textField{
//    NSString *text = textField.text;
    if(current == SearchType_Merchant){
        _merchantTableView.hidden = NO;
//        [_mViewModel searchDevice:text];
    }else{
        _merchantTableView.hidden = YES;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _listLayerView.hidden = YES;
}

-(void)refreshMerchantNew{
    [_mViewModel searchDevice:_textfield.text refreshNew:YES];
}

-(void)uploadMerchantMore{
    [_mViewModel searchDevice:_textfield.text refreshNew:NO];
}

-(void)updateMerchantTableView{
    [_merchantTableView.mj_header endRefreshing];
    [_merchantTableView.mj_footer endRefreshing];
    [_merchantTableView setContentSize:CGSizeMake(ScreenWidth, STHeight(50) * [_mViewModel.merchantDatas count] + STHeight(15))];
    [_merchantTableView reloadData];
}

-(void)onRequestNoData:(Boolean)hasDatas{
    [self updateMerchantTableView];
    if(hasDatas){
        [self updateNoDataUI];
    }else{
        [_merchantTableView.mj_footer endRefreshingWithNoMoreData];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_textfield resignFirstResponder];
}
@end

