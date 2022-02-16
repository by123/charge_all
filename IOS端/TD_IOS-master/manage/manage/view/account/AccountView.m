//
//  AccountView.m
//  manage
//
//  Created by by.huang on 2018/10/27.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "AccountView.h"
#import "TitleContentModel.h"
#import "AccountCell.h"
#import "STTimeUtil.h"
#import "AccountManager.h"

@interface AccountView()<UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic)UITableView *merchantTableView;
@property(strong, nonatomic)NSMutableArray *merchantDatas;
@property(strong, nonatomic)AccountViewModel *mViewModel;


@end

@implementation AccountView

-(instancetype)initWithViewModel:(AccountViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        _merchantDatas =[[NSMutableArray alloc]init];
    }
    return self;
}

-(void)initView{
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame = CGRectMake(0, 0, ScreenWidth, ContentHeight);
    [self addSubview:scrollView];
    
    NSString *infoStr = @"商户信息";
    UILabel *infoLabel = [[UILabel alloc]initWithFont:STFont(14) text:infoStr textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize infoSize = [infoStr sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    infoLabel.frame = CGRectMake(STWidth(15), STHeight(20), infoSize.width, STHeight(20));
    [scrollView addSubview:infoLabel];
    
    
    _merchantTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, STHeight(44), ScreenWidth, _merchantDatas.count* STHeight(52))];
    _merchantTableView.delegate = self;
    _merchantTableView.dataSource = self;
    [_merchantTableView setScrollEnabled:NO];
    [_merchantTableView useDefaultProperty];
    
    [scrollView addSubview:_merchantTableView];
    
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_merchantDatas count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return STHeight(52);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AccountCell *cell = [tableView dequeueReusableCellWithIdentifier:[AccountCell identify]];
    if(!cell){
        cell = [[AccountCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[AccountCell identify]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell updateData:[_merchantDatas objectAtIndex:indexPath.row]];
    return cell;
}


-(void)updateData{
    
    UserModel *model = [[AccountManager sharedAccountManager]getUserModel];
    
    [_merchantDatas removeAllObjects];
    
    if(model.roleType == 2 || model.roleType == 3){
        [_merchantDatas addObject:[TitleContentModel buildModel:@"用户姓名" content:model.name]];
        [_merchantDatas addObject:[TitleContentModel buildModel:@"用户电话" content:model.mobile]];
        [_merchantDatas addObject:[TitleContentModel buildModel:@"账号创建日期" content:[STTimeUtil generateAll:[NSString stringWithFormat:@"%ld",model.createTime]]]];
        
    }else{
        [_merchantDatas addObject:[TitleContentModel buildModel:@"代理商类型" content:[UserModel getMechantName:model.mchType level:model.level]]];
        [_merchantDatas addObject:[TitleContentModel buildModel:@"代理商编号" content:model.mchId]];
        [_merchantDatas addObject:[TitleContentModel buildModel:@"代理商名称" content:model.mchName]];
        [_merchantDatas addObject:[TitleContentModel buildModel:@"代理商姓名" content:model.contactUser]];
        [_merchantDatas addObject:[TitleContentModel buildModel:@"代理商电话" content:model.contactPhone]];
        [_merchantDatas addObject:[TitleContentModel buildModel:@"位置地域" content:[NSString stringWithFormat:@"%@%@%@%@",IS_NS_STRING_EMPTY(model.province) ? MSG_EMPTY : model.province, IS_NS_STRING_EMPTY(model.city) ? MSG_EMPTY :model.city,
            IS_NS_STRING_EMPTY(model.area) ? MSG_EMPTY :model.area,
            IS_NS_STRING_EMPTY(model.detailAddr) ? MSG_EMPTY :model.detailAddr]]];
        [_merchantDatas addObject:[TitleContentModel buildModel:@"结算周期" content:[NSString stringWithFormat:@"T+%d",model.settementPeriod]]];
        [_merchantDatas addObject:[TitleContentModel buildModel:@"创建日期" content:[STTimeUtil generateDate:[NSString stringWithFormat:@"%ld",model.createTime] format:MSG_TIME_FORMAT]]];
        
    }

    [self initView];

}

@end
