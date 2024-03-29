//
//  SubPerformanceMerchantView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "SubPerformanceMerchantView.h"
#import "PerformanceMerchantCell.h"
#import "PerformanceMerchantSubMCell.h"
#import "PerformanceMerchantSubACell.h"
#import "STDateBlockView.h"
#import "STMultiLabelView.h"
#import "STPerformanceSearchView.h"
#import "STTimeUtil.h"
#import "PerformanceMerchantModel.h"
#import "AccountManager.h"

@interface SubPerformanceMerchantView()<UITableViewDelegate,UITableViewDataSource,STDateBlockViewDelegate,STPerformanceSearchDelegate>

@property(strong, nonatomic)SubPerformanceMerchantViewModel *mViewModel;
@property(strong, nonatomic)UITableView *tableView;
@property(strong, nonatomic)UIView *selectView;
@property(strong, nonatomic)STDateBlockView *dateBlockView;
@property(strong, nonatomic)STMultiLabelView *multiLabelView;
@property(strong, nonatomic)STPerformanceSearchView *searchView;
@property(strong, nonatomic)UIView *noDataView;
@end

@implementation SubPerformanceMerchantView{
    Boolean isExpand;
}

-(instancetype)initWithViewModel:(SubPerformanceMerchantViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];
        [_mViewModel reqeustMerchant:YES];
    }
    return self;
}


-(void)initView{
    [self initSelectView];
    [self initSearchView];
    [self initTableView];
    [self initNoDataView];
}


/********************** selectview ****************************/

-(void)initSelectView{
    _selectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, STHeight(173))];
    _selectView.backgroundColor = cwhite;
    [self addSubview:_selectView];
    
    UILabel *mchLabel = [[UILabel alloc]initWithFont:STFont(16) text:[NSString stringWithFormat:@"%@ %@",_mViewModel.mchId,_mViewModel.mchName] textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize mchSize = [mchLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(16) fontName:@"PingFangSC-Medium"];
    [mchLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:STFont(16)]];
    mchLabel.frame = CGRectMake(STWidth(15), 0, mchSize.width, STHeight(56));
    [_selectView addSubview:mchLabel];

    
    _dateBlockView = [[STDateBlockView alloc]initWithFrame:CGRectMake(0, STHeight(56), ScreenWidth, STHeight(20))];
    [_dateBlockView setController:_mViewModel.controller];
    _dateBlockView.delegate = self;
    [_dateBlockView setMaxSelectDays:30];
    [_dateBlockView setDate:_mViewModel.startDay endDate:_mViewModel.endDay];
    [_selectView addSubview:_dateBlockView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(90), STWidth(345), LineHeight)];
    lineView.backgroundColor = cline;
    [_selectView addSubview:lineView];
    
    _multiLabelView = [[STMultiLabelView alloc]initWithFrame:CGRectMake(0, STHeight(90)+LineHeight, ScreenWidth, STHeight(80))];
    [_multiLabelView setDatas:@[@"123",@"12123",@"4354",@"324"]];
    [_selectView addSubview:_multiLabelView];
}



-(void)onDateBlockSelected:(NSString *)startDate endDate:(NSString *)endDate{
    _mViewModel.startDay = startDate;
    _mViewModel.endDay = endDate;
    [_mViewModel reqeustMerchant:YES];
}




/********************** searchview ****************************/

-(void)initSearchView{
    _searchView = [[STPerformanceSearchView alloc]initWithSearchView:CGRectMake(0, STHeight(188), ScreenWidth, STHeight(106))  searchBtn:NO];
    _searchView.backgroundColor = cwhite;
    _searchView.delegate = self;
    [self addSubview:_searchView];
    
}

-(void)hiddenKeyboard{
    [_searchView hiddenKeyboard];
}


-(void)onPerformanceSearchTextFieldChange:(NSString *)content{
    
}

-(void)onPerformanceSearchBtnSelected:(NSInteger)position content:(NSString *)content{
    _mViewModel.isChild = (position == 1);
    [_mViewModel.merchantDatas removeAllObjects];
    [_mViewModel reqeustMerchant:YES];
}

-(void)onPerformanceSearchClicked:(NSString *)key{
    _mViewModel.qryInfo = key;
    [_mViewModel reqeustMerchant:YES];
}




/********************** tableview ****************************/
-(void)initTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, STHeight(188) + STHeight(106), ScreenWidth, ContentHeight - STHeight(188) - STHeight(106))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView useDefaultProperty];
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNew)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(uploadMore)];
    _tableView.mj_footer = footer;
    
    [self addSubview:_tableView];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_mViewModel.merchantDatas count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.merchantDatas)){
        PerformanceMerchantModel *model = [_mViewModel.merchantDatas objectAtIndex:indexPath.row];
        if(model.mchType == 1){
            return _mViewModel.isChild ? STHeight(140) : STHeight(170);
        }
    }
    return _mViewModel.isChild ? STHeight(170) : STHeight(200);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id cell;
    PerformanceMerchantModel *model = [_mViewModel.merchantDatas objectAtIndex:indexPath.row];
    if(_mViewModel.isChild){
        if(model.mchType == 1){
            cell = [tableView dequeueReusableCellWithIdentifier:[PerformanceMerchantSubMCell identify]];
            if(!cell){
                cell = [[PerformanceMerchantSubMCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[PerformanceMerchantSubMCell identify]];
                ((PerformanceMerchantSubMCell *)cell).nameBtn.tag = indexPath.row;
                [((PerformanceMerchantSubMCell *)cell).nameBtn addTarget:self action:@selector(onAgentClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:[PerformanceMerchantSubACell identify]];
            if(!cell){
                cell = [[PerformanceMerchantSubACell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[PerformanceMerchantSubACell identify]];
                ((PerformanceMerchantSubACell *)cell).nameBtn.tag = indexPath.row;
                [((PerformanceMerchantSubACell *)cell).nameBtn addTarget:self action:@selector(onAgentClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:[PerformanceMerchantCell identify]];
        if(!cell){
            cell = [[PerformanceMerchantCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[PerformanceMerchantCell identify]];
            ((PerformanceMerchantCell *)cell).nameBtn.tag = indexPath.row;
            [((PerformanceMerchantCell *)cell).nameBtn addTarget:self action:@selector(onAgentClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.merchantDatas)){
        [cell updateData:model];
    }
    return cell;
}

-(void)onAgentClicked:(id)sender{
    UIButton *btn = sender;
    NSInteger tag = btn.tag;
    PerformanceMerchantModel *model = [_mViewModel.merchantDatas objectAtIndex:tag];
    [_mViewModel goDetailPage:model.mchId mchType:model.mchType];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PerformanceMerchantModel *model = [_mViewModel.merchantDatas objectAtIndex:indexPath.row];
    if(model.mchType != 1){
        [_mViewModel goSubPerformanceMerchantPage:model.mchId mchName:model.mchName startDay:_mViewModel.startDay endDay:_mViewModel.endDay];
    }
}


-(void)updateView{
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
    [_tableView reloadData];
    _tableView.hidden = NO;
    _noDataView.hidden = YES;
}

-(void)updateTotalView{
    NSArray *datas = @[@(_mViewModel.directAgent),@(_mViewModel.directTenant),@(_mViewModel.subordinateAgent),@(_mViewModel.subordinateTenant)];
    [_multiLabelView setDatas:datas];
}

-(void)updateNoData:(Boolean)noData{
    if(noData){
        _tableView.hidden = YES;
        _noDataView.hidden = NO;
    }else{
        _tableView.hidden = NO;
        _noDataView.hidden = YES;
        [_tableView reloadData];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshingWithNoMoreData];
    }
}


-(void)refreshNew{
    [_mViewModel reqeustMerchant:YES];
}

-(void)uploadMore{
    [_mViewModel reqeustMerchant:NO];
}


/********************** noDataView ****************************/
-(void)initNoDataView{
    _noDataView = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(294), ScreenWidth, ContentHeight - STHeight(224) - STHeight(38))];
    _noDataView.hidden = YES;
    _noDataView.backgroundColor = cwhite;
    [self addSubview:_noDataView];
    
    UIImageView *noDataImageView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - STWidth(100))/2, STHeight(70), STWidth(100), STWidth(100))];
    noDataImageView.image = [UIImage imageNamed:IMAGE_NO_DATA];
    noDataImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_noDataView addSubview:noDataImageView];
    
    UILabel *noDataLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"该代理暂无数据" textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    noDataLabel.frame = CGRectMake(0, STHeight(180), ScreenWidth, STHeight(30));
    [_noDataView addSubview:noDataLabel];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = _tableView.mj_offsetY;
    STPrint(DoubleStr(offsetY));
    WS(weakSelf)
    if(offsetY > 0 && !isExpand){
        isExpand = YES;
        WS(weakSelf)
        [UIView animateWithDuration:0.3f animations:^{
            weakSelf.noDataView.frame = CGRectMake(0, STHeight(294)-STHeight(95), ScreenWidth, ContentHeight - STHeight(224) - STHeight(38)+STHeight(95));
            weakSelf.tableView.frame = CGRectMake(0, STHeight(188) + STHeight(106)-STHeight(95), ScreenWidth, ContentHeight - STHeight(188) - STHeight(106)+STHeight(95));
            weakSelf.searchView.frame = CGRectMake(0, STHeight(188)-STHeight(95), ScreenWidth, STHeight(106));
        }];
        return;
    }
    if(offsetY < 0 && isExpand){
        isExpand = NO;
        [UIView animateWithDuration:0.3f animations:^{
            weakSelf.noDataView.frame = CGRectMake(0, STHeight(294), ScreenWidth, ContentHeight - STHeight(224) - STHeight(38));
            weakSelf.tableView.frame = CGRectMake(0, STHeight(188) + STHeight(106), ScreenWidth, ContentHeight - STHeight(188) - STHeight(106));
            weakSelf.searchView.frame = CGRectMake(0, STHeight(188), ScreenWidth, STHeight(106));
            
        }];
        return;
    }
}

@end
