//
//  AchieveView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "AchieveView.h"
#import "STPageView.h"
#import "AchieveContentView.h"

@interface AchieveView()

@property(strong, nonatomic)AchieveViewModel *mViewModel;
@property(strong, nonatomic)AchieveContentView *merchantView;
@property(strong, nonatomic)AchieveContentView *deviceView;
@property(strong, nonatomic)AchieveContentView *profitView;

@end

@implementation AchieveView

-(instancetype)initWithViewModel:(AchieveViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];
    }
    return self;
}

-(void)initView{
    
    _merchantView = [[AchieveContentView alloc]initWithType:Achieve_Merchant viewModel:_mViewModel];
    _merchantView.frame = CGRectMake(0, STHeight(38), ScreenWidth, ContentHeight - STHeight(38));
    
    _deviceView = [[AchieveContentView alloc]initWithType:Achieve_Device viewModel:_mViewModel];
    _deviceView.frame = CGRectMake(0, STHeight(38), ScreenWidth, ContentHeight - STHeight(38));
    
    _profitView= [[AchieveContentView alloc]initWithType:Achieve_Profit viewModel:_mViewModel];
    _profitView.frame = CGRectMake(0, STHeight(38), ScreenWidth, ContentHeight - STHeight(38));
    
    NSMutableArray *views = [[NSMutableArray alloc]init];
    [views addObject:_merchantView];
    [views addObject:_deviceView];
    [views addObject:_profitView];
    
    NSArray *titles = @[@"开发商户数",@"激活设备数",@"设备收益"];
    
    STPageView *pageView = [[STPageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ContentHeight) views:views titles:titles];
    [self addSubview:pageView];
    
    [pageView setCurrentTab:_mViewModel.currentTab];
    
}

-(void)updateView{
    
}

@end

