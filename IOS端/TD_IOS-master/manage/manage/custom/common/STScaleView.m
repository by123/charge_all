//
//  STScaleView.m
//  manage
//
//  Created by by.huang on 2018/11/3.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "STScaleView.h"
#import "TitleContentModel.h"

@interface STScaleView()

@property(strong, nonatomic)NSMutableArray *datas;
@property(assign, nonatomic)NSInteger mPosition;
@property(assign, nonatomic)Boolean mIsSelect;

@property(strong, nonatomic)UITextField *timelabel;
@property(strong, nonatomic)UILabel *perlabel;

@end

@implementation STScaleView

-(instancetype)initWithPosition:(NSInteger)position{
    if(self == [super init]){
        _mPosition = position;
        _datas = [ScaleModel getTimesData];
        [self initView];
    }
    return self;
}

-(void)initView{
    
    self.frame = CGRectMake(0, 0, STWidth(122), STHeight(36));
    self.layer.borderColor = c11.CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 2;
    
    _timelabel = [[UITextField alloc]initWithFont:STFont(15) textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil padding:0];
    _timelabel.frame = CGRectMake(STWidth(10), 0, STWidth(50), STHeight(36));
    _timelabel.placeholder = @"0";
    _timelabel.enabled = NO;
    _timelabel.textAlignment = NSTextAlignmentLeft;

    [self addSubview:_timelabel];
    
    _perlabel = [[UILabel alloc]initWithFont:STFont(15) text:@"小时" textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize perSize = [@"小时" sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _perlabel.frame = CGRectMake(STWidth(68), 0, perSize.width, STHeight(36));
    [self addSubview:_perlabel];

    UIImageView *selectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(103), (STHeight(36) - STWidth(7.2))/2, STWidth(12.4), STWidth(7.2))];
    selectImageView.image = [UIImage imageNamed:IMAGE_REFRESH];
    selectImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:selectImageView];

}

-(void)setData:(TitleContentModel *)model{
    _timelabel.text = model.content;
    
    _perlabel.text = model.extra;
    CGSize perSize = [model.extra sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _perlabel.frame = CGRectMake(STWidth(68), 0, perSize.width, STHeight(36));
    
//    [STLog print:model.content content:model.extra];
}


@end
