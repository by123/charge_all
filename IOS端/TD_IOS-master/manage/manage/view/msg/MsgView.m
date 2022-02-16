//
//  MsgView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "MsgView.h"
#import "MsgViewCell.h"
@interface MsgView()<UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic)MsgViewModel *mViewModel;
@property(strong, nonatomic)UITableView *tableView;
@property(strong, nonatomic)UIImageView *noDataImageView;
@property(strong, nonatomic)UILabel *noDataLabel;

@end

@implementation MsgView

-(instancetype)initWithViewModel:(MsgViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];
    }
    return self;
}

-(void)initView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ContentHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView useDefaultProperty];
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNew)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(uploadMore)];
    _tableView.mj_footer = footer;
    
    [self addSubview:_tableView];
    
    _noDataImageView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - STWidth(100))/2, STHeight(70), STWidth(100), STWidth(100))];
    _noDataImageView.image = [UIImage imageNamed:IMAGE_MSG_NONE];
    _noDataImageView.hidden = YES;
    [self addSubview:_noDataImageView];
    
    NSString *noDataStr = @"暂无消息";
    _noDataLabel = [[UILabel alloc]initWithFont:STFont(16) text:noDataStr textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    _noDataLabel.frame = CGRectMake(0, STHeight(180), ScreenWidth, STHeight(22));
    _noDataLabel.hidden = YES;
    [self addSubview:_noDataLabel];
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_mViewModel.datas count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return STHeight(118);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MsgViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MsgViewCell identify]];
    if(!cell){
        cell = [[MsgViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MsgViewCell identify]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.datas)){
        [cell updateData:[_mViewModel.datas objectAtIndex:indexPath.row]];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MsgModel *model = [_mViewModel.datas objectAtIndex:indexPath.row];
    [_mViewModel goMsgDetailPage:model.msgId];
}


-(void)updateView{
    [self updateHasDataUI];
    [self updateTableView];
}

-(void)updateNoDatas:(Boolean)hasDatas{
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
    [_tableView setContentSize:CGSizeMake(ScreenWidth,[_mViewModel.datas count] * STHeight(118))];
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

-(void)refreshNew{
    [_mViewModel requestMsgList:YES];
}

-(void)uploadMore{
    [_mViewModel requestMsgList:NO];
}

@end

