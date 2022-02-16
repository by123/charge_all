//
//  PerformanceView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "PerformanceView.h"
#import "STPageView.h"
#import "PerformanceMerchantView.h"
#import "PerformanceActiveView.h"
#import "PerformanceArchiveView.h"


@interface PerformanceView()<STPageViewDelegate>

@property(strong, nonatomic)PerformanceViewModel *activeVM;
@property(strong, nonatomic)PerformanceViewModel *merchantVM;
@property(strong, nonatomic)PerformanceViewModel *archiveVM;
@property(strong, nonatomic)PerformanceMerchantView *merchantView;
@property(strong, nonatomic)PerformanceActiveView *activeView;
@property(strong, nonatomic)PerformanceArchiveView *archiveView;

@end

@implementation PerformanceView

-(instancetype)initWithViewModel:(PerformanceViewModel *)viewModel merchant:(PerformanceViewModel *)viewModel2 archive:(PerformanceViewModel *)viewModel3{
    if(self == [super init]){
        _activeVM = viewModel;
        _merchantVM = viewModel2;
        _archiveVM = viewModel3;
        [self initView];
    }
    return self;
}

-(void)initView{
    [self initTabView];
}

-(void)initTabView{
    _merchantView = [[PerformanceMerchantView alloc]initWithViewModel:_activeVM];
    _merchantView.frame = CGRectMake(0, STHeight(38), ScreenWidth, ContentHeight - STHeight(38));
    
    _activeView = [[PerformanceActiveView alloc]initWithViewModel:_merchantVM];
    _activeView.frame = CGRectMake(0, STHeight(38), ScreenWidth, ContentHeight - STHeight(38));

    _archiveView = [[PerformanceArchiveView alloc]initWithViewModel:_archiveVM];
    _archiveView.frame = CGRectMake(0, STHeight(38), ScreenWidth, ContentHeight - STHeight(38));
    
    NSMutableArray *views = [[NSMutableArray alloc]init];
    [views addObject:_activeView];
    [views addObject:_merchantView];
    [views addObject:_archiveView];
    
    NSArray *titles = @[@"激活设备数",@"开发商户数",@"设备收益"];
    CGSize titleSize = [@"激活设备数" sizeWithMaxWidth:ScreenWidth font:STFont(16)];
    STPageView *pageView = [[STPageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ContentHeight) views:views titles:titles perLine:titleSize.width/(ScreenWidth/3)];
    pageView.delegate = self;
    [self addSubview:pageView];
    
    [pageView setCurrentTab:0];
}


-(void)onPageViewSelect:(NSInteger)position view:(id)view{
    [_merchantView hiddenKeyboard];
    [_activeView hiddenKeyboard];
}

-(void)updateView:(PerformanceType)type{
    if(type == PerformanceType_Active){
        [_activeView updateView];
    }else if(type == PerformanceType_Merchant){
        [_merchantView updateView];
    }else if(type == PerformanceType_Archive){
        [_archiveView updateView];
    }
}

-(void)updateTotalView:(PerformanceType)type{
    if(type == PerformanceType_Active){
        [_activeView updateTotalView];
    }else if(type == PerformanceType_Merchant){
        [_merchantView updateTotalView];
    }
}

-(void)updateNoData:(PerformanceType)type noData:(Boolean)noData{
    if(type == PerformanceType_Active){
        [_activeView updateNoData:noData];
    }else if(type == PerformanceType_Merchant){
        [_merchantView updateNoData:noData];
    }else if(type == PerformanceType_Archive){
        [_archiveView updateNoData:noData];
    }
}
@end

