//
//  BankDetailView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "BankDetailView.h"
#import "BankDetailViewCell.h"

@interface BankDetailView()<UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic)BankDetailViewModel *mViewModel;
@property(strong, nonatomic)UITableView *tableView;

@end

@implementation BankDetailView

-(instancetype)initWithViewModel:(BankDetailViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];
    }
    return self;
}

-(void)initView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, _mViewModel.datas.count * STHeight(50))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView useDefaultProperty];
    
    [self addSubview:_tableView];
    
    UILabel *tipsLabel = [[UILabel alloc]initWithFont:STFont(12) text:MSG_UPDATE_BANK_TIPS textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize tipsSize = [tipsLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(12)];
    tipsLabel.frame = CGRectMake(STWidth(15), STHeight(10) + _mViewModel.datas.count * STHeight(50), tipsSize.width, STHeight(30));
    [self addSubview:tipsLabel];
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
    BankDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[BankDetailViewCell identify]];
    if(!cell){
        cell = [[BankDetailViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[BankDetailViewCell identify]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.datas)){
        [cell updateData:[_mViewModel.datas objectAtIndex:indexPath.row]];
    }
    return cell;
}


-(void)updateView{
    
}

@end

