//
//  BankView.m
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "BankView.h"
#import "BankViewCell.h"
@interface BankView()<UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic)BankViewModel *mViewModel;
@property(strong, nonatomic)UIView *noDataView;
@property(strong, nonatomic)UITableView *tableView;
@property(strong, nonatomic)UIButton *addBtn;

@end

@implementation BankView


-(instancetype)initWithViewModel:(BankViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];
    }
    return self;
}


-(void)initView{
    [self initNoDataView];
    [self initTableView];

    _addBtn = [[UIButton alloc]initWithFont:STFont(18) text:MSG_ADD_BK textColor:c_btn_txt_highlight backgroundColor:c01 corner:0 borderWidth:0 borderColor:nil];
    [_addBtn setBackgroundColor:c02 forState:UIControlStateHighlighted];
    _addBtn.frame = CGRectMake(0, ContentHeight- STHeight(50), ScreenWidth, STHeight(50));
    [_addBtn addTarget:self action:@selector(onAddClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addBtn];

    
}

-(void)initTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ContentHeight-STHeight(50))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView useDefaultProperty];
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNew)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView.mj_header = header;
    
    [self addSubview:_tableView];
    
}


-(void)initNoDataView{
    _noDataView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ContentHeight)];
    _noDataView.backgroundColor = cwhite;
    _noDataView.hidden = YES;
    [self addSubview:_noDataView];
    
    UIImageView *noBankImageView = [[UIImageView alloc]init];
    noBankImageView.image = [UIImage imageNamed:IMAGE_NO_BANK];
    noBankImageView.contentMode = UIViewContentModeScaleAspectFill;
    noBankImageView.frame = CGRectMake((ScreenWidth-STWidth(100))/2, STHeight(70),STWidth(100) , STWidth(100));
    [_noDataView addSubview:noBankImageView];
    
    UILabel *noBankLabel = [[UILabel alloc]initWithFont:STFont(16) text:MSG_NO_BK_DETAIL textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    noBankLabel.frame = CGRectMake(0, STHeight(180), ScreenWidth, STHeight(22));
    [_noDataView addSubview:noBankLabel];
    
}


-(void)updateView{
    if(IS_NS_COLLECTION_EMPTY(_mViewModel.banks)){
        _noDataView.hidden = NO;
        _tableView.hidden = YES;
        _addBtn.hidden = NO;
    }else{
        _noDataView.hidden = YES;
        _tableView.hidden = NO;
        [_tableView reloadData];
        [_tableView.mj_header endRefreshing];
        _addBtn.hidden = [BankModel hasAllType:_mViewModel.banks];

    }

}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_mViewModel.banks count];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return STHeight(10);
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.banks)){
        BankModel *model = [_mViewModel.banks objectAtIndex:indexPath.section];
        if(IS_NS_STRING_EMPTY(model.headUrl)){
            return STHeight(114);
        }
        return STHeight(90);
    }
    return 0;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BankViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[BankViewCell identify]];
    if(!cell){
        cell = [[BankViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[BankViewCell identify]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.banks)){
        [cell updateData:[_mViewModel.banks objectAtIndex:indexPath.section]];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BankModel *model = [_mViewModel.banks objectAtIndex:indexPath.section];
    model.hasAllType = [BankModel hasAllType:_mViewModel.banks];
    [_mViewModel goBankDetailPage:model];
}


-(void)refreshNew{
    [_mViewModel getBankInfo];
}



-(void)onAddClick{
    if(_mViewModel){
        [_mViewModel goAddBankHomePage];
    }
}


@end
