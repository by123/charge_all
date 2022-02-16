//
//  GroupCreateSuccessView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "GroupCreateSuccessView.h"

@interface GroupCreateSuccessView()

@property(strong, nonatomic)GroupCreateSuccessViewModel *mViewModel;

@end

@implementation GroupCreateSuccessView

-(instancetype)initWithViewModel:(GroupCreateSuccessViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];
    }
    return self;
}

-(void)initView{
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - STWidth(100))/2, STHeight(70), STWidth(100), STWidth(100))];
    iconImageView.image = [UIImage imageNamed:IMAGE_COMPELTE];
    iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:iconImageView];
    
    NSString *successStr = @"创建分组成功";
    UILabel *successLabel = [[UILabel alloc]initWithFont:STFont(15) text:successStr textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    successLabel.frame = CGRectMake(0, STHeight(180), ScreenWidth, STHeight(22));
    [self addSubview:successLabel];
    
    UIButton *addBtn = [[UIButton alloc]initWithFont:STFont(18) text:@"开始添加设备" textColor:c_btn_txt_highlight backgroundColor:c01 corner:2 borderWidth:0 borderColor:nil];
    addBtn.frame = CGRectMake(STWidth(15), STHeight(322), STWidth(345), STHeight(50));
    [addBtn addTarget:self action:@selector(onAddBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addBtn];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFont:STFont(18) text:@"暂不添加" textColor:c10 backgroundColor:cwhite corner:2 borderWidth:LineHeight borderColor:c10];
    cancelBtn.frame = CGRectMake(STWidth(15), STHeight(387), STWidth(345), STHeight(50));
    [cancelBtn addTarget:self action:@selector(onCancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];

}


-(void)onAddBtnClick{
    if(_mViewModel){
        [_mViewModel goScanPage];
    }
}

-(void)onCancelBtnClick{
    if(_mViewModel){
        [_mViewModel backListPage];
    }
}

-(void)updateView{
    
}

@end

