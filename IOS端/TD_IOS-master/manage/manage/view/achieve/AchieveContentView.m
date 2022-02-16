//
//  AchieveContentView.m
//  manage
//
//  Created by by.huang on 2018/11/16.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "AchieveContentView.h"
#import "AchieveContentViewModel.h"
#import "AchieveMerchantCell.h"
#import "AchieveDeviceCell.h"
#import "AchieveProfitCell.h"
#import "TouchScrollView.h"
#import "STYearMonthLayerView.h"
#import "STTimeUtil.h"
@interface AchieveContentView()<UITableViewDelegate,UITableViewDataSource,AchieveContentViewDelegate,TouchScrollViewDelegate,STYearMonthLayerViewDelegate>

@property(assign, nonatomic)AchieveType mType;
@property(strong, nonatomic)UILabel *monthLabel;
@property(strong, nonatomic)UIImageView *monthImageView;
@property(strong, nonatomic)UILabel *totalLabel;
@property(strong, nonatomic)TouchScrollView *scrollView;
@property(strong, nonatomic)UITableView *tableView;
@property(strong, nonatomic)AchieveContentViewModel *viewModel;
@property(strong, nonatomic)STYearMonthLayerView *layerView;
@property(strong, nonatomic)UIImageView *noDataImageView;
@property(strong, nonatomic)UILabel *noDataLabel;
@property(strong, nonatomic)AchieveViewModel *achieveViewModel;




@end

@implementation AchieveContentView

-(instancetype)initWithType:(AchieveType)type viewModel:(AchieveViewModel *)achieveViewModel{
    if(self == [super init]){
        _mType = type;
        _achieveViewModel = achieveViewModel;
        _viewModel = [[AchieveContentViewModel alloc]init];
        _viewModel.delegate = self;
        [self initView];
        if(_mType == Achieve_Merchant){
            [_viewModel requestMerchantList:YES];
        }else if(_mType == Achieve_Device){
            [_viewModel requestDeviceList:YES];
        }else if(_mType == Achieve_Profit){
            [_viewModel  reqeustProfitList:YES];
        }
    }
    return self;
}

-(void)initView{
    
    self.frame = CGRectMake(0, 0, ScreenWidth, ContentHeight - STHeight(38));
    self.backgroundColor = cbg;
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, STHeight(55))];
    topView.backgroundColor = cwhite;
    [self addSubview:topView];
    
    UIButton *monthBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/2, STHeight(55))];
    [monthBtn addTarget:self action:@selector(onMonthClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:monthBtn];
    
    _monthLabel = [[UILabel alloc]initWithFont:STFont(16) text:[STTimeUtil generateDate:[STTimeUtil getCurrentTimeStamp] format:@"yyyy年MM月"] textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize monthSize = [_monthLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(16) fontName:FONT_MIDDLE];
    _monthLabel.frame = CGRectMake(STWidth(15), 0, monthSize.width, STHeight(55));
    [_monthLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(16)]];
    [topView addSubview:_monthLabel];
    
    _monthImageView = [[UIImageView alloc]initWithFrame:CGRectMake(monthSize.width + STWidth(25), (STHeight(55) - STWidth(13))/2, STWidth(13), STWidth(13))];
    _monthImageView.image = [UIImage imageNamed:IMAGE_REFRESH];
    _monthImageView.contentMode = UIViewContentModeScaleAspectFill;
    [topView addSubview:_monthImageView];
    
    NSString *totalStr;
    if(_mType == Achieve_Merchant){
        totalStr = @"直属代理商：0家  下级代理拓展：0家";
    }else if(_mType == Achieve_Device){
        totalStr = @"激活设备：0个";
    }else{
        totalStr = @"订单：0笔  设备收益：0.00元";
    }
    
    _totalLabel = [[UILabel alloc]initWithFont:STFont(14) text:totalStr textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize totalSize = [_totalLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14) fontName:FONT_MIDDLE];
    _totalLabel.frame = CGRectMake(STWidth(15), STHeight(55), totalSize.width, STHeight(45));
    [_totalLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(14)]];
    [topView addSubview:_totalLabel];
 
    
    _scrollView = [[TouchScrollView alloc]initWithParentView:self delegate:self];
    _scrollView.frame = CGRectMake(0, STHeight(100), ScreenWidth, ContentHeight - STHeight(138));
    [_scrollView enableHeader];
    [_scrollView enableFooter];
    [self addSubview:_scrollView];

    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ContentHeight - STHeight(138))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = cbg;
    _tableView.scrollEnabled = NO;
    [_tableView useDefaultProperty];
    
    
    [_scrollView addSubview:_tableView];
    
    _noDataImageView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - STWidth(100))/2, STHeight(200), STWidth(100), STWidth(100))];
    _noDataImageView.image = [UIImage imageNamed:IMAGE_NO_DATA];
    _noDataImageView.hidden = YES;
    [self addSubview:_noDataImageView];
    
    NSString *noDataStr = @"暂无数据";
    _noDataLabel = [[UILabel alloc]initWithFont:STFont(16) text:noDataStr textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    _noDataLabel.frame = CGRectMake(0, STHeight(310), ScreenWidth, STHeight(22));
    _noDataLabel.hidden = YES;
    [self addSubview:_noDataLabel];

    _layerView = [[STYearMonthLayerView alloc]initWithFrame:CGRectMake(0, StatuNavHeight, ScreenWidth, ContentHeight)];
    _layerView.hidden = YES;
    _layerView.delegate = self;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:_layerView];
    [_layerView setData:[NSString stringWithFormat:@"%d",_viewModel.year] month:[NSString stringWithFormat:@"%d",_viewModel.month]];
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_mType == Achieve_Merchant){
        return [_viewModel.merchantDatas count];
    }else if(_mType == Achieve_Device){
        return [_viewModel.deviceDatas count];
    }else if(_mType == Achieve_Profit){
        return 1;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(_mType == Achieve_Profit){
        return [_viewModel.profitDatas count];
    }
    return 1;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor =cbg;
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(_mType == Achieve_Profit){
        return STHeight(15);
    }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_mType == Achieve_Merchant){
        return STHeight(159);
    }else if(_mType == Achieve_Device){
        return STHeight(128);
    }else if(_mType == Achieve_Profit){
        return STHeight(192);
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_mType == Achieve_Merchant){
        if(_achieveViewModel){
            [_achieveViewModel goAgentDetailPage: [_viewModel.merchantDatas objectAtIndex:indexPath.row]];
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id cell;
    if(_mType == Achieve_Merchant){
        cell = [tableView dequeueReusableCellWithIdentifier:[AchieveMerchantCell identify]];
        if(!cell){
            cell = [[AchieveMerchantCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[AchieveMerchantCell identify]];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if(!IS_NS_COLLECTION_EMPTY(_viewModel.merchantDatas)){
            [cell updateData:[_viewModel.merchantDatas objectAtIndex:indexPath.row]];
        }
    }else if(_mType == Achieve_Device){
        cell = [tableView dequeueReusableCellWithIdentifier:[AchieveDeviceCell identify]];
        if(!cell){
            cell = [[AchieveDeviceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[AchieveDeviceCell identify]];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if(!IS_NS_COLLECTION_EMPTY(_viewModel.deviceDatas)){
            [cell updateData:[_viewModel.deviceDatas objectAtIndex:indexPath.row]];
        }
    }else if(_mType == Achieve_Profit){
        cell = [tableView dequeueReusableCellWithIdentifier:[AchieveProfitCell identify]];
        if(!cell){
            cell = [[AchieveProfitCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[AchieveProfitCell identify]];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if(!IS_NS_COLLECTION_EMPTY(_viewModel.profitDatas)){
            [cell updateData:[_viewModel.profitDatas objectAtIndex:indexPath.section]];
        }
    }

    return cell;
}


-(void)onRequestBegin{
    
}

-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    int type = [data intValue];
    [self updateUI:type];
    
    if(_mType == Achieve_Merchant){
        if(!IS_NS_COLLECTION_EMPTY(_viewModel.merchantDatas)){
            [self updateHasDataUI];
        }
    }else if(_mType == Achieve_Device){
        if(!IS_NS_COLLECTION_EMPTY(_viewModel.deviceDatas)){
            [self updateHasDataUI];
        }
    }else{
        if(!IS_NS_COLLECTION_EMPTY(_viewModel.profitDatas)){
            [self updateHasDataUI];
        }
    }
}

-(void)onRequestFail:(NSString *)msg{
    [_scrollView endRefreshNew];
    [_scrollView endUploadMore];
}

-(void)onRequestNoData:(int)type{
    [self updateUI:type];
    [_scrollView noMoreData];
    
    
    if(_mType == Achieve_Merchant){
        if(IS_NS_COLLECTION_EMPTY(_viewModel.merchantDatas)){
            [self updateNoDataUI];
        }else{
            [self updateHasDataUI];
        }
    }else if(_mType == Achieve_Device){
        if(IS_NS_COLLECTION_EMPTY(_viewModel.deviceDatas)){
            [self updateNoDataUI];
        }else{
            [self updateHasDataUI];
        }
    }else{
        if(IS_NS_COLLECTION_EMPTY(_viewModel.profitDatas)){
            [self updateNoDataUI];
        }else{
            [self updateHasDataUI];
        }
    }

}

-(void)onRequestTotalCount:(NSString *)count extra:(NSString *)extra{
    NSString *totalStr;
    if(_mType == Achieve_Merchant){
        totalStr = [NSString stringWithFormat:@"直属代理商：%@家  下级代理拓展：%@家",count,extra];
    }else if(_mType == Achieve_Device){
        totalStr = [NSString stringWithFormat:@"激活设备：%@个",count];
    }else{
        double extraDouble = [extra doubleValue];
        totalStr = [NSString stringWithFormat:@"订单：%@笔  设备收益：%.2f元",count,extraDouble];
    }
    _totalLabel.text = totalStr;
    CGSize totalSize = [_totalLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14) fontName:FONT_MIDDLE];
    _totalLabel.frame = CGRectMake(STWidth(15), STHeight(55), totalSize.width, STHeight(45));
}

-(void)updateUI:(int)type{
    if(type == Achieve_Merchant){
        _tableView.frame = CGRectMake(0, 0, ScreenWidth, STHeight(159) * [_viewModel.merchantDatas count]);
        [_scrollView setContentSize:CGSizeMake(ScreenWidth, STHeight(159) * [_viewModel.merchantDatas count])];
    }else if(type == Achieve_Device){
        _tableView.frame = CGRectMake(0, 0, ScreenWidth, STHeight(128) * [_viewModel.deviceDatas count]);
        [_scrollView setContentSize:CGSizeMake(ScreenWidth, STHeight(128) * [_viewModel.deviceDatas count])];
    }else if(type == Achieve_Profit){
        _tableView.frame = CGRectMake(0, 0, ScreenWidth, STHeight(207) * [_viewModel.profitDatas count]);
        [_scrollView setContentSize:CGSizeMake(ScreenWidth, STHeight(207) * [_viewModel.profitDatas count])];
    }
    [_tableView reloadData];
    [_scrollView endRefreshNew];
    [_scrollView endUploadMore];
}


-(void)onSelectResult:(NSString *)result layerView:(UIView *)layerView yearposition:(int)yearposition monthposition:(int)monthposition{
    CGSize monthSize = [result sizeWithMaxWidth:ScreenWidth font:STFont(16)];
    _monthLabel.frame = CGRectMake(STWidth(15), 0, monthSize.width, STHeight(55));
    _monthLabel.text = result;

    _monthImageView.frame = CGRectMake(monthSize.width + STWidth(25), (STHeight(55) - STWidth(13))/2, STWidth(13), STWidth(13));
    
    _viewModel.year = yearposition;
    _viewModel.month = monthposition;
    [self refreshNew];
    
}

//选择月份
-(void)onMonthClicked{
    [[[[UIApplication sharedApplication] delegate] window] bringSubviewToFront:_layerView];
    _layerView.hidden = NO;
}


//下拉刷新
-(void)refreshNew{
    if(_mType == Achieve_Merchant){
        [_viewModel requestMerchantList:YES];
    }else if(_mType == Achieve_Device){
        [_viewModel requestDeviceList:YES];
    }else{
        [_viewModel reqeustProfitList:YES];
    }
}

//上拉加载更多
-(void)uploadMore{
    if(_mType == Achieve_Merchant){
        [_viewModel requestMerchantList:NO];
    }else if(_mType == Achieve_Device){
        [_viewModel requestDeviceList:NO];
    }else{
        [_viewModel reqeustProfitList:NO];
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

-(void)onScrollViewDidScroll:(UIScrollView *)scrollView{}
@end
