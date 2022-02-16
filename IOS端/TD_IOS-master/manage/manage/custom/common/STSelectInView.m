//
//  STSelectInView.m
//  manage
//
//  Created by by.huang on 2018/11/30.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "STSelectInView.h"

@interface STSelectInView ()

@property(copy, nonatomic)NSString *title;
@property(copy, nonatomic)NSString *placeHolder;
@property(strong, nonatomic)UILabel *contentLabel;

@end

@implementation STSelectInView

-(instancetype)initWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder frame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        self.title = title;
        self.placeHolder = placeHolder;
        [self initView];
    }
    return self;
}

-(void)initView{
    
    self.frame = CGRectMake(0, 0, self.frame.size.width, STHeight(50));
    self.backgroundColor = cwhite;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:_title textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize titleSize = [_title sizeWithMaxWidth:self.frame.size.width font:STFont(15)];
    titleLabel.frame = CGRectMake(STWidth(15), 0, titleSize.width, STHeight(50));
    [self addSubview:titleLabel];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(STWidth(110), 0, STWidth(250),STHeight(50))];
    [button addTarget:self action:@selector(onBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    _contentLabel = [[UILabel alloc]initWithFont:STFont(15) text:_placeHolder textAlignment:NSTextAlignmentCenter textColor:c03 backgroundColor:nil multiLine:NO];
    CGSize contentSize = [_placeHolder sizeWithMaxWidth:self.frame.size.width font:STFont(15)];
    _contentLabel.frame = CGRectMake(self.frame.size.width - STWidth(34) - contentSize.width, 0, contentSize.width, STHeight(50));
    _contentLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self addSubview:_contentLabel];
    
    UIImageView *arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - STWidth(28), (STHeight(50) - STWidth(13))/2, STWidth(13), STWidth(13))];
    arrowImageView.image = [UIImage imageNamed:IMAGE_REFRESH];
    arrowImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:arrowImageView];

}


-(void)setContent:(NSString *)content{
    _contentLabel.textColor = c10;
    CGSize contentSize = [content sizeWithMaxWidth:ScreenWidth*2/3 font:STFont(15)];
    _contentLabel.frame = CGRectMake(self.frame.size.width - STWidth(34) - contentSize.width, 0, contentSize.width, STHeight(50));
    _contentLabel.text = content;
}

-(NSString *)getContent{
    if([_contentLabel.text isEqualToString:_placeHolder]){
        return MSG_EMPTY;
    }
    return _contentLabel.text;
}

-(void)onBtnClick{
    if(_delegate){
       [_delegate onSelectClicked:self];
    }
}

@end
