//
//  AgreementView.m
//  manage
//
//  Created by by.huang on 2018/11/6.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "AgreementView.h"
#import "STFileUtil.h"

@implementation AgreementView


-(instancetype)init{
    if(self == [super init]){
        [self initView];
    }
    return self;
}

-(void)initView{
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ContentHeight)];
    [self addSubview:scrollView];
    
    NSString *contentStr = IS_YELLOW_SKIN ? [STFileUtil loadFile:@"agreement.txt"] : [STFileUtil loadFile:@"agreement_red.txt"];
    UILabel *contentLabel = [[UILabel alloc]initWithFont:STFont(14) text:contentStr textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:YES];
    CGSize contentSize = [contentStr sizeWithMaxWidth:ScreenWidth - STWidth(30) font:STFont(14)];
    contentLabel.frame = CGRectMake(STWidth(15), STHeight(15), ScreenWidth - STWidth(30),contentSize.height);
    [scrollView addSubview:contentLabel];
    
    scrollView.contentSize = CGSizeMake(ScreenWidth, contentSize.height + STHeight(30));
}


@end
