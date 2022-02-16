
//
//  CapitalContentVIew.m
//  manage
//
//  Created by by.huang on 2018/11/17.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "CapitalContentView.h"
#import "STYearMonthLayerView.h"
#import "CapitalProfitCell.h"
#import "TouchScrollView.h"
#import "STTimeUtil.h"

@interface CapitalContentView()<UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic)CapitalViewModel *mViewModel;
@property(strong, nonatomic)TouchScrollView *scrollView;
@property(strong, nonatomic)UITableView *tableView;
@property(strong, nonatomic)UIImageView *noDataImageView;
@property(strong, nonatomic)UILabel *noDataLabel;

@end

@implementation CapitalContentView

-(instancetype)initWithViewModel:(CapitalViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];       
    }
    return self;
}

-(void)initView{
    
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - STHeight(295) - StatuBarHeight - STHeight(50));
    self.backgroundColor = cwhite;
    
    CGFloat homeHeight = 0;
    if (@available(iOS 11.0, *)) {
        homeHeight = HomeIndicatorHeight;
    } else {
        homeHeight = 0;
    }
    
    _scrollView = [[TouchScrollView alloc]initWithParentView:self delegate:nil];
    _scrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - StatuBarHeight - STHeight(345) - homeHeight);
//    [_scrollView enableHeader];
//    [_scrollView enableFooter];
    _scrollView.scrollEnabled = NO;
    [self addSubview:_scrollView];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - StatuBarHeight - STHeight(345) - homeHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = cwhite;
    _tableView.scrollEnabled = NO;
    [_tableView useDefaultProperty];
    
    
    [_scrollView addSubview:_tableView];
    
    
    _noDataImageView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - STWidth(100))/2, STHeight(70), STWidth(100), STWidth(100))];
    _noDataImageView.image = [UIImage imageNamed:IMAGE_NO_CAPITAL];
    _noDataImageView.hidden = YES;
    [self addSubview:_noDataImageView];
    
    NSString *noDataStr = MSG_NO_SY_DETAIL;
    _noDataLabel = [[UILabel alloc]initWithFont:STFont(16) text:noDataStr textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    _noDataLabel.frame = CGRectMake(0, STHeight(180), ScreenWidth, STHeight(22));
    _noDataLabel.hidden = YES;
    [self addSubview:_noDataLabel];
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   return [_mViewModel.profitDatas count];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     return STHeight(52.5);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CapitalProfitCell *cell = [tableView dequeueReusableCellWithIdentifier:[CapitalProfitCell identify]];
    if(!cell){
        cell = [[CapitalProfitCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[CapitalProfitCell identify]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.profitDatas)){
        ProfitModel *model = [_mViewModel.profitDatas objectAtIndex:indexPath.section];
//        NSString *timeStr = [STTimeUtil generateDate:[NSString stringWithFormat:@"%ld",model.profitDate] format:@"yyyy-MM-dd"];
//        NSString *currentStr = [STTimeUtil generateDate:[STTimeUtil getCurrentTimeStamp] format:@"yyyy-MM-dd"];
//        if(![timeStr isEqualToString:currentStr]){
            [cell updateData:model];
//        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger position = indexPath.section;
    if(_mViewModel){
        ProfitModel *model = [_mViewModel.profitDatas objectAtIndex:position];
        [_mViewModel goCapitalDetailPage:[STTimeUtil generateDate:[NSString stringWithFormat:@"%ld",model.profitDate] format:@"yyyy-MM-dd"]];
    }
    
}



-(void)updateSuccessData:(id)data{
    int type = [data intValue];
    [self updateUI:type];
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.profitDatas)){
        [self updateHasDataUI];
    }
}


-(void)updateNoData:(int)type{
    [self updateUI:type];
    if(IS_NS_COLLECTION_EMPTY(_mViewModel.profitDatas)){
        [self updateNoDataUI];
    }else{
        [self updateHasDataUI];
    }
    
}


-(void)updateUI:(int)type{
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, STHeight(52.5) * [_mViewModel.profitDatas count] + STHeight(15));
    _scrollView.frame = CGRectMake(0, 0, ScreenWidth, STHeight(52.5) * [_mViewModel.profitDatas count] + STHeight(15));
    [_tableView reloadData];
    if(_mViewModel.delegate){
        [_mViewModel.delegate onRefreshEnd];
        [_mViewModel.delegate onUpdateUI:type count:[_mViewModel.profitDatas count]];
    }
}


//无数据
-(void)updateNoDataUI{
    _scrollView.hidden = YES;
    _noDataImageView.hidden = NO;
    _noDataLabel.hidden = NO;
}


//有数据
-(void)updateHasDataUI{
    _scrollView.hidden = NO;
    _noDataImageView.hidden = YES;
    _noDataLabel.hidden = YES;
}


//上拉加载更多
-(void)uploadMore{
    [_mViewModel reqeustCapitalList:NO];
}

//下拉刷新
-(void)refreshNew{
    [_mViewModel reqeustCapitalList:YES];
}

@end
