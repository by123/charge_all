//
//  BankSelectView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "BankSelectView.h"
#import "BankSelectViewCell.h"
#import "BankModel.h"
@interface BankSelectView()<UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic)UITableView *tableView;
@property(strong, nonatomic)NSMutableArray *datas;
@property(strong, nonatomic)BankSelectPage *page;

@end

@implementation BankSelectView

-(instancetype)initWithDatas:(NSMutableArray *)datas page:(BankSelectPage *)page{
    if(self == [super init]){
        _datas = datas;
        _page = page;
        [self initView];
    }
    return self;
}


-(void)initView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ContentHeight-STHeight(50))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView useDefaultProperty];
    [self addSubview:_tableView];
    

    UIButton *addBtn = [[UIButton alloc]initWithFont:STFont(18) text:MSG_ADD_BK textColor:c_btn_txt_highlight backgroundColor:c01 corner:0 borderWidth:0 borderColor:nil];
    [addBtn setBackgroundColor:c02 forState:UIControlStateHighlighted];
    addBtn.frame = CGRectMake(0, ContentHeight- STHeight(50), ScreenWidth, STHeight(50));
    [addBtn addTarget:self action:@selector(onAddClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addBtn];
    if([BankModel hasAllType:_datas]){
        addBtn.hidden = YES;
    }

}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_datas count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return STHeight(10);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!IS_NS_COLLECTION_EMPTY(_datas)){
        BankModel *model = [_datas objectAtIndex:indexPath.section];
        if(IS_NS_STRING_EMPTY(model.headUrl)){
            return STHeight(114);
        }
        return STHeight(90);
    }
    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BankSelectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[BankSelectViewCell identify]];
    if(!cell){
        cell = [[BankSelectViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[BankSelectViewCell identify]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(!IS_NS_COLLECTION_EMPTY(_datas)){
        [cell updateData:[_datas objectAtIndex:indexPath.section]];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BankModel *model = [_datas objectAtIndex:indexPath.section];
    if(model.isSelect){
        return;
    }
    [_datas enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BankModel *temp = obj;
        temp.isSelect = NO;
        if([model.bankId isEqualToString:temp.bankId]){
            model.isSelect = YES;
        }
    }];

    [_tableView reloadData];
}


-(void)onAddClick{
    if(_page){
        [_page goAddBankHomePage];
    }
}



@end

