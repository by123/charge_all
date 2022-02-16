//
//  STMainRectButton.m
//  manage
//
//  Created by by.huang on 2019/4/4.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "STMainRectButton.h"

@interface STMainRectButton()

@property(strong, nonatomic)UIImageView *arrowImageView;
@property(strong, nonatomic)UIImageView *bgImageView;
@property(strong, nonatomic)UILabel *mainLabel;

@property(copy, nonatomic)NSString *mTitle;
@property(copy, nonatomic)NSString *mImageSrc;


@end

@implementation STMainRectButton

-(instancetype)initWithTitle:(NSString *)title imageSrc:(NSString *)imageSrc{
    if(self == [super init]){
        _mTitle = title;
        _mImageSrc = imageSrc;
        self.backgroundColor = cwhite;
        self.layer.shadowOffset = CGSizeMake(1, 1);
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowColor = c03.CGColor;
        [self initView];
    }
    return self;
}

-(void)initView{
    _mainLabel = [[UILabel alloc]initWithFont:STFont(14) text:_mTitle textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize mainSize = [_mTitle sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _mainLabel.frame = CGRectMake((STWidth(109) -mainSize.width ) /2 ,STWidth(67), mainSize.width, STHeight(21));
    [self addSubview:_mainLabel];
    
    _bgImageView = [[UIImageView alloc]init];
    _bgImageView.image = [UIImage imageNamed:_mImageSrc];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImageView.frame = CGRectMake((STWidth(109) - STWidth(33))/2, STWidth(24), STWidth(33), STWidth(33));
    [self addSubview:_bgImageView];
}
@end

