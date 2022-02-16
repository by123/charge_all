//
//  TaxiView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "TaxiView.h"
#import "TaxiViewCell.h"

@interface TaxiView()<UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic)TaxiViewModel *mViewModel;
@property(strong, nonatomic)UIView *noDataView;
@property(strong, nonatomic)UITableView *tableView;

@end

@implementation TaxiView

-(instancetype)initWithViewModel:(TaxiViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];
    }
    return self;
}

-(void)initView{
    [self initTableView];
    [self initNoDataView];
}

-(void)initNoDataView{
    
    _noDataView = [[UIView alloc]init];
    _noDataView.frame = CGRectMake(0, 0, ScreenWidth, ContentHeight);
    _noDataView.hidden = YES;
    [self addSubview:_noDataView];
    
    [self createTitle];
    [self createContent];
    [self createStep];
    
    UIButton *createBtn = [[UIButton alloc]initWithFont:STFont(18) text:MSG_GROUP_CREATE textColor:c_btn_txt_highlight backgroundColor:c01 corner:0 borderWidth:0 borderColor:nil];
    createBtn.frame = CGRectMake(0, ContentHeight - STHeight(50), ScreenWidth, STHeight(50));
    [createBtn addTarget:self action:@selector(onCreateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:createBtn];

    
}


-(void)createTitle{
    NSArray *titles = @[MSG_TAXI_TITLE1,MSG_TAXI_TITLE2];
    for(int i = 0 ; i<titles.count ; i++){
        UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(16) text:titles[i] textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:NO];
        CGSize titleSize = [titleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(16) fontName:FONT_MIDDLE];
        [titleLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(16)]];
        titleLabel.frame = CGRectMake(STWidth(15), STHeight(15) + STHeight(63) * i, titleSize.width, STHeight(22));
        [_noDataView addSubview:titleLabel];
    }
}

-(void)createContent{
    UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_TAXI_CONTENT textAlignment:NSTextAlignmentLeft textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize titleSize = [titleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    titleLabel.frame = CGRectMake(STWidth(15), STHeight(42), titleSize.width, STHeight(21));
    [_noDataView addSubview:titleLabel];
}


-(void)createStep{
    NSArray *titles = @[MSG_TAXI_STEP_TITLE1,MSG_TAXI_STEP_TITLE2,MSG_TAXI_STEP_TITLE3];
    NSArray *contents = @[MSG_TAXI_STEP_CONTENT1,MSG_TAXI_STEP_CONTENT2,MSG_TAXI_STEP_CONTENT3];
    for(int i = 0 ; i < titles.count; i ++){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(STWidth(37), STHeight(115) + STHeight(81) * i, STWidth(6), STWidth(6))];
        view.backgroundColor = c01;
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = STWidth(3);
        [_noDataView addSubview:view];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:titles[i] textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:YES];
        CGSize titleSize = [titleLabel.text sizeWithMaxWidth:STWidth(264) font:STFont(15)];
        titleLabel.frame = CGRectMake(STWidth(48), STHeight(110) + STHeight(81) * i, STWidth(264), titleSize.height);
        [_noDataView addSubview:titleLabel];
        
        
        UILabel *contentLabel = [[UILabel alloc]initWithFont:STFont(14) text:contents[i] textAlignment:NSTextAlignmentLeft textColor:c11 backgroundColor:nil multiLine:YES];
        CGSize contentSize = [contentLabel.text sizeWithMaxWidth:STWidth(264) font:STFont(14)];
        contentLabel.frame = CGRectMake(STWidth(48), STHeight(136) + STHeight(81) * i, STWidth(264), contentSize.height);
        [_noDataView addSubview:contentLabel];
        
    }
}

-(void)onCreateBtnClick{
    [_mViewModel createGroup];
}



-(void)initTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ContentHeight-STHeight(50))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.hidden = YES;
    _tableView.backgroundColor = cbg;
    [_tableView useDefaultProperty];
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNew)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(uploadMore)];
    _tableView.mj_footer = footer;
    
    [self addSubview:_tableView];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_mViewModel.datas count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return STHeight(338);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TaxiViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[TaxiViewCell identify]];
    if(!cell){
        cell = [[TaxiViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[TaxiViewCell identify]];
    }
    cell.addDeviceBtn.tag = indexPath.row;
    [cell.addDeviceBtn addTarget:self action:@selector(onAddDeviceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.moreBtn.tag = indexPath.row;
    [cell.moreBtn addTarget:self action:@selector(onMoreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.datas)){
        [cell updateData:[_mViewModel.datas objectAtIndex:indexPath.row]];
    }
    return cell;
}



-(void)updateView{
    [_tableView setContentSize:CGSizeMake(ScreenWidth, STHeight(338) * [_mViewModel.datas count])];
    [_tableView reloadData];
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
    _tableView.hidden = NO;
    _noDataView.hidden = YES;
}


-(void)refreshNew{
    [_mViewModel requestGroupList:YES];
    
}

-(void)uploadMore{
    [_mViewModel requestGroupList:NO];
}

-(void)onRequestNoData:(Boolean)empty{
    if(empty){
        _tableView.hidden = YES;
        _noDataView.hidden = NO;
    }else{
        _tableView.hidden = NO;
        _noDataView.hidden = YES;
        [_tableView reloadData];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshingWithNoMoreData];
        [_tableView setContentSize:CGSizeMake(ScreenWidth, STHeight(338) * [_mViewModel.datas count])];
    }
  
}


-(void)onAddDeviceBtnClicked:(id)sender{
    NSInteger tag = ((UIButton *)sender).tag;
    [STLog print:[NSString stringWithFormat:@"%ld",(long)tag]];
    if(_mViewModel){
        GroupModel *model = [_mViewModel.datas objectAtIndex:tag];
        [_mViewModel goScanPage:model.groupId groupName:model.groupName];
    }
}

-(void)onMoreBtnClicked:(id)sender{
    NSInteger tag = ((UIButton *)sender).tag;
    if(_mViewModel){
        GroupModel *model = [_mViewModel.datas objectAtIndex:tag];
        [_mViewModel goGroupDetailPage:model];
    }
}

@end

