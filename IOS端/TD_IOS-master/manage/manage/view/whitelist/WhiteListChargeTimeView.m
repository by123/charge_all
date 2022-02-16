//
//  WhiteListChargeTimeView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "WhiteListChargeTimeView.h"
#import "WhiteListChargeTimeCell.h"
#import "STObserverManager.h"

@interface WhiteListChargeTimeView()<UITableViewDataSource,UITableViewDelegate>

@property(strong, nonatomic)WhiteListChargeTimeViewModel *mViewModel;
@property(strong, nonatomic)UITableView *tableView;

@end

@implementation WhiteListChargeTimeView

-(instancetype)initWithViewModel:(WhiteListChargeTimeViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];
    }
    return self;
}

-(void)initView{
    [self initTableView];
    
    UIButton *confirmBtn = [[UIButton alloc]initWithFont:STFont(18) text:MSG_CONFIRM textColor:c_btn_txt_normal backgroundColor:c24 corner:0 borderWidth:0 borderColor:nil];
    confirmBtn.frame = CGRectMake(0, ContentHeight - STHeight(50), ScreenWidth, STHeight(50));
    [confirmBtn addTarget:self action:@selector(onConfirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
}


/********************** tableview ****************************/
-(void)initTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ContentHeight-STHeight(50))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView useDefaultProperty];
    [self addSubview:_tableView];
    
    [_tableView reloadData];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_mViewModel.datas count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return STHeight(50);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WhiteListChargeTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:[WhiteListChargeTimeCell identify]];
    if(!cell){
        cell = [[WhiteListChargeTimeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[WhiteListChargeTimeCell identify]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.datas)){
        [cell updateData:[_mViewModel.datas objectAtIndex:indexPath.row]];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.datas)){
        [_mViewModel.datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WTChargeTimeModel *model = obj;
            model.isSelect = NO;
        }];
        WTChargeTimeModel *model = [_mViewModel.datas objectAtIndex:indexPath.row];
        model.isSelect = YES;
        [_tableView reloadData];
    }
}


-(void)updateView{
    [_tableView reloadData];
}


/********************** tableview ****************************/


-(void)onConfirmBtnClick{
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.datas)){
        for(WTChargeTimeModel *model in _mViewModel.datas){
            if(model.isSelect){
                NSString *msg = [NSString stringWithFormat:@"%@|%d",model.time,model.scale];
                [[STObserverManager sharedSTObserverManager] sendMessage:(_mViewModel.type == WhiteListType_Create) ? NOTIFY_UPDATE_WHITELIST_TIME :NOTIFY_UPDATE_WHITELIST_EDIT_TIME  msg:msg];
                [_mViewModel goBack];
                break;
            }
        }
    }
}

@end

