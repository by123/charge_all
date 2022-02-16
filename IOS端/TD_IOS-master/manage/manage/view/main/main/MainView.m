//
//  MainView.m
//  bus
//
//  Created by by.huang on 2018/9/13.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "MainView.h"
#import "STTitleButton.h"
#import "STMainRectButton.h"
#import "AccountManager.h"
#import "TouchScrollView.h"
#import "STNumUtil.h"
#import "NewYearView.h"
#import "STUserDefaults.h"



@interface MainView()<TouchScrollViewDelegate,NewYearViewDelegate>

@property(strong, nonatomic)MainViewModel *mViewModel;
@property(strong, nonatomic)NSMutableArray *buttons;
@property(strong, nonatomic)TouchScrollView *scrollView;
@property(strong, nonatomic)NewYearView *mNewYearView;
@property(strong, nonatomic)NSMutableArray *itemButtons;
@property(strong, nonatomic)NSMutableArray *menus;
@property(strong, nonatomic)NSMutableArray *menuSrcs;
@property(strong, nonatomic)UIView *redPoint;

@end

@implementation MainView{
    CGFloat NewYearHeight;

}

-(instancetype)initWithViewModel:(MainViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        _buttons =[[NSMutableArray alloc]init];
        _itemButtons = [[NSMutableArray alloc]init];
        _menus = [[NSMutableArray alloc]init];
        _menuSrcs = [[NSMutableArray alloc]init];
        NewYearHeight =0;
        [self initView];
    }
    return self;
}

-(void)initView{
    
//    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, STHeight(44))];
//    bgView.backgroundColor = c02;
//    [self addSubview:bgView];
    
    [self initTopView];
    [self initBodyView];
    
}

-(void)initTopView{
    
//    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, STHeight(138))];
//    bgImageView.image = [UIImage imageNamed:@"bg_密码页头部"];
//    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
//    [self addSubview:bgImageView];
    
    NSString *homeStr = TAB_HOME;
    UILabel *homeLabel = [[UILabel alloc]initWithFont:STFont(30) text:homeStr textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize findPswSize = [homeStr sizeWithMaxWidth:ScreenWidth font:STFont(30) fontName:FONT_MIDDLE];
    [homeLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(30)]];
    homeLabel.frame = CGRectMake(STWidth(15), STHeight(10), findPswSize.width, STHeight(42));
    [self addSubview:homeLabel];
    
    
    //隐藏功能
    UIButton *msgBtn = [[UIButton alloc]init];
    [msgBtn setImage:[UIImage imageNamed:IMAGE_MSG_ENTER] forState:UIControlStateNormal];
    msgBtn.frame = CGRectMake(ScreenWidth - STWidth(82), STHeight(21), STWidth(20), STWidth(20));
    [msgBtn addTarget:self action:@selector(onMsgBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:msgBtn];
    
    _redPoint = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth - STWidth(69), STHeight(18), STWidth(8), STWidth(8))];
    _redPoint.backgroundColor = c13;
    _redPoint.layer.masksToBounds = YES;
    _redPoint.layer.cornerRadius = STWidth(4);
    _redPoint.hidden = YES;
    [self addSubview:_redPoint];
    
    [self updateNewMsg];

    
    UIButton *scanBtn = [[UIButton alloc]init];
    [scanBtn setImage:[UIImage imageNamed:IMAGE_SCAN] forState:UIControlStateNormal];
    scanBtn.frame = CGRectMake(ScreenWidth - STWidth(40), STHeight(21), STWidth(20), STWidth(20));
    [scanBtn addTarget:self action:@selector(onScanBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:scanBtn];
    
    
}

-(void)initFestivalView{
    _mNewYearView = [[NewYearView alloc]init];
    _mNewYearView.delegate = self;
    _mNewYearView.frame = CGRectMake(STWidth(23), STHeight(192+15), STWidth(330), STHeight(40));
    _mNewYearView.hidden = YES;
    [_scrollView addSubview:_mNewYearView];
}

-(void)onCloseNewYearView{
    NewYearHeight = 0;
    _mNewYearView.hidden = YES;
    [self updateNewYearView];
}

-(void)updateNewYearView{
    _scrollView.contentSize = CGSizeMake(ScreenWidth, STHeight(192) + STHeight(97) * 5 + STHeight(15) + NewYearHeight);
    WS(weakSelf)
    [UIView animateWithDuration:0.3f animations:^{
        if(!IS_NS_COLLECTION_EMPTY(weakSelf.itemButtons)){
            for(int i= 0 ; i < weakSelf.itemButtons.count ; i++){
                STMainRectButton *button = [weakSelf.itemButtons objectAtIndex:i];
                button.frame = CGRectMake(STWidth(15), STHeight(207)+  STHeight(97)* i + self->NewYearHeight, STWidth(345), STHeight(82));
            }
        }
    }];

}

-(void)initBodyView{
    CGFloat homeHeight = 0;
    if (@available(iOS 11.0, *)) {
        homeHeight = HomeIndicatorHeight;
    } else {
        homeHeight = 0;
    }
    
    _scrollView = [[TouchScrollView alloc]initWithParentView:self delegate:self];
    _scrollView.frame = CGRectMake(0, STHeight(66), ScreenWidth, ScreenHeight- StatuBarHeight -  STHeight(116) - homeHeight);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [_scrollView enableHeader];
    [self addSubview:_scrollView];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(2), STWidth(345), STHeight(192))];
    topView.backgroundColor = cwhite;
    topView.layer.shadowOffset = CGSizeMake(1, 1);
    topView.layer.shadowOpacity = 0.8;
    topView.layer.shadowColor = c03.CGColor;
    topView.layer.cornerRadius = 2;
    [_scrollView addSubview:topView];
    
    NSString *infoStr = @"我的业绩";
    UILabel *infoLabel = [[UILabel alloc]initWithFont:STFont(18) text:infoStr textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize infoSize = [infoStr sizeWithMaxWidth:ScreenWidth font:STFont(18) fontName:FONT_MIDDLE];
    [infoLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(18)]];
    infoLabel.frame = CGRectMake(STWidth(15), STHeight(20), infoSize.width, STHeight(25));
    [topView addSubview:infoLabel];
    
    NSArray *titles = @[@"0",@"0",@"0",@"0",@"0",@"0"];
    NSArray *contents = @[@"今日开发商户",@"今日激活设备",@"今日设备收益",@"开发商户总数",@"激活设备总数",@"设备总收益"];
    
    
    UIButton *achieveBtn = [[UIButton alloc]initWithFrame:CGRectMake(STWidth(250), STHeight(22), STWidth(90), STHeight(21))];
    [achieveBtn addTarget:self action:@selector(onAchieveClicked) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:achieveBtn];
    
    UILabel *achieveLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"业绩明细" textAlignment:NSTextAlignmentLeft textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize achieveSize = [achieveLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    achieveLabel.frame = CGRectMake(0, 0, achieveSize.width, STHeight(21));
    [achieveBtn addSubview:achieveLabel];
    
    UIImageView *achieveImageView = [[UIImageView alloc]initWithFrame:CGRectMake(achieveSize.width + STWidth(8),  STHeight(4), STWidth(13), STWidth(13))];
    achieveImageView.image = [UIImage imageNamed:IMAGE_LIGHT_NEXT];
    achieveImageView.contentMode = UIViewContentModeScaleAspectFill;
    [achieveBtn addSubview:achieveImageView];
    
    
    for(int i = 0 ; i < 6 ; i++){
        STTitleButton *button = [[STTitleButton alloc]initWithTitle:titles[i] content:contents[i] width:STWidth(115) height:STHeight(60)];
        button.frame = CGRectMake(STWidth(115) * (i % 3), STHeight(60) * (i / 3) + STHeight(60), STWidth(115), STHeight(60));
        button.tag = i;
        [button addTarget:self action:@selector(OnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:button];
        [_buttons addObject:button];
    }
    
    for(int i = 0 ; i < 4 ; i++){
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = c05;
        view.frame = CGRectMake(STWidth(115) + STWidth(112) * (i % 2), STHeight(73) + STHeight(66) * (i / 2), LineHeight, STHeight(18));
        [topView addSubview:view];
    }
    
    [self initFestivalView];
    
    //代理商 1，2     激活设备",@"添加商户",@"添加代理商"，@"添加业务员"
    //代理商 3        激活设备",@"添加商户",@"添加业务员"
    //业务员 1，2     激活设备",@"添加商户",@"添加代理商"
    //业务员3         激活设备",@"添加商户"
    //连锁门店        激活设备,添加商户，添加业务员
    //连锁门店业务员    激活设备,
    
    NSMutableArray *menus = [NSMutableArray arrayWithArray:@[MENU_ACTIVE,MENU_ADD_MERCHANT,MENU_ADD_AGENT,MENU_ADD_SALEMAN,MENU_ADD_CHAIN,MENU_RESET,MENU_BIND_MERCHANT]];
    NSMutableArray *menuSrcs =[NSMutableArray arrayWithArray: @[IMAGE_ACTIVE,IMAGE_ADD_MERCHANT,IMAGE_ADD_AGENT,IMAGE_ADD_SALEMAN,IMAGE_ADD_CHAIN,IMAGE_RESET,IMAGE_BIND_MERCHANT]];
    UserModel *userModel = [[AccountManager sharedAccountManager]getUserModel];
    //如果是业务员
    if(userModel.roleType == 2 || userModel.roleType == 3){
        //3级业务员
        if(userModel.level == 3){
            menus = [NSMutableArray arrayWithArray:@[MENU_ACTIVE,MENU_ADD_MERCHANT,MENU_ADD_CHAIN,MENU_RESET,MENU_BIND_MERCHANT]];
            menuSrcs = [NSMutableArray arrayWithArray:@[IMAGE_ACTIVE,IMAGE_ADD_MERCHANT,IMAGE_ADD_CHAIN,IMAGE_RESET,IMAGE_BIND_MERCHANT]];
        }else if(userModel.level == 4){
            menus = [NSMutableArray arrayWithArray:@[MENU_ACTIVE,MENU_ADD_MERCHANT,MENU_RESET,MENU_BIND_MERCHANT]];
            menuSrcs = [NSMutableArray arrayWithArray:@[IMAGE_ACTIVE,IMAGE_ADD_MERCHANT,IMAGE_RESET,IMAGE_BIND_MERCHANT]];
        }else{
            menus = [NSMutableArray arrayWithArray:@[MENU_ACTIVE,MENU_ADD_MERCHANT,MENU_ADD_AGENT,MENU_ADD_CHAIN,MENU_RESET,MENU_BIND_MERCHANT]];
            menuSrcs = [NSMutableArray arrayWithArray:@[IMAGE_ACTIVE,IMAGE_ADD_MERCHANT,IMAGE_ADD_AGENT,IMAGE_ADD_CHAIN,IMAGE_RESET,IMAGE_BIND_MERCHANT]];
        }
        
    }
    //如果是代理商
    else{
        if(userModel.level == 3){
            menus = [NSMutableArray arrayWithArray:@[MENU_ACTIVE,MENU_ADD_MERCHANT,MENU_ADD_SALEMAN,MENU_ADD_CHAIN,MENU_RESET,MENU_BIND_MERCHANT]];
            menuSrcs = [NSMutableArray arrayWithArray:@[IMAGE_ACTIVE,IMAGE_ADD_MERCHANT,IMAGE_ADD_SALEMAN,IMAGE_ADD_CHAIN,IMAGE_RESET,IMAGE_BIND_MERCHANT]];
        }else if(userModel.level == 4){
            menus = [NSMutableArray arrayWithArray:@[MENU_ACTIVE,MENU_ADD_MERCHANT,MENU_ADD_SALEMAN,MENU_RESET,MENU_BIND_MERCHANT]];
            menuSrcs = [NSMutableArray arrayWithArray:@[IMAGE_ACTIVE,IMAGE_ADD_MERCHANT,IMAGE_ADD_SALEMAN,IMAGE_RESET,IMAGE_BIND_MERCHANT]];
        }else{
            menus = [NSMutableArray arrayWithArray:@[MENU_ACTIVE,MENU_ADD_MERCHANT,MENU_ADD_AGENT,MENU_ADD_SALEMAN,MENU_ADD_CHAIN,MENU_RESET,MENU_BIND_MERCHANT]];
            menuSrcs = [NSMutableArray arrayWithArray:@[IMAGE_ACTIVE,IMAGE_ADD_MERCHANT,IMAGE_ADD_AGENT,IMAGE_ADD_SALEMAN,IMAGE_ADD_CHAIN,IMAGE_RESET,IMAGE_BIND_MERCHANT]];
        }
    }
    
    if(IS_RED_SKIN){
        for(NSString *menu in menus){
            if([menu isEqualToString:MENU_RESET]){
                [menus removeObject:menu];
                break;
            }
        }
        for(NSString *menuSrc in menuSrcs){
            if([menuSrc isEqualToString:IMAGE_RESET]){
                [menuSrcs removeObject:menuSrc];
                break;
            }
        }
    }
    //如果是出租车业务
//    if(userModel.supportSevice != 1){
    //代理商，公司或者连锁门店才有权限
    if((userModel.mchType != 0 && userModel.mchType != 2) ){
        NSMutableArray *tempMenus = [NSMutableArray arrayWithArray:menus];
        [tempMenus removeObjectAtIndex:(tempMenus.count-1)];
        menus = tempMenus;
        
        NSMutableArray *tempMenuSrcs = [NSMutableArray arrayWithArray:menuSrcs];
        [tempMenuSrcs removeObjectAtIndex:(tempMenuSrcs.count-1)];
        menuSrcs = tempMenuSrcs;
    }

    [_menus addObjectsFromArray:menus];
    [_menuSrcs addObjectsFromArray:menuSrcs];
//    [_menus addObject:MENU_TAXI];
//    [_menuSrcs addObject:IMAGE_TAXI];

    for(int i = 0 ; i < _menus.count ; i++){
        STMainRectButton *button = [[STMainRectButton alloc]initWithTitle:_menus[i] imageSrc:_menuSrcs[i]];
        button.frame = CGRectMake(STWidth(15) + STWidth(118) * (i % 3),
                                  STHeight(207)+  STWidth(118) * (i / 3),
                                  STWidth(109), STWidth(109));
        button.tag = i;
        [button addTarget:self action:@selector(onMenuItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_itemButtons addObject:button];
        [_scrollView addSubview:button];
    }
    
//    _scrollView.contentSize = CGSizeMake(ScreenWidth, STHeight(192) + STHeight(97) * [menus count] + STHeight(15) + NewYearHeight);
    _scrollView.contentSize = CGSizeMake(ScreenWidth, STHeight(600));

}

-(void)onScanBtnClicked{
    if(_mViewModel){
        [_mViewModel scanMerchant];
    }
}


-(void)onMsgBtnClicked{
    _redPoint.hidden = YES;
    if(_mViewModel){
        [_mViewModel goMsgPage];
    }
}

-(void)onMenuItemClicked:(id)sender{
    NSUInteger tag = ((UIView *)sender).tag;
    if(_mViewModel){
        if(!IS_NS_COLLECTION_EMPTY(_menus)){
            NSString *temp = [_menus objectAtIndex:tag];
            if([temp isEqualToString:MENU_ACTIVE]){[_mViewModel goActiveDevice]; return;}
            if([temp isEqualToString:MENU_ADD_MERCHANT]){[_mViewModel goAddMerchat]; return;}
            if([temp isEqualToString:MENU_ADD_AGENT]){[_mViewModel goAddAgent]; return;}
            if([temp isEqualToString:MENU_ADD_SALEMAN]){[_mViewModel goAddSaleman]; return;}
            if([temp isEqualToString:MENU_ADD_CHAIN]){[_mViewModel goAddChain]; return;}
            if([temp isEqualToString:MENU_RESET]){[_mViewModel goReset]; return;}
            if([temp isEqualToString:MENU_BIND_MERCHANT]){[_mViewModel scanMerchant]; return;}
//            if([temp isEqualToString:MENU_TAXI]){[_mViewModel goTaxi]; return;}

        }
    }
}


-(void)updateData:(MainModel *)model{
    NSArray *titles = @[[NSString stringWithFormat:@"%d",model.todayMchCount],
                        [NSString stringWithFormat:@"%d",model.todayDeviceCount],
                        [NSString stringWithFormat:@"%@",[STNumUtil formatNumWith2P:model.todayAmount]],
                        [NSString stringWithFormat:@"%d",model.allMchCount],
                        [NSString stringWithFormat:@"%d",model.allDeviceCount],
                        [NSString stringWithFormat:@"%@",[STNumUtil formatNumWith2P:model.allAmount]]];
    
    if(!IS_NS_COLLECTION_EMPTY(_buttons)){
        for(STTitleButton *button in _buttons){
            [button setMainTitle:titles[button.tag]];
        }
    }
    [_scrollView endRefreshNew];
    
    
}


-(void)refreshNew{
    if(_mViewModel){
        [_mViewModel getHomeData];
    }
}


-(void)OnClicked:(id)sender{
    NSInteger tag = ((UIButton *)sender).tag;
    if(_mViewModel){
       [_mViewModel goArchievePage:tag % 3];
    }
}

//业绩明细
-(void)onAchieveClicked{
    if(_mViewModel){
        [_mViewModel goArchievePage:0];
    }
}


-(void)updateView{
    if(_mViewModel){
        [_mViewModel getHomeData];
    }
}


-(void)onScrollViewDidScroll:(UIScrollView *)scrollView{}

-(void)updateBroadcast:(NSString *)imgUrl content:(NSString *)content{
    NewYearHeight = STHeight(55);
    _mNewYearView.hidden = NO;
    [_mNewYearView setText:content];
    [_mNewYearView setImgUrl:imgUrl];
    [self updateNewYearView];
}
    

-(void)updateNewMsg{
    NSString *msg  = [STUserDefaults getKeyValue:UD_NEW_MSG];
    if(!IS_NS_STRING_EMPTY(msg) && [msg isEqualToString:@"1"]){
        _redPoint.hidden = NO;
    }else{
        _redPoint.hidden = YES;
    }
}

@end

