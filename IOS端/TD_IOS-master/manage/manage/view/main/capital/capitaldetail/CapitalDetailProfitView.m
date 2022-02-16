//
//  CapitalDetailProfitView.m
//  manage
//
//  Created by by.huang on 2019/1/17.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "CapitalDetailProfitView.h"
#import "CapitalDetailProfitCell.h"

@interface CapitalDetailProfitView()<UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic)CapitalDetailViewModel *mViewModel;
@property(strong, nonatomic)UITableView *tableView;
@property(strong, nonatomic)UIImageView *noDataImageView;
@property(strong, nonatomic)UILabel *noDataLabel;

@end

@implementation CapitalDetailProfitView

-(instancetype)initWithViewModel:(CapitalDetailViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];
    }
    return self;
}

-(void)initView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.frame.size.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [_tableView useDefaultProperty];
    [self addSubview:_tableView];
    
    _noDataImageView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - STWidth(100))/2, STHeight(60), STWidth(100), STWidth(100))];
    _noDataImageView.image = [UIImage imageNamed:IMAGE_NO_DATA];
    _noDataImageView.hidden = YES;
    [self addSubview:_noDataImageView];
    
    NSString *noDataStr = @"暂无数据";
    _noDataLabel = [[UILabel alloc]initWithFont:STFont(16) text:noDataStr textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    _noDataLabel.frame = CGRectMake(0, STHeight(60)+ STWidth(120), ScreenWidth, STHeight(22));
    _noDataLabel.hidden = YES;
    [self addSubview:_noDataLabel];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_mViewModel.profitDatas count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return STHeight(75);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CapitalDetailProfitCell *cell = [tableView dequeueReusableCellWithIdentifier:[CapitalDetailProfitCell identify]];
    if(!cell){
        cell = [[CapitalDetailProfitCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[CapitalDetailProfitCell identify]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.profitDatas)){
        [cell updateData:[_mViewModel.profitDatas objectAtIndex:indexPath.row]];
    }
    return cell;
}

-(void)updateView{
    if(IS_NS_COLLECTION_EMPTY(_mViewModel.profitDatas)){
        _noDataImageView.hidden = NO;
        _noDataLabel.hidden = NO;
        _tableView.hidden = YES;
    }else{
        _noDataImageView.hidden = YES;
        _noDataLabel.hidden = YES;
        _tableView.hidden = NO;
        _tableView.frame = CGRectMake(0, 0, ScreenWidth, _mViewModel.profitDatas.count * STHeight(75));
        [_tableView reloadData];
    }
}



@end
