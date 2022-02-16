//
//  AddMchSuccessPage.m
//  manage
//
//  Created by by.huang on 2018/12/4.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "AddMchSuccessPage.h"
#import "MainPage.h"
@interface AddMchSuccessPage ()

@property(copy, nonatomic)NSString *mchName;

@end

@implementation AddMchSuccessPage

+(void)show:(BaseViewController *)controller mchName:(NSString *)name{
    AddMchSuccessPage *page = [[AddMchSuccessPage alloc]init];
    page.mchName = name;
    [controller pushPage:page];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:cwhite style:UIStatusBarStyleDefault];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:MSG_TITLE_RESULT needback:YES];
    [self initView];
}

-(void)initView{
    
    
    CGFloat height = StatuNavHeight;
    
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - STWidth(100))/2,height+ STHeight(20), STWidth(100), STWidth(100))];
    iconImageView.image = [UIImage imageNamed:IMAGE_COMPELTE];
    iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:iconImageView];
    
    NSString *resultStr = MSG_MERCHANT_ADD_SUCCESS;
    UILabel *resultLabel = [[UILabel alloc]initWithFont:STFont(16) text:resultStr textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    resultLabel.frame = CGRectMake(0, height + STHeight(130), ScreenWidth, STHeight(22));
    [self.view addSubview:resultLabel];

    NSString *nameStr = _mchName;
    UILabel *nameLabel = [[UILabel alloc]initWithFont:STFont(16) text:nameStr textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [nameLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(16)]];
    nameLabel.frame = CGRectMake(0, height + STHeight(172), ScreenWidth, STHeight(22));
    [self.view addSubview:nameLabel];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFont:STFont(14) text:MSG_MERCHANT_BIND_TIPS textAlignment:NSTextAlignmentCenter textColor:c05 backgroundColor:nil multiLine:YES];
    CGSize tipSize = [tipLabel.text sizeWithMaxWidth:STWidth(165) font:STFont(14)];
    tipLabel.frame = CGRectMake((ScreenWidth - STWidth(165))/2, height + STHeight(214), STWidth(165), tipSize.height);
    [self.view addSubview:tipLabel];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_MERCHANT_BIND_STEP textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    titleLabel.frame = CGRectMake(0, height + STHeight(302), ScreenWidth, STHeight(24));
    [self.view addSubview:titleLabel];
    
    UIView *leftLine = [[UIView alloc]initWithFrame:CGRectMake(STWidth(48), height +STHeight(313), STWidth(90), LineHeight)];
    leftLine.backgroundColor = cline;
    [self.view addSubview:leftLine];
    
    UIView *rightLine = [[UIView alloc]initWithFrame:CGRectMake(STWidth(237), height +STHeight(313), STWidth(90), LineHeight)];
    rightLine.backgroundColor = cline;
    [self.view addSubview:rightLine];
    
    UILabel *step1Label = [[UILabel alloc]initWithFont:STFont(15) text:MSG_MERCHANT_BIND_STEP1 textAlignment:NSTextAlignmentLeft textColor:c11 backgroundColor:nil multiLine:YES];
    CGSize step1Size = [step1Label.text sizeWithMaxWidth:STWidth(315) font:STFont(15)];
    step1Label.frame = CGRectMake((ScreenWidth - STWidth(315))/2, height + STHeight(341), STWidth(315), step1Size.height);
    [self.view addSubview:step1Label];
    
    UILabel *step2Label = [[UILabel alloc]initWithFont:STFont(15) text:MSG_MERCHANT_BIND_STEP2 textAlignment:NSTextAlignmentLeft textColor:c11 backgroundColor:nil multiLine:YES];
    CGSize step2Size = [step2Label.text sizeWithMaxWidth:STWidth(315) font:STFont(15)];
    step2Label.frame = CGRectMake((ScreenWidth - STWidth(315))/2, height + STHeight(404), STWidth(315), step2Size.height);
    [self.view addSubview:step2Label];
    
    UIButton *cofirmBtn = nil;
    if(IS_YELLOW_SKIN){
        cofirmBtn = [[UIButton alloc]initWithFont:STFont(18) text:MSG_CONFIRM textColor:c_btn_txt_highlight backgroundColor:c01 corner:2 borderWidth:0 borderColor:nil];
    }else{
        cofirmBtn = [[UIButton alloc]initWithFont:STFont(18) text:MSG_CONFIRM textColor:c01 backgroundColor:cwhite corner:2 borderWidth:LineHeight borderColor:c01];
    }

    cofirmBtn.frame = CGRectMake(STWidth(128), height + STHeight(483) , STWidth(120), STHeight(42));
    [cofirmBtn addTarget:self action:@selector(onConfirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cofirmBtn];
    
}

-(void)backLastPage{
    [self onConfirmBtnClick];
}

-(void)onConfirmBtnClick{
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[MainPage class]]) {
            MainPage *page =(MainPage *)controller;
            [self.navigationController popToViewController:page animated:YES];
        }
    }
}

@end
