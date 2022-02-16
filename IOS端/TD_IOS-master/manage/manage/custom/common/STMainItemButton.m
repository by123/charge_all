//
//  STMainItemButton.m
//  manage
//
//  Created by by.huang on 2018/10/26.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "STMainItemButton.h"

@interface STMainItemButton()

@property(strong, nonatomic)UIImageView *arrowImageView;
@property(strong, nonatomic)UIImageView *bgImageView;
@property(strong, nonatomic)UILabel *mainLabel;

@property(copy, nonatomic)NSString *mTitle;
@property(copy, nonatomic)NSString *mImageSrc;


@end

@implementation STMainItemButton

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
    _mainLabel = [[UILabel alloc]initWithFont:STFont(18) text:_mTitle textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [_mainLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(18)]];
    CGSize mainSize = [_mTitle sizeWithMaxWidth:ScreenWidth font:STFont(18)];
    _mainLabel.frame = CGRectMake(STWidth(15),0, mainSize.width, STHeight(82));
    [self addSubview:_mainLabel];
    
    _arrowImageView = [[UIImageView alloc]init];
    _arrowImageView.image = [UIImage imageNamed:IMAGE_DARK_NEXT];
    _arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
    _arrowImageView.frame = CGRectMake(STWidth(23) + mainSize.width, STHeight(35), STWidth(8), STHeight(12));
    [self addSubview:_arrowImageView];
    
    _bgImageView = [[UIImageView alloc]init];
    _bgImageView.image = [UIImage imageNamed:_mImageSrc];
    _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    _bgImageView.frame = CGRectMake(STWidth(239), 0, STWidth(106), STHeight(82));
    [self addSubview:_bgImageView];
}
@end
