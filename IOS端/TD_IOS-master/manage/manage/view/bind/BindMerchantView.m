//
//  BindMerchantView.m
//  manage
//
//  Created by by.huang on 2018/10/29.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "BindMerchantView.h"
#import "BindMerchantCell.h"
#import "STAlertUtil.h"

@interface BindMerchantView()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(strong, nonatomic)BindMerchantViewModel *mViewModel;
@property(strong, nonatomic)UITableView *tableView;
@property(strong, nonatomic)UIButton *confirmBtn;
@property(strong, nonatomic)UITextField *nameTF;
@property(strong, nonatomic)UIImageView *noDataImageView;
@property(strong, nonatomic)UILabel *noDataLabel;
@end

@implementation BindMerchantView{
    NSUInteger selectRow;
}


-(instancetype)initWithViewModel:(BindMerchantViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        selectRow = -1;
        [self initView];
    }
    return self;
}


-(void)initView{
    
    CGFloat height = 0 ;
    if(_mViewModel.from == MerchantFromType_UNBIND){
        UILabel *tipsLabel = [[UILabel alloc]initWithFont:STFont(12) text:MSG_UNBIND_MERCHANT_TIPS textAlignment:NSTextAlignmentLeft textColor:c13 backgroundColor:nil multiLine:YES];
        CGSize tipsSize = [tipsLabel.text sizeWithMaxWidth:STWidth(345) font:STFont(12)];
        tipsLabel.frame = CGRectMake(STWidth(15), STHeight(10), STWidth(345), tipsSize.height);
        [self addSubview:tipsLabel];
        height = STHeight(50);
    }
    
    _nameTF = [[UITextField alloc]initWithFont:STFont(15) textColor:c10 backgroundColor:cbg corner:4 borderWidth:0 borderColor:nil padding:STWidth(15)];
    _nameTF.textAlignment = NSTextAlignmentLeft;
    _nameTF.placeholder = @"请输入商户名称";
    _nameTF.delegate = self;
    _nameTF.frame = CGRectMake(STWidth(15), STHeight(10) + height, STWidth(345),STHeight(40));
    [_nameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _nameTF.returnKeyType = UIReturnKeySearch;
    _nameTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self addSubview:_nameTF];
    
    NSString *homeStr = @"请选择需绑定的商户";
    if(_mViewModel.from == MerchantFromType_ACTIVE){
        homeStr = MSG_SELECT_ACTIVE_MERCHANT;
    }else if(_mViewModel.from == MerchantFromType_UNBIND){
        homeStr = @"请选择需解绑设备的商户";
    }
    UILabel *homeLabel = [[UILabel alloc]initWithFont:STFont(20) text:homeStr textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize homeSize = [homeStr sizeWithMaxWidth:ScreenWidth font:STFont(30) fontName:FONT_MIDDLE];
    [homeLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(20)]];
    homeLabel.frame = CGRectMake(STWidth(15), STHeight(60) + height, homeSize.width, STHeight(28));
    [self addSubview:homeLabel];
    
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, STHeight(88) + height, ScreenWidth, ContentHeight - STHeight(88) - STHeight(50) - height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNew)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView.mj_header= header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(uploadMore)];
    _tableView.mj_footer = footer;
    
    [self addSubview:_tableView];
    [_tableView useDefaultProperty];

    
    _noDataImageView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - STWidth(100))/2, STHeight(200)+height, STWidth(100), STWidth(100))];
    _noDataImageView.image = [UIImage imageNamed:IMAGE_NO_DATA];
    _noDataImageView.hidden = YES;
    [self addSubview:_noDataImageView];
    
    NSString *noDataStr = @"暂无数据";
    _noDataLabel = [[UILabel alloc]initWithFont:STFont(16) text:noDataStr textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    _noDataLabel.frame = CGRectMake(0, STHeight(310)+height, ScreenWidth, STHeight(22));
    _noDataLabel.hidden = YES;
    [self addSubview:_noDataLabel];
    
    
    _confirmBtn = [[UIButton alloc]initWithFont:STFont(18) text:@"确定" textColor:c_btn_txt_normal backgroundColor:c05 corner:4 borderWidth:0 borderColor:nil];
    _confirmBtn.frame = CGRectMake(0, ContentHeight - STHeight(50), ScreenWidth, STHeight(50));
    [_confirmBtn addTarget:self action:@selector(onConfirmClicked) forControlEvents:UIControlEventTouchUpInside];
    _confirmBtn.enabled = NO;
    [self addSubview:_confirmBtn];
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_mViewModel.merchantDatas count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return STHeight(60);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BindMerchantCell *cell = [tableView dequeueReusableCellWithIdentifier:[BindMerchantCell identify]];
    if(!cell){
        cell = [[BindMerchantCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[BindMerchantCell identify]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.merchantDatas)){
        [cell updateData:[_mViewModel.merchantDatas objectAtIndex:indexPath.row]];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_nameTF resignFirstResponder];
    NSInteger row = indexPath.row;
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.merchantDatas)){
        if(selectRow == row){
            return;
        }
        ((MerchantModel *)[_mViewModel.merchantDatas objectAtIndex:row]).isSelected = YES;
        if(selectRow != -1){
            ((MerchantModel *)[_mViewModel.merchantDatas objectAtIndex:selectRow]).isSelected = NO;
        }
        selectRow = row;
        [_tableView reloadData];
    }
    
    _confirmBtn.enabled = YES;
    [_confirmBtn setTitleColor:c_btn_txt_highlight forState:UIControlStateNormal];
    [_confirmBtn setBackgroundColor:c01 forState:UIControlStateNormal];
    
}

-(void)updateView{
    [self updateHasDataUI];
    [self updateTableView];
}

-(void)onRequestFail:(NSString *)msg{
    [self updateTableView];
}

-(void)onRequestNoData:(Boolean)hasDatas{
    [self updateTableView];
    if(hasDatas){
        [self updateNoDataUI];
    }else{
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

-(void)updateTableView{
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
    [_tableView setContentSize:CGSizeMake(ScreenWidth, STHeight(159) * [_mViewModel.merchantDatas count] + STHeight(15))];
    [_tableView reloadData];
    
}

-(void)updateNoDataUI{
    _tableView.hidden = YES;
    _noDataImageView.hidden = NO;
    _noDataLabel.hidden = NO;
}

-(void)updateHasDataUI{
    _tableView.hidden = NO;
    _noDataImageView.hidden = YES;
    _noDataLabel.hidden = YES;
}

- (void)textFieldDidChange:(UITextField *)textField{
//    [_mViewModel getMechantDatas:textField.text];
}


-(void)onConfirmClicked{
    if(_mViewModel){
        MerchantModel *model = (MerchantModel *)[_mViewModel.merchantDatas objectAtIndex:selectRow];
        if(_mViewModel.from == MerchantFromType_BIND){
            [_mViewModel doBindMerchant:model];
        }else if(_mViewModel.from == MerchantFromType_ACTIVE){
            [_mViewModel goStartActiveDevice:model.mchId mchName:model.mchName];
        }else if(_mViewModel.from == MerchantFromType_UNBIND){
            [_mViewModel goMerchantUnBindPage:model];
        }
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_nameTF resignFirstResponder];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_nameTF resignFirstResponder];
}


//下拉刷新
-(void)refreshNew{
    selectRow = -1;
    [_mViewModel getMechantDatas:_nameTF.text refreshNew:YES];
}

//上拉加载更多
-(void)uploadMore{
    [_mViewModel getMechantDatas:_nameTF.text refreshNew:NO];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(_mViewModel){
        [textField resignFirstResponder];
        [_mViewModel getMechantDatas:_nameTF.text refreshNew:YES];
    }
    return YES;
}

@end
