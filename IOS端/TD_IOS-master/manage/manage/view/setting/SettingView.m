//
//  SettingView.m
//  manage
//
//  Created by by.huang on 2018/11/6.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "SettingView.h"
#import "SettingViewCell.h"

@interface SettingView()<UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic)SettingViewModel *mViewModel;
@property(strong, nonatomic)UITableView *tableView;
@property(strong, nonatomic)UIButton *logoutBtn;

@end

@implementation SettingView{
    NSArray *titles;
}

-(instancetype)initWithViewModel:(SettingViewModel *)viewModel{
    if(self == [self init]){
        _mViewModel = viewModel;
        [self initView];
    }
    return self;
}

-(void)initView{
    
    titles = @[@"修改密码",@"关于我们"];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, STHeight(15), ScreenWidth, titles.count * STHeight(50))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView useDefaultProperty];
    
    [self addSubview:_tableView];
    
    
    _logoutBtn = [[UIButton alloc]initWithFont:STFont(15) text:@"退出登录" textColor:c10 backgroundColor:cwhite corner:0 borderWidth:0 borderColor:nil];
    _logoutBtn.frame = CGRectMake(0, titles.count * STHeight(50) + STHeight(55), ScreenWidth, STHeight(50));
    [_logoutBtn addTarget:self action:@selector(doLogout) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_logoutBtn];

}





-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [titles count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return STHeight(50);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SettingViewCell identify]];
    if(!cell){
        cell = [[SettingViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[SettingViewCell identify]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(!IS_NS_COLLECTION_EMPTY(titles)){
        if(indexPath.row == titles.count - 1){
            [cell updateData:[titles objectAtIndex:indexPath.row] line:YES];
        }else{
            [cell updateData:[titles objectAtIndex:indexPath.row] line:NO];
        }
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_mViewModel){
        NSInteger row = indexPath.row;
        if(row == 0){
           [_mViewModel goUpdatePswPage];
        }else if(row == 1){
           [_mViewModel goAboutPage];
        }
    }
}

-(void)doLogout{
    if(_mViewModel){
        [_mViewModel doLogout];
    }
}

@end
