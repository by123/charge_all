//
//  WithdrawContentView.m
//  manage
//
//  Created by by.huang on 2018/12/6.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "WithdrawContentView.h"
#import "WithdrawCell.h"
#import "TouchScrollView.h"
#import "WithdrawWechatCell.h"

@interface WithdrawContentView()<UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic)CapitalViewModel *mViewModel;
@property(strong, nonatomic)TouchScrollView *scrollView;
@property(strong, nonatomic)UITableView *tableView;
@property(strong, nonatomic)UIImageView *noDataImageView;
@property(strong, nonatomic)UILabel *noDataLabel;


@end

@implementation WithdrawContentView

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

    
    _scrollView = [[TouchScrollView alloc]initWithParentView:self delegate:nil];
    _scrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - StatuBarHeight - STHeight(346) - STHeight(50));
//    [_scrollView enableHeader];
//    [_scrollView enableFooter];
    _scrollView.scrollEnabled = NO;
    [self addSubview:_scrollView];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - StatuBarHeight - STHeight(346) - STHeight(50))];
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
    
    NSString *noDataStr = MSG_NO_TX_DETAIL;
    _noDataLabel = [[UILabel alloc]initWithFont:STFont(16) text:noDataStr textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    _noDataLabel.frame = CGRectMake(0, STHeight(180), ScreenWidth, STHeight(22));
    _noDataLabel.hidden = YES;
    [self addSubview:_noDataLabel];
    
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_mViewModel.withdrawDatas count];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return STHeight(15);
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.withdrawDatas)){
        WithdrawDetailModel *model = [_mViewModel.withdrawDatas objectAtIndex:indexPath.section];
        if(model.isPublic == 2){
            return STHeight(223-31);
        }else{
            return STHeight(223-31);
        }
    }
    return 0;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id cell;
    WithdrawDetailModel *model = [_mViewModel.withdrawDatas objectAtIndex:indexPath.section];
    if(model.isPublic == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:[WithdrawWechatCell identify]];
        if(!cell){
            cell = [[WithdrawWechatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[WithdrawWechatCell identify]];
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:[WithdrawCell identify]];
        if(!cell){
            cell = [[WithdrawCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[WithdrawCell identify]];
        }
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.withdrawDatas)){
        [cell updateData:[_mViewModel.withdrawDatas objectAtIndex:indexPath.section]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.withdrawDatas)){
        WithdrawDetailModel *model = [_mViewModel.withdrawDatas objectAtIndex:indexPath.section];
        if(model.withdrawState == 3){
            [_mViewModel goWithdrawFailPage:model.withdrawId];
        }else{
            [_mViewModel goWithdrawSuccessPage:model.withdrawId];
        }
    }
}


-(void)onRequestBegin{
    
}

-(void)updateSuccessData:(id)data{
    int type = [data intValue];
    [self updateUI:type];
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.withdrawDatas)){
        [self updateHasDataUI];
    }
}



-(void)updateNoData:(int)type{
    [self updateUI:type];
    if(IS_NS_COLLECTION_EMPTY(_mViewModel.withdrawDatas)){
        [self updateNoDataUI];
    }else{
        [self updateHasDataUI];
    }
    
}


-(void)updateUI:(int)type{
    
    CGFloat height = 0;
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.withdrawDatas)){
        for(WithdrawDetailModel *model in _mViewModel.withdrawDatas){
            if(model.isPublic == 2){
                height += STHeight(238);
            }else{
                height += STHeight(238);
            }
        }
    }
    height += STHeight(15);
    _tableView.frame = CGRectMake(0, 0, ScreenWidth, height);
    _scrollView.frame = CGRectMake(0, 0, ScreenWidth, height);

    [_tableView reloadData];
    [_mViewModel.delegate onRefreshEnd];
    if(_mViewModel.delegate){
        [_mViewModel.delegate onUpdateUI:type count:[_mViewModel.withdrawDatas count]];
    }
}


//下拉刷新
-(void)refreshNew{
    [_mViewModel reqeustWithdrawList:YES];
}

//上拉加载更多
-(void)uploadMore{
    [_mViewModel reqeustWithdrawList:NO];
    
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



@end
