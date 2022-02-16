//
//  WhiteListView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "WhiteListView.h"
#import "WTScopeModel.h"
@interface WhiteListView()

@property(strong, nonatomic)WhiteListViewModel *mViewModel;
@property(strong, nonatomic)UITextField *nameTF;
@property(strong, nonatomic)UIButton *scopeBtn;
@property(strong, nonatomic)UIButton *timeBtn;
@property(copy, nonatomic)NSString *scale;
@property(copy, nonatomic)NSString *time;

@end

@implementation WhiteListView

-(instancetype)initWithViewModel:(WhiteListViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];
    }
    return self;
}

-(void)initView{
    [self initCardView];
    [self initStepView];
    
    UIButton *inviteBtn = [[UIButton alloc]initWithFont:STFont(18) text:@"微信邀请客户" textColor:c_btn_txt_highlight backgroundColor:IS_YELLOW_SKIN ? c15 : c01 corner:2 borderWidth:0 borderColor:nil];
    if (@available(iOS 11.0, *)) {
        inviteBtn.frame = CGRectMake(STWidth(15), ContentHeight - STHeight(110) - HomeIndicatorHeight, STWidth(345), STHeight(50));
    } else {
        inviteBtn.frame = CGRectMake(STWidth(15), ContentHeight - STHeight(110), STWidth(345), STHeight(50));
    }
    [inviteBtn addTarget:self action:@selector(onInviteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:inviteBtn];
}

-(void)initCardView{
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(20), STWidth(345), STHeight(180))];
    bgImageView.image = [UIImage imageNamed:IMAGE_WHITELIST_BG];
    bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:bgImageView];
    
    NSArray *images = @[IMAGE_CUSTOMER_NAME,IMAGE_SCOPE,IMAGE_TIME];
    for(int i = 0 ; i < images.count ; i ++){
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(21), STHeight(43) + STHeight(40) * i, STWidth(14), STWidth(14))];
        imageView.image = [UIImage imageNamed:images[i]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [bgImageView addSubview:imageView];
    }
    
    NSArray *titles = @[@"客户姓名",@"使用范围",@"充电时长"];
    for(int i = 0 ; i < titles.count ; i ++){
        NSString *titleStr = titles[i];
        UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:titleStr textAlignment:NSTextAlignmentLeft textColor:cwhite backgroundColor:nil multiLine:NO];
        CGSize titleSize = [titleStr sizeWithMaxWidth:ScreenWidth font:STFont(15) ];
        titleLabel.frame = CGRectMake(STWidth(41), STHeight(39) + STHeight(40) * i, titleSize.width, STHeight(21));
        [bgImageView addSubview:titleLabel];
    }
    
    _nameTF = [[UITextField alloc]initWithFont:STFont(15) textColor:cwhite backgroundColor:nil corner:0 borderWidth:0 borderColor:0 padding:0];
    _nameTF.textAlignment = NSTextAlignmentRight;
    _nameTF.font = [UIFont boldSystemFontOfSize:STFont(15)];
    [_nameTF setPlaceholder:@"请输入客户姓名" color:c03 fontSize:STFont(15)];
    _nameTF.frame = CGRectMake(STWidth(135), STHeight(59), STWidth(205),STHeight(21));
    [self addSubview:_nameTF];
    
    _scopeBtn = [[UIButton alloc]initWithFont:STFont(15) text:@"请选择可免费充电的商户" textColor:c03 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil];
    _scopeBtn.frame = CGRectMake(STWidth(135), STHeight(99), STWidth(205),STHeight(21));
    _scopeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    _scopeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_scopeBtn addTarget:self action:@selector(onScopeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_scopeBtn];
    
    _timeBtn = [[UIButton alloc]initWithFont:STFont(15) text:@"请选择可免费充电的时长" textColor:c03 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil];
    _timeBtn.frame = CGRectMake(STWidth(135), STHeight(139), STWidth(205),STHeight(21));
    _timeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    _timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_timeBtn addTarget:self action:@selector(onTimeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_timeBtn];
    
   
}


-(void)initStepView{
    NSString *stepStr = @"步骤说明：";
    UILabel *stepLabel = [[UILabel alloc]initWithFont:STFont(16) text:stepStr textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize stepSize = [stepStr sizeWithMaxWidth:ScreenWidth font:STFont(16)];
    stepLabel.frame = CGRectMake(STWidth(15), STHeight(240), stepSize.width, STHeight(22));
    [self addSubview:stepLabel];
    
    NSString *contentStr = @"1.  设置免费充电使用范围\n2.  微信邀请客户\n3.  客户微信完成白名单授权\n4.  客户到指定门店免费充电";
    UILabel *contentLabel = [[UILabel alloc]initWithFont:STFont(14) text:contentStr textAlignment:NSTextAlignmentLeft textColor:c11 backgroundColor:nil multiLine:YES];
    [UILabel changeLineSpaceForLabel:contentLabel WithSpace:STHeight(10)];
    contentLabel.frame = CGRectMake(STWidth(15), STHeight(267), STWidth(345), STHeight(120));
    [self addSubview:contentLabel];
}

-(void)onInviteBtnClick{
    if(IS_NS_STRING_EMPTY(_nameTF.text)){
        [LCProgressHUD showMessage:@"请输入客户姓名"];
        return;
    }
    if(IS_NS_COLLECTION_EMPTY(_mViewModel.selectDatas) && IS_NS_STRING_EMPTY(_mViewModel.orderWhiteListId)){
        [LCProgressHUD showMessage:@"请选择适用范围"];
        return;
    }
    if(IS_NS_STRING_EMPTY(_scale)){
        [LCProgressHUD showMessage:@"请选择可免费充电的时长"];
        return;
    }
    [_mViewModel createWhiteList:_mViewModel.selectDatas userName:_nameTF.text orderWhiteListId:_mViewModel.orderWhiteListId scale:[_scale intValue] time:_time];

}

-(void)onScopeBtnClicked{
    [_nameTF resignFirstResponder];
    if(IS_NS_STRING_EMPTY(_mViewModel.orderWhiteListId)){
        [_mViewModel goWhiteListScopePage:nil];
    }else{
        [_mViewModel goWhiteListScopePage:_mViewModel.orderWhiteListId];
    }
}

-(void)onTimeBtnClicked{
    [_mViewModel goWhiteListChargeTimePage:_scale];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_nameTF resignFirstResponder];
}

-(void)updateView:(NSString *)name{
    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.selectDatas)){
        NSString *scopeStr = MSG_EMPTY;
        for (WTScopeModel *model in _mViewModel.selectDatas) {
            if(model.selected == WHITELIST_SELECT_ALL){
                Boolean add = YES;
                //如果为全选中，则只选择父级
                for(WTScopeModel *temp in _mViewModel.selectDatas){
                    if([model.parentAgencyId isEqualToString:temp.mchId] && temp.selected == WHITELIST_SELECT_ALL){
                        add = NO;
                        break;
                    }
                }
                if(add){
                    scopeStr = [scopeStr stringByAppendingString:model.mchName];
                    scopeStr = [scopeStr stringByAppendingString:@","];
                }
            }
        }
        if(!IS_NS_STRING_EMPTY(scopeStr)){
            scopeStr = [scopeStr substringWithRange:NSMakeRange(0, scopeStr.length - 1)];
            _scopeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:STFont(15)];
            [_scopeBtn setTitle:scopeStr forState:UIControlStateNormal];
            [_scopeBtn setTitleColor:cwhite forState:UIControlStateNormal];
        }else{
            _scopeBtn.titleLabel.font = [UIFont systemFontOfSize:STFont(15)];
            [_scopeBtn setTitle:@"请选择可免费充电的商户" forState:UIControlStateNormal];
            [_scopeBtn setTitleColor:c03 forState:UIControlStateNormal];
        }
    }
    if(!IS_NS_STRING_EMPTY(name)){
        _scopeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:STFont(15)];
        [_scopeBtn setTitle:[NSString stringWithFormat:@"%@的使用范围",name] forState:UIControlStateNormal];
        [_scopeBtn setTitleColor:cwhite forState:UIControlStateNormal];
    }
}

-(void)updateTime:(NSString *)time scale:(NSString *)scale{
    [_timeBtn setTitle:[NSString stringWithFormat:@"%d小时",[time intValue]/60] forState:UIControlStateNormal];
    [_timeBtn setTitleColor:cwhite forState:UIControlStateNormal];
    _scale = scale;
    _time = time;
}
@end

