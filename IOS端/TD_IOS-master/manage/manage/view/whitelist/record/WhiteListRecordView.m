//
//  WhiteListRecordView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "WhiteListRecordView.h"
#import "WTRecordCell.h"
#import "AccountManager.h"

@interface WhiteListRecordView()<UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic)UIView *noDataView;
@property(strong, nonatomic)WhiteListRecordViewModel *mViewModel;
@property(strong, nonatomic)UITableView *tableView;
@property(strong, nonatomic)UIButton *addBtn;

@end

@implementation WhiteListRecordView

-(instancetype)initWithViewModel:(WhiteListRecordViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];
    }
    return self;
}

-(void)initView{
    [self initBodyView];
    [self initNoDataView];
}

-(void)initBodyView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ContentHeight-STHeight(50))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView useDefaultProperty];
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNew)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(uploadMore)];
    _tableView.mj_footer = footer;
    
    [self addSubview:_tableView];
    
    _addBtn = [[UIButton alloc]initWithFont:STFont(18) text:@"添加白名单" textColor:c_btn_txt_highlight backgroundColor:c01 corner:0 borderWidth:0 borderColor:nil];
    _addBtn.frame = CGRectMake(0, ContentHeight - STHeight(50), ScreenWidth, STHeight(50));
    [_addBtn addTarget:self action:@selector(onAddWhiteListBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addBtn];
}

-(void)initNoDataView{
    _noDataView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ContentHeight)];
    _noDataView.hidden = YES;
    [self addSubview:_noDataView];
    
    UIImageView *noDataImageView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - STWidth(100))/2, STHeight(70), STWidth(100), STWidth(100))];
    noDataImageView.image = [UIImage imageNamed:IMAGE_NO_WHITELIST];
    noDataImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_noDataView addSubview:noDataImageView];
    
    UILabel *noDataLabel = [[UILabel alloc]initWithFont:STFont(16) text:@"您当前还没有邀请过白名单客户" textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    noDataLabel.frame = CGRectMake(0, STHeight(180), ScreenWidth, STHeight(22));
    [_noDataView addSubview:noDataLabel];
    
    UIButton *addWhiteListBtn = [[UIButton alloc]initWithFont:STFont(18) text:@"添加白名单" textColor:c_btn_txt_highlight backgroundColor:c01 corner:2 borderWidth:0 borderColor:nil];
    if (@available(iOS 11.0, *)) {
        addWhiteListBtn.frame = CGRectMake(STWidth(15), ContentHeight - STHeight(110) - HomeIndicatorHeight, STWidth(345), STHeight(50));
    } else {
        addWhiteListBtn.frame = CGRectMake(STWidth(15), ContentHeight - STHeight(110), STWidth(345), STHeight(50));
    }
    [addWhiteListBtn addTarget:self action:@selector(onAddWhiteListBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_noDataView addSubview:addWhiteListBtn];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_mViewModel.recordDatas count];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return STHeight(15);
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return STHeight(140);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WTRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:[WTRecordCell identify]];
    if(!cell){
        cell = [[WTRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[WTRecordCell identify]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.recordDatas)){
        [cell updateData:[_mViewModel.recordDatas objectAtIndex:indexPath.section]];
        
        cell.changeBtn.tag = indexPath.section;
        [cell.changeBtn addTarget:self action:@selector(onChangeBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.editBtn.tag = indexPath.section;
        [cell.editBtn addTarget:self action:@selector(onEditBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.cpBtn.tag = indexPath.section;
        [cell.cpBtn addTarget:self action:@selector(onCopyBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

//点击启用/禁用
-(void)onChangeBtnSelect:(id)sender{
    NSInteger position = ((UIButton *)sender).tag;
    WTRecordModel *model = [_mViewModel.recordDatas objectAtIndex:position];
    if(_mViewModel){
        [_mViewModel doChangeState:model];
    }
}

//点击编辑
-(void)onEditBtnSelect:(id)sender{
    NSInteger position = ((UIButton *)sender).tag;
    WTRecordModel *model = [_mViewModel.recordDatas objectAtIndex:position];
    if(_mViewModel){
        UserModel *userModel = [[AccountManager sharedAccountManager]getUserModel];
        [_mViewModel doEditScope:userModel.mchId model:model];
    }
}

//点击复制
-(void)onCopyBtnSelect:(id)sender{
    NSInteger position = ((UIButton *)sender).tag;
    WTRecordModel *model = [_mViewModel.recordDatas objectAtIndex:position];
    if(_mViewModel){
        [_mViewModel doCopy:model];
    }
}


-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    [self updateUI];
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.recordDatas)){
        [self updateHasDataUI];
    }
    
}

-(void)onRequestNoData{
    [self updateUI];
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshingWithNoMoreData];
    if(IS_NS_COLLECTION_EMPTY(_mViewModel.recordDatas)){
        [self updateNoDataUI];
    }else{
        [self updateHasDataUI];
    }
    
}


-(void)updateUI{
    [_tableView setContentSize:CGSizeMake(ScreenWidth, STHeight(155) * [_mViewModel.recordDatas count] + STHeight(15))];
    [_tableView reloadData];
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];

}


//下拉刷新
-(void)refreshNew{
    [_mViewModel requestRecordList:YES];
}

//上拉加载更多
-(void)uploadMore{
    [_mViewModel requestRecordList:NO];
}



-(void)updateNoDataUI{
    _tableView.hidden = YES;
    _noDataView.hidden = NO;
    _addBtn.hidden = YES;
}

-(void)updateHasDataUI{
    _tableView.hidden = NO;
    _noDataView.hidden = YES;
    _addBtn.hidden = NO;
}




-(void)onAddWhiteListBtnClick{
    if(_mViewModel){
        [_mViewModel goWhiteListPage];
    }
}



-(void)updateView{
    [_tableView reloadData];
}

@end

