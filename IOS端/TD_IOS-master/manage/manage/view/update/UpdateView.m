//
//  updateView.m
//  manage
//
//  Created by by.huang on 2018/12/20.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "UpdateView.h"
@interface UpdateView()

@property(strong, nonatomic)UpdateModel *model;

@end

@implementation UpdateView

-(instancetype)initWithModel:(UpdateModel *)model{
    if(self == [super init]){
        self.model = model;
        [self initView];
    }
    return self;
}

-(void)initView{
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.backgroundColor = [cblack colorWithAlphaComponent:0.8];
    
    UIView *bodyView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(57), STHeight(169), STWidth(260), STHeight(275))];
    bodyView.backgroundColor = cwhite;
    bodyView.layer.masksToBounds = YES;
    bodyView.layer.cornerRadius = 2;
    [self addSubview:bodyView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(129), STHeight(119), STWidth(115), STWidth(100))];
    imageView.image = [UIImage imageNamed:IMAGE_VERSION_UPDATE];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView];
    
    NSString *titleStr = @"发现版本更新";
    UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(18) text:titleStr textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize titleSize = [titleStr sizeWithMaxWidth:ScreenWidth font:STFont(18) fontName:FONT_MIDDLE];
    [titleLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(18)]];
    titleLabel.frame = CGRectMake(0, STHeight(56), STWidth(260), STHeight(25));
    [bodyView addSubview:titleLabel];
    
    
    NSString *versionStr = [NSString stringWithFormat:@"v %@",_model.version];
    UILabel *versionLabel = [[UILabel alloc]initWithFont:STFont(12) text:versionStr textAlignment:NSTextAlignmentLeft textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize versionSize = [titleStr sizeWithMaxWidth:ScreenWidth font:STFont(12)];
    versionLabel.frame = CGRectMake((STWidth(260) - titleSize.width ) / 2 + titleSize.width + STWidth(4), STHeight(62), versionSize.width, STHeight(17));
    [bodyView addSubview:versionLabel];
    
    NSString *sizeStr = [NSString stringWithFormat:@"大小：%@M",_model.versionSize];
    UILabel *sizeLabel = [[UILabel alloc]initWithFont:STFont(12) text:sizeStr textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    sizeLabel.frame = CGRectMake(0, STHeight(85), STWidth(260), STHeight(17));
    [bodyView addSubview:sizeLabel];
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, STHeight(117), STWidth(260), STHeight(100))];
    [bodyView addSubview:scrollView];
    
    NSString *descStr =_model.versionDesc;;
    UILabel *descLabel = [[UILabel alloc]initWithFont:STFont(14) text:descStr textAlignment:NSTextAlignmentLeft textColor:c11 backgroundColor:nil multiLine:YES];
    CGSize descSize = [descStr sizeWithMaxWidth:STWidth(200) font:STFont(14)];
    descLabel.frame = CGRectMake(STWidth(30), 0, STWidth(200), descSize.height);
    [scrollView addSubview:descLabel];
    
    scrollView.contentSize = CGSizeMake(STWidth(260), descSize.height + STHeight(20));
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(224), ScreenWidth, LineHeight)];
    lineView.backgroundColor = cline;
    [bodyView addSubview:lineView];
    
    
    if(_model.recommend == 0){
        UIButton *updateBtn = [[UIButton alloc]initWithFont:STFont(16) text:@"立即更新" textColor:c10 backgroundColor:c01 corner:0 borderWidth:0 borderColor:nil];
        updateBtn.frame = CGRectMake(0, STHeight(225), STWidth(260), STHeight(50));
        [updateBtn addTarget:self action:@selector(onUpdateBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [bodyView addSubview:updateBtn];
    }else{
        
        UIButton *cancelBtn = [[UIButton alloc]initWithFont:STFont(16) text:@"以后再说" textColor:c05 backgroundColor:cwhite corner:0 borderWidth:0 borderColor:nil];
        cancelBtn.frame = CGRectMake(STWidth(0), STHeight(225), STWidth(130), STHeight(50));
        [cancelBtn addTarget:self action:@selector(onCancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [bodyView addSubview:cancelBtn];

        UIButton *updateBtn = [[UIButton alloc]initWithFont:STFont(16) text:@"立即更新" textColor:c10 backgroundColor:c01 corner:0 borderWidth:0 borderColor:nil];
        updateBtn.frame = CGRectMake(STWidth(130), STHeight(225), STWidth(130), STHeight(50));
        [updateBtn addTarget:self action:@selector(onUpdateBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [bodyView addSubview:updateBtn];
    }


}

-(void)onCancelBtnClick{
    [self removeFromSuperview];
}


-(void)onUpdateBtnClick{
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_model.downloadUrl] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_model.downloadUrl]];
    }
}


@end
