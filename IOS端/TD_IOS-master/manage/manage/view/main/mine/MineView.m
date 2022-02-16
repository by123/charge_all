//
//  MineView.m
//  manage
//
//  Created by by.huang on 2018/10/26.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "MineView.h"
#import "MineCell.h"
#import "AccountManager.h"
#import "STUserDefaults.h"
#import "ZScrollLabel.h"





#import "STNetUtil.h"

@interface MineView()<UITableViewDataSource,UITableViewDelegate>

@property(strong, nonatomic)MainViewModel *mViewModel;
@property(strong, nonatomic)UITableView *tableView;
@property(strong, nonatomic)NSMutableArray *titles;
@property(strong, nonatomic)NSMutableArray *imageSrcs;

@end

@implementation MineView

-(instancetype)initWithViewModel:(MainViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        if(IS_YELLOW_SKIN){
            [self initWhiteListMenu];
        }else{
            [self initMenu];
        }
        [self initView];
    }
    return self;
}


-(void)initWhiteListMenu{
    UserModel *model = [[AccountManager sharedAccountManager]getUserModel];
    if(model.roleType == 2 || model.roleType == 3){
        _titles = [NSMutableArray arrayWithArray: @[MENU_ACCOUNT,MENU_AGENT_MANAGE,MENU_UNBINDING,MENU_WHITELIST,MENU_MESSAGE,MENU_SETTING]];
        _imageSrcs=  [NSMutableArray arrayWithArray:@[IMAGE_ACCOUNT,IMAGE_AGENT_MANAGE,IMAGE_UNBINDING,IMAGE_WHITELIST,IMAGE_MSG_CENTER,IMAGE_SETTING]];
    }else{
        _titles =  [NSMutableArray arrayWithArray:@[MENU_ACCOUNT,MENU_BANK_INFO,MENU_AGENT_MANAGE,MENU_UNBINDING,MENU_WHITELIST,MENU_MESSAGE,MENU_SETTING]];
        _imageSrcs=  [NSMutableArray arrayWithArray:@[IMAGE_ACCOUNT,IMAGE_BANK_INFO,IMAGE_AGENT_MANAGE,IMAGE_UNBINDING,IMAGE_WHITELIST,IMAGE_MSG_CENTER,IMAGE_SETTING]];
        //设置
        NSString *setting = [STUserDefaults getKeyValue:UD_SETTING];
        if([setting isEqualToString:LIMIT_CLOSE]){
            _titles =  [NSMutableArray arrayWithArray:@[MENU_ACCOUNT,MENU_AGENT_MANAGE,MENU_UNBINDING,MENU_WHITELIST,MENU_MESSAGE,MENU_SETTING]];
            _imageSrcs=  [NSMutableArray arrayWithArray:@[IMAGE_ACCOUNT,IMAGE_AGENT_MANAGE,IMAGE_UNBINDING,IMAGE_WHITELIST,IMAGE_MSG_CENTER,IMAGE_SETTING]];
        }
    }
}

-(void)initMenu{
    UserModel *model = [[AccountManager sharedAccountManager]getUserModel];
    if(model.roleType == 2 || model.roleType == 3){
        _titles = [NSMutableArray arrayWithArray:@[MENU_ACCOUNT,MENU_AGENT_MANAGE,MENU_UNBINDING,MENU_MESSAGE,MENU_SETTING]];
        _imageSrcs= [NSMutableArray arrayWithArray:@[IMAGE_ACCOUNT,IMAGE_AGENT_MANAGE,IMAGE_UNBINDING,IMAGE_MSG_CENTER,IMAGE_SETTING]];
    }else{
        _titles = [NSMutableArray arrayWithArray:@[MENU_ACCOUNT,MENU_BANK_INFO,MENU_AGENT_MANAGE,MENU_UNBINDING,MENU_MESSAGE,MENU_SETTING]];
        _imageSrcs= [NSMutableArray arrayWithArray:@[IMAGE_ACCOUNT,IMAGE_BANK_INFO,IMAGE_AGENT_MANAGE,IMAGE_UNBINDING,IMAGE_MSG_CENTER,IMAGE_SETTING]];
        //设置
        NSString *setting = [STUserDefaults getKeyValue:UD_SETTING];
        if([setting isEqualToString:LIMIT_CLOSE]){
            _titles = [NSMutableArray arrayWithArray:@[MENU_ACCOUNT,MENU_AGENT_MANAGE,MENU_UNBINDING,MENU_MESSAGE,MENU_SETTING]];
            _imageSrcs= [NSMutableArray arrayWithArray:@[IMAGE_ACCOUNT,IMAGE_AGENT_MANAGE,IMAGE_UNBINDING,IMAGE_MSG_CENTER,IMAGE_SETTING]];
        }
    }
}

-(void)initView{
    UILabel *homeLabel = [[UILabel alloc]initWithFont:STFont(30) text:TAB_MINE textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize findPswSize = [TAB_MINE sizeWithMaxWidth:ScreenWidth font:STFont(30)];
    [homeLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(30)]];
    homeLabel.frame = CGRectMake(STWidth(15), STHeight(10), findPswSize.width, STHeight(42));
    [self addSubview:homeLabel];
    
    UserModel *userModel = [[AccountManager sharedAccountManager]getUserModel];

    NSString *nameStr = userModel.mchName;
    if(userModel.roleType == 2 || userModel.roleType == 3){
        nameStr = userModel.name;
    }
    
    ZScrollLabel *nameLabel = [[ZScrollLabel alloc] initWithFrame:CGRectMake(STWidth(15), STHeight(74), STWidth(270), STHeight(28))];
    nameLabel.textColor = c10;
    nameLabel.labelAlignment = ZScrollLabelAlignmentLeft;
    nameLabel.font = [UIFont fontWithName:FONT_MIDDLE size:STFont(20)];
    nameLabel.text = nameStr;
    
    [self addSubview:nameLabel];
    
    
    NSString *accountStr = [NSString stringWithFormat:@"账号：%@",userModel.userId];
    if(userModel.roleType == 2 || userModel.roleType == 3){
        accountStr = [NSString stringWithFormat:@"账号：%@",userModel.mobile];
    }
    UILabel *accountLabel = [[UILabel alloc]initWithFont:STFont(15) text:accountStr textAlignment:NSTextAlignmentLeft textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize accountSize = [accountStr sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    accountLabel.frame = CGRectMake(STWidth(15), STHeight(106), accountSize.width, STHeight(21));
    [self addSubview:accountLabel];
    
    UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - STWidth(75), STHeight(67), STWidth(60), STWidth(60))];
//    headImageView.layer.masksToBounds = YES;
//    headImageView.layer.cornerRadius = STWidth(30);
    headImageView.image = [UIImage imageNamed:IMAGE_HEAD];
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
//    headImageView.backgroundColor = c11;
    [self addSubview:headImageView];
    
    CGFloat homeHeight = 0;
    if (@available(iOS 11.0, *)) {
        homeHeight = HomeIndicatorHeight;
    } else {
        homeHeight = 0;
    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, STHeight(132), ScreenWidth, ScreenHeight - STHeight(182) - homeHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView useDefaultProperty];
    
    [self addSubview:_tableView];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_titles count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return STHeight(62);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MineCell *cell = [tableView dequeueReusableCellWithIdentifier:[MineCell identify]];
    if(!cell){
        cell = [[MineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MineCell identify]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell updateData:_titles[indexPath.row] imgSrc:_imageSrcs[indexPath.row]];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    if(_mViewModel){
        if(!IS_NS_COLLECTION_EMPTY(_titles)){
            NSString *tempStr = _titles[row];
            if([tempStr isEqualToString:MENU_ACCOUNT]){[_mViewModel goAccountDetail]; return;}
            if([tempStr isEqualToString:MENU_BANK_INFO]){[_mViewModel goBankDetail]; return;}
            if([tempStr isEqualToString:MENU_AGENT_MANAGE]){[_mViewModel goAgentManagePage]; return;}
            if([tempStr isEqualToString:MENU_UNBINDING]){[_mViewModel goUnBindingPage]; return;}
            if([tempStr isEqualToString:MENU_WHITELIST]){[_mViewModel goWhiteListPage]; return;}
            if([tempStr isEqualToString:MENU_MESSAGE]){[_mViewModel goMsgPage]; return;}
            if([tempStr isEqualToString:MENU_SETTING]){[_mViewModel goSettingPage]; return;}

            
        }
    }

}


-(void)updateView{
    
}

@end
