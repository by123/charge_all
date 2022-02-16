//
//  AgentManageView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "AgentManageView.h"
#import "TouchScrollView.h"
#import "AgentManageViewCell.h"

@interface AgentManageView()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic)AgentManageViewModel *mViewModel;
@property(strong, nonatomic)UITextField *textfield;
@property(strong, nonatomic)UITableView *tableView;
@property(strong, nonatomic)UIImageView *noDataImageView;
@property(strong, nonatomic)UILabel *noDataLabel;

@end

@implementation AgentManageView

-(instancetype)initWithViewModel:(AgentManageViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];
    }
    return self;
}

-(void)initView{
    self.userInteractionEnabled = YES;
    [self initSearch];
    [self initBody];
}

-(void)initSearch{
    
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, STHeight(42))];
    searchView.backgroundColor = cwhite;
    [self addSubview:searchView];
    
    _textfield = [[UITextField alloc]initWithFont:STFont(14) textColor:c10 backgroundColor:cbg corner:4 borderWidth:0 borderColor:nil padding:STWidth(39)];
    _textfield.placeholder = @"输入代理商名称";
    _textfield.delegate = self;
    _textfield.frame = CGRectMake(STWidth(15), STHeight(5), STWidth(345), STHeight(32));
    _textfield.returnKeyType = UIReturnKeySearch;
    _textfield.clearButtonMode=UITextFieldViewModeWhileEditing;
    [_textfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [searchView addSubview:_textfield];
    
    UIImageView *searchImageView =[[UIImageView alloc]initWithFrame:CGRectMake(STWidth(29), (STHeight(44) - STWidth(14))/2, STWidth(14), STWidth(14))];
    searchImageView.image = [UIImage imageNamed:IMAGE_SEARCH_SMALL];
    searchImageView.contentMode = UIViewContentModeScaleAspectFill;
    [searchView addSubview:searchImageView];
    
}

-(void)initBody{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, STHeight(42), ScreenWidth, ContentHeight - STHeight(42))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = cwhite;
    _tableView.scrollEnabled = YES;
    
    MJRefreshStateHeader *header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshNew)];
    header.lastUpdatedTimeLabel.hidden = YES;
    _tableView.mj_header= header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(uploadMore)];
    _tableView.mj_footer = footer;
    
    [_tableView useDefaultProperty];
    
    
    [self addSubview:_tableView];
    
    _noDataImageView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - STWidth(100))/2, STHeight(200), STWidth(100), STWidth(100))];
    _noDataImageView.image = [UIImage imageNamed:IMAGE_NO_DATA];
    _noDataImageView.hidden = YES;
    [self addSubview:_noDataImageView];
    
    NSString *noDataStr = @"暂无数据";
    _noDataLabel = [[UILabel alloc]initWithFont:STFont(16) text:noDataStr textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    _noDataLabel.frame = CGRectMake(0, STHeight(310), ScreenWidth, STHeight(22));
    _noDataLabel.hidden = YES;
    [self addSubview:_noDataLabel];
}

- (void)textFieldDidChange:(UITextField *)textField{
//    NSString *text = textField.text;
//    [_mViewModel requestAgentList:text refreshNew:YES];
}

-(void)updateView{
    [self refreshNew];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_mViewModel.merchantDatas count];
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return STHeight(15);
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return STHeight(144);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AgentManageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[AgentManageViewCell identify]];
    if(!cell){
        cell = [[AgentManageViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[AgentManageViewCell identify]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.merchantDatas)){
        [cell updateData:[_mViewModel.merchantDatas objectAtIndex:indexPath.section]];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_textfield resignFirstResponder];
    NSInteger position = indexPath.section;
    if(_mViewModel){
        [_mViewModel goAgentDetailPage:[_mViewModel.merchantDatas objectAtIndex:position]];
    }
}


-(void)onRequestSuccess:(RespondModel *)respondModel data:(id)data{
    [self updateHasDataUI];
    [self updateTableView];
}

-(void)onRequestFail:(NSString *)msg{
    [self updateTableView];
}

-(void)onRequestNoData:(Boolean)hasDatas{
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
    [_tableView setContentSize:CGSizeMake(ScreenWidth, STHeight(159) * [_mViewModel.merchantDatas count] + STHeight(15))];
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_textfield resignFirstResponder];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_textfield resignFirstResponder];
}


//下拉刷新
-(void)refreshNew{
    [_mViewModel requestAgentList:_textfield.text refreshNew:YES];
}

//上拉加载更多
-(void)uploadMore{
    [_mViewModel requestAgentList:_textfield.text refreshNew:NO];
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(_mViewModel){
        [textField resignFirstResponder];
        [self refreshNew];
    }
    return YES;
}

@end

