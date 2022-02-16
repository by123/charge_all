//
//  WTScopeCell.m
//  manage
//
//  Created by by.huang on 2019/3/17.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "WTScopeCell.h"

@interface WTScopeCell()

@property(strong, nonatomic)UILabel *titleLabel;
@property(strong, nonatomic)UIImageView *expandImageView;
@property(strong, nonatomic)UILabel *selectLabel;
@property(strong, nonatomic)UIImageView *selectImageView;
@property(strong, nonatomic)UIView *lineView;

@end


@implementation WTScopeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

-(void)initView{
    
    _expandImageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(21), STHeight(11), STHeight(8))];
    _expandImageView.image = [UIImage imageNamed:IMAGE_FOLD_ALL];
    _expandImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_expandImageView];
    
    _titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:NO];
    [self.contentView addSubview:_titleLabel];
    
    
    
    _selectBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - STWidth(100), 0, STWidth(100), STHeight(50))];
    [self.contentView addSubview:_selectBtn];
    
    
    _selectLabel = [[UILabel alloc]initWithFont:STFont(14) text:@"全选" textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize selectLabelSize = [_selectLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    _selectLabel.frame = CGRectMake(STWidth(100) - STWidth(36) - selectLabelSize.width, 0, selectLabelSize.width, STHeight(50));
    [_selectBtn addSubview:_selectLabel];
    
    _selectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(100)-STWidth(31), (STHeight(50) - STWidth(16))/2, STWidth(16), STHeight(16))];
    _selectImageView.image = [UIImage imageNamed:IMAGE_FOLD_ALL];
    _selectImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_selectBtn addSubview:_selectImageView];
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), 0, STWidth(345), LineHeight)];
    _lineView.backgroundColor = cline;
    [self.contentView addSubview:_lineView];
    
}

-(void)updateData:(WTScopeModel *)model position:(NSInteger)position{
    _titleLabel.text =model.mchName;
    if(position == 0){
        _titleLabel.textColor = c10;
        [_titleLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(15)]];
        _titleLabel.frame = CGRectMake(STWidth(30), 0, ScreenWidth - STWidth(130), STHeight(50));
        _expandImageView.frame = CGRectMake(STWidth(15), STHeight(21), STHeight(11), STHeight(8));
        _expandImageView.hidden = NO;
        _lineView.hidden = YES;
    }else{
        if(model.showLine){
            _lineView.hidden = NO;
        }else{
            _lineView.hidden  = YES;
        }
        _titleLabel.textColor = c11;
        [_titleLabel setFont:[UIFont fontWithName:FONT_REGULAR size:STFont(15)]];
        _expandImageView.frame = CGRectMake(STWidth(30), STHeight(21), STHeight(11), STHeight(8));
        if(model.mchType == 1){
            _selectLabel.text = MSG_EMPTY;
            _expandImageView.hidden = YES;
            _titleLabel.frame = CGRectMake(STWidth(30), 0, ScreenWidth - STWidth(130), STHeight(50));
        }else{
            _selectLabel.text = @"全选";
            _expandImageView.hidden = NO;
            _titleLabel.frame = CGRectMake(STWidth(47), 0, ScreenWidth - STWidth(147), STHeight(50));
        }
    }
    

    
    if(model.isExpand){
        if(position == 0){
            _expandImageView.image = [UIImage imageNamed:IMAGE_FOLD_ALL];
        }else{
            _expandImageView.image = [UIImage imageNamed:IMAGE_FOLD_CITY];
        }
    }else{
        if(position == 0){
            _expandImageView.image = [UIImage imageNamed:IMAGE_UNFOLD_ALL];
        }else{
            _expandImageView.image = [UIImage imageNamed:IMAGE_UNFOLD_CITY];
        }
    }
    
    if(model.selected == WHITELIST_SELECT_ALL){
        _selectImageView.image = [UIImage imageNamed:IMAGE_SELECT_ALL];
    }else if(model.selected == WHITELIST_SELECT_HALF){
        _selectImageView.image = [UIImage imageNamed:IMAGE_SELECT_HALF];
    }else{
        _selectImageView.image = [UIImage imageNamed:IMAGE_SELECT_NOAMAL];
    }
}

+(NSString *)identify{
    return NSStringFromClass([WTScopeCell class]);
}


@end
