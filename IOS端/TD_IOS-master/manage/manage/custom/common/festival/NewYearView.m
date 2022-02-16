//
//  NewYearView.m
//  manage
//
//  Created by by.huang on 2019/1/18.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "NewYearView.h"
#import "ZScrollLabel.h"

@interface NewYearView()

@property(strong, nonatomic)UIImageView *iconImageView;
@property(strong, nonatomic)ZScrollLabel *scollLabel;

@end

@implementation NewYearView

-(instancetype)init{
    if(self == [super init]){
        [self initView];
    }
    return self;
}

-(void)initView{
    self.frame = CGRectMake(0, 0, STWidth(330), STHeight(40));
    self.backgroundColor = c14;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 2;
    
    _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(15), 0, STHeight(40), STHeight(40))];
    _iconImageView.image = [UIImage imageNamed:IMAGE_TIPS];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_iconImageView];
    
    [self addSubview:[self scollLabel]];
    
    
    UIButton *closeBtn = [[UIButton alloc]init];
    closeBtn.frame = CGRectMake(STWidth(330-46), 0, STWidth(46), STHeight(40));
    [closeBtn addTarget:self action:@selector(onCloseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    
    UIImageView *closeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(15), (STHeight(40) - STWidth(16))/2, STWidth(16), STWidth(16))];
    closeImageView.image = [UIImage imageNamed:IMAGE_CLOSE];
    closeImageView.contentMode = UIViewContentModeScaleAspectFill;
    [closeBtn addSubview:closeImageView];
    
}

- (ZScrollLabel *)scollLabel {
    if (!_scollLabel) {
        _scollLabel = [[ZScrollLabel alloc] initWithFrame:CGRectMake(STWidth(65), 0, STWidth(220), STHeight(40))];
        _scollLabel.textColor = c10;
        _scollLabel.font = [UIFont systemFontOfSize:STFont(14)];
    }
    return _scollLabel;
}

-(void)setText:(NSString *)text{
    _scollLabel.text = text;
}

-(void)setImgUrl:(NSString *)imgUrl{
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
}

-(void)onCloseBtnClick{
    if(_delegate){
        [_delegate onCloseNewYearView];
    }
}
@end
