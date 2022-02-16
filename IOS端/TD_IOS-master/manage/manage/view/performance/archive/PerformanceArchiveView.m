//
//  PerformanceArchiveView.m
//  manage
//
//  Created by by.huang on 2019/7/1.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "PerformanceArchiveView.h"
#import "PerformanceViewModel.h"
#import "STRecentDateView.h"
#import "STDateBlockView.h"
#import "STPerformanceSearchView.h"
#import "PerformanceArchiveCell.h"
#import "STTimeUtil.h"
#import "AccountManager.h"

@interface PerformanceArchiveView()<UITableViewDelegate,UITableViewDataSource,STRecentDateViewDelegate,STDateBlockViewDelegate>

@property(strong, nonatomic)PerformanceViewModel *mViewModel;
@property(strong, nonatomic)UITableView *tableView;
@property(strong, nonatomic)UIView *selectView;
@property(strong, nonatomic)STRecentDateView *recentDateView;
@property(strong, nonatomic)STDateBlockView *dateBlockView;
@property(strong, nonatomic)UILabel *activeTotalLabel;
@property(strong, nonatomic)UIView *lineView;
@property(strong, nonatomic)UILabel *profitTotalLabel;
@property(strong, nonatomic)UIView *noDataView;

@end

@implementation PerformanceArchiveView{
    Boolean isExpand;
}

-(instancetype)initWithViewModel:(PerformanceViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];
    }
    return self;
}

-(void)initView{
    [self initSelectView];
    [self initTableView];
    [self initNoDataView];
    
    _mViewModel.startDay = [STTimeUtil getTodayDate];
    _mViewModel.endDay = [STTimeUtil getTodayDate];
    _mViewModel.mchId = [[AccountManager sharedAccountManager] getUserModel].mchId;
    [_mViewModel requestArchiveList:YES];
}


/********************** selectview ****************************/

-(void)initSelectView{
    _selectView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, STHeight(143))];
    _selectView.backgroundColor = cwhite;
    [self addSubview:_selectView];
    
    _recentDateView = [[STRecentDateView alloc]init];
    _recentDateView.frame = CGRectMake(0, STHeight(21), ScreenWidth, STHeight(21));
    _recentDateView.delegate = self;
    [_selectView addSubview:_recentDateView];
    
    _dateBlockView = [[STDateBlockView alloc]initWithFrame:CGRectMake(0, STHeight(56), ScreenWidth, STHeight(20))];
    [_dateBlockView setController:_mViewModel.controller];
    _dateBlockView.delegate = self;
    [_dateBlockView setMaxSelectDays:30];
    [_dateBlockView setDate:[STTimeUtil getTodayDate] endDate:[STTimeUtil getTodayDate]];
    [_selectView addSubview:_dateBlockView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(90), STWidth(345), LineHeight)];
    lineView.backgroundColor = cline;
    [_selectView addSubview:lineView];
    
    _activeTotalLabel = [[UILabel alloc]initWithFont:STFont(14) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    [_selectView addSubview:_activeTotalLabel];
    
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = cline;
    [self addSubview:_lineView];
    
    _profitTotalLabel = [[UILabel alloc]initWithFont:STFont(14) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    [_selectView addSubview:_profitTotalLabel];
    
}


-(void)onRecentDateViewSelected:(NSInteger)positon str:(NSString *)str{
    NSString *nowDate = [STTimeUtil getTodayDate];
    if(positon == 0){
        [_dateBlockView setDate:nowDate endDate:nowDate];
        _mViewModel.startDay = nowDate;
        _mViewModel.endDay = nowDate;
    }else if(positon == 1){
        [_dateBlockView setDate:[STTimeUtil getLastDates:7] endDate:nowDate];
        _mViewModel.startDay = [STTimeUtil getLastDates:7];
        _mViewModel.endDay = nowDate;
    }else if(positon == 2){
        [_dateBlockView setDate:[STTimeUtil getLastDates:30] endDate:nowDate];
        _mViewModel.startDay = [STTimeUtil getLastDates:30];
        _mViewModel.endDay = nowDate;
    }
    [_mViewModel requestArchiveList:YES];
}

-(void)onDateBlockSelected:(NSString *)startDate endDate:(NSString *)endDate{
    NSString *nowDate = [STTimeUtil getTodayDate];
    if([startDate isEqualToString:nowDate] && [endDate isEqualToString:nowDate]){
        [_recentDateView setRecentDateSelect:0];
    }else if([startDate isEqualToString:[STTimeUtil getLastDates:7]] && [endDate isEqualToString:nowDate]){
        [_recentDateView setRecentDateSelect:1];
    }else if([startDate isEqualToString:[STTimeUtil getLastDates:30]] && [endDate isEqualToString:nowDate]){
        [_recentDateView setRecentDateSelect:2];
    }else{
        [_recentDateView clearAllDateSelect];
    }
    _mViewModel.startDay = startDate;
    _mViewModel.endDay = endDate;
    [_mViewModel requestArchiveList:YES];
}




/********************** tableview ****************************/
-(void)initTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, STHeight(155), ScreenWidth, ContentHeight - STHeight(155) - STHeight(38))];
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
    return [_mViewModel.archiveDatas count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return STHeight(187+15);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PerformanceArchiveCell *cell = [tableView dequeueReusableCellWithIdentifier:[PerformanceArchiveCell identify]];
    if(!cell){
        cell = [[PerformanceArchiveCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[PerformanceArchiveCell identify]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.archiveDatas)){
        [cell updateData:[_mViewModel.archiveDatas objectAtIndex:indexPath.row]];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PerformanceArchiveModel *model = [_mViewModel.archiveDatas objectAtIndex:indexPath.row];
  
}


-(void)updateView{
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
    [_tableView reloadData];
    _tableView.hidden = NO;
    _noDataView.hidden = YES;
    [self updateTotalView];
}

-(void)updateTotalView{
    _activeTotalLabel.text = [NSString stringWithFormat:@"订单:%d笔",_mViewModel.orderCount];
    CGSize activeTotalSize = [_activeTotalLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _activeTotalLabel.frame = CGRectMake(STWidth(15), STHeight(108), activeTotalSize.width, STHeight(20));
    
    _lineView.frame = CGRectMake(STWidth(30) + activeTotalSize.width, STHeight(113), LineHeight, STHeight(10));
    
    _profitTotalLabel.text = [NSString stringWithFormat:@"设备总收益:%.2f元",_mViewModel.amountCount];
    CGSize profitTotalSize = [_profitTotalLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _profitTotalLabel.frame = CGRectMake(STWidth(45) + activeTotalSize.width, STHeight(108), profitTotalSize.width, STHeight(20));

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
    [self updateTotalView];
}


-(void)refreshNew{
    [_mViewModel requestArchiveList:YES];
}

-(void)uploadMore{
    [_mViewModel requestArchiveList:NO];
}

/********************** noDataView ****************************/
-(void)initNoDataView{
    _noDataView = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(155), ScreenWidth, ContentHeight - STHeight(155) - STHeight(38))];
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
            weakSelf.tableView.frame = CGRectMake(0, STHeight(155)-STHeight(64), ScreenWidth, ContentHeight - STHeight(155) - STHeight(38)+STHeight(64));
            weakSelf.noDataView.frame = CGRectMake(0, STHeight(155) - STHeight(64), ScreenWidth, ContentHeight - STHeight(155) - STHeight(38) + STHeight(64));
        }];
        return;
    }
    if(offsetY < 0 && isExpand){
        isExpand = NO;
        [UIView animateWithDuration:0.3f animations:^{
            weakSelf.tableView.frame = CGRectMake(0, STHeight(155), ScreenWidth, ContentHeight - STHeight(155) - STHeight(38));
            weakSelf.noDataView.frame = CGRectMake(0, STHeight(155), ScreenWidth, ContentHeight - STHeight(155) - STHeight(38));
            
        }];
        return;
    }
}


@end
