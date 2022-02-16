//
//  ScaleViewCell.m
//  manage
//
//  Created by by.huang on 2018/11/3.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "ScaleViewCell.h"
#import "STScaleView.h"
#import "STSinglePickerLayerView.h"
#import "STPriceView.h"

@interface ScaleViewCell()

@property(strong, nonatomic)UILabel *titleLabel;
@property(strong, nonatomic)STScaleView *timeScaleView;
@property(strong, nonatomic)STPriceView *priceScaleView;
@property(strong, nonatomic)UIButton *deleteBtn;

@end

@implementation ScaleViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

-(void)initView{
    _titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_titleLabel];
    
    _timeScaleView = [[STScaleView alloc]initWithPosition:0];
    _timeScaleView.frame = CGRectMake(STWidth(74), 0, STWidth(122), STHeight(36));
    [self.contentView addSubview:_timeScaleView];
    
    _priceScaleView= [[STPriceView alloc]init];
    _priceScaleView.frame = CGRectMake(STWidth(206), 0, STWidth(122), STHeight(36));
    [self.contentView addSubview:_priceScaleView];
    
    _deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(STWidth(328), 0, ScreenWidth - STWidth(328), STWidth(36))];
    [_deleteBtn setImage:[UIImage imageNamed:IMAGE_DEL_RULE] forState:UIControlStateNormal];
    _deleteBtn.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_deleteBtn];
}


-(void)updateData:(ScaleModel *)model positon:(NSInteger)position{

    _titleLabel.text = model.title;
    CGSize titleSize = [model.title sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _titleLabel.frame = CGRectMake(STWidth(15), 0, titleSize.width, STHeight(36));
    
    _timeScaleView.tag = position;
    [_timeScaleView addTarget:self action:@selector(onClickPrice:) forControlEvents:UIControlEventTouchUpInside];
    [_timeScaleView setData:model.timeModel];

    if(model.isDelete){
        _deleteBtn.hidden = NO;
    }else{
        _deleteBtn.hidden = YES;
    }
    [_deleteBtn addTarget:self action:@selector(onClickDelete:) forControlEvents:UIControlEventTouchUpInside];
    _deleteBtn.tag = position;
    
    [_priceScaleView setPrice:model.price];
    
}

-(void)updateTime:(TitleContentModel *)model{
    [_timeScaleView setData:model];
}


-(void)onClickPrice:(id)sender{
    NSInteger position = ((STScaleView *)sender).tag;
    if(_delegate){
        [_delegate OnClickScaleBtn:position];
    }
    
}

-(void)onClickDelete:(id)sender{
    STPriceView *priceView = ((STPriceView *)sender);
    NSInteger position = priceView.tag;
    if(_delegate){
        [_delegate OnClickDeleteBtn:position];
    }
}

-(UITextField *)getPriceTF{
    return [_priceScaleView getPriceTF];
}



+(NSString *)identify{
    return NSStringFromClass([ScaleViewCell class]);
}



@end
