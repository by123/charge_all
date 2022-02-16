//
//  SubPerformanceActiveView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "SubPerformanceActiveView.h"
#import "STDateBlockView.h"
#import "STPerformanceSearchView.h"
#import "PerformanceActiveCell.h"

@interface SubPerformanceActiveView()<UITableViewDelegate,UITableViewDataSource,STDateBlockViewDelegate,STPerformanceSearchDelegate>

@property(strong, nonatomic)SubPerformanceActiveViewModel *mViewModel;
@property(strong, nonatomic)UITableView *tableView;
@property(strong, nonatomic)UIView *selectView;
@property(strong, nonatomic)STDateBlockView *dateBlockView;
@property(strong, nonatomic)STPerformanceSearchView *searchView;
@property(strong, nonatomic)UILabel *activeTotalLabel;
@property(strong, nonatomic)UIView *noDataView;

@end

@implementation SubPerformanceActiveView{
    Boolean isExpand;
}

-(instancetype)initWithViewModel:(SubPerformanceActiveViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];
        [_mViewModel requestActive:YES];
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
    _selectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, STHeight(143))];
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
    
    _activeTotalLabel = [[UILabel alloc]initWithFont:STFont(14) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize activeTotalSize = [_activeTotalLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _activeTotalLabel.frame = CGRectMake(STWidth(15), STHeight(108), activeTotalSize.width, STHeight(20));
    [_selectView addSubview:_activeTotalLabel];
    
}


-(void)onDateBlockSelected:(NSString *)startDate endDate:(NSString *)endDate{
    _mViewModel.startDay = startDate;
    _mViewModel.endDay = endDate;
    [_mViewModel requestActive:YES];
}






/********************** searchview ****************************/

-(void)initSearchView{
    _searchView = [[STPerformanceSearchView alloc]initWithSearchView:CGRectMake(0, STHeight(158), ScreenWidth, STHeight(66)) searchBtn:YES];
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
    
}

-(void)onPerformanceSearchClicked:(NSString *)key{
    _mViewModel.qryInfo = key;
    [_mViewModel requestActive:YES];
}


/********************** tableview ****************************/
-(void)initTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, STHeight(224), ScreenWidth, ContentHeight - STHeight(224) - STHeight(38))];
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
    return [_mViewModel.activeDatas count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.activeDatas)){
        PerformanceActiveModel *model = [_mViewModel.activeDatas objectAtIndex:indexPath.row];
        if(model.mchType == 1){
            return STHeight(140);
        }
    }
    return STHeight(170);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PerformanceActiveCell *cell = [tableView dequeueReusableCellWithIdentifier:[PerformanceActiveCell identify]];
    if(!cell){
        cell = [[PerformanceActiveCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[PerformanceActiveCell identify]];
    }
    cell.nameBtn.tag = indexPath.row;
    [cell.nameBtn addTarget:self action:@selector(onAgentClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.activeDatas)){
        [cell updateData:[_mViewModel.activeDatas objectAtIndex:indexPath.row]];
    }
    return cell;
}

-(void)onAgentClicked:(id)sender{
    UIButton *btn = sender;
    NSInteger tag = btn.tag;
    PerformanceActiveModel *model = [_mViewModel.activeDatas objectAtIndex:tag];
    [_mViewModel goDetailPage:model.mchId mchType:model.mchType];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PerformanceActiveModel *model =  [_mViewModel.activeDatas objectAtIndex:indexPath.row];
    if(model.mchType != 1){
        [_mViewModel goSubPerformanceActivePage:model.mchId mchName:model.mchName startDay:_mViewModel.startDay endDay:_mViewModel.endDay];
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
    _activeTotalLabel.text = [NSString stringWithFormat:@"设备激活总数:%d",_mViewModel.count];
    CGSize activeTotalSize = [_activeTotalLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _activeTotalLabel.frame = CGRectMake(STWidth(15), STHeight(108), activeTotalSize.width, STHeight(20));
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
    [_tableView.mj_header endRefreshing];
    
}

-(void)uploadMore{
    [_tableView.mj_footer endRefreshingWithNoMoreData];
}

/********************** noDataView ****************************/
-(void)initNoDataView{
    _noDataView = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(224), ScreenWidth, ContentHeight - STHeight(224) - STHeight(38))];
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
            weakSelf.noDataView.frame = CGRectMake(0, STHeight(224)-STHeight(67), ScreenWidth, ContentHeight - STHeight(224) - STHeight(38)+STHeight(67));
            weakSelf.tableView.frame = CGRectMake(0, STHeight(224)-STHeight(67), ScreenWidth, ContentHeight - STHeight(224) - STHeight(38)+STHeight(67));
            weakSelf.searchView.frame = CGRectMake(0, STHeight(158)-STHeight(67), ScreenWidth, STHeight(66));
        }];
        return;
    }
    if(offsetY < 0 && isExpand){
        isExpand = NO;
        [UIView animateWithDuration:0.3f animations:^{
            weakSelf.noDataView.frame = CGRectMake(0, STHeight(224), ScreenWidth, ContentHeight - STHeight(224) - STHeight(38));
            weakSelf.tableView.frame = CGRectMake(0, STHeight(224), ScreenWidth, ContentHeight - STHeight(224) - STHeight(38));
            weakSelf.searchView.frame = CGRectMake(0, STHeight(158), ScreenWidth, STHeight(66));
            
        }];
        return;
    }
}

@end
