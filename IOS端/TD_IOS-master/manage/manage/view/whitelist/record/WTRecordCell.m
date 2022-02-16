//
//  WTRecordCell.m
//  manage
//
//  Created by by.huang on 2019/3/18.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "WTRecordCell.h"

@interface WTRecordCell()

@property(strong, nonatomic)UIImageView *headImageView;
@property(strong, nonatomic)UILabel *nameLabel;
@property(strong, nonatomic)UILabel *stateLabel;
@property(strong, nonatomic)UIImageView *activeImageView;

@end


@implementation WTRecordCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

-(void)initView{
    
    UIView *bodyView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), 0, STWidth(345), STHeight(140))];
    bodyView.backgroundColor = cwhite;
    bodyView.layer.shadowOffset = CGSizeMake(1, 1);
    bodyView.layer.shadowOpacity = 0.8;
    bodyView.layer.shadowColor = c03.CGColor;
    [self.contentView addSubview:bodyView];
    
    _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(20), STHeight(50), STHeight(50))];
    _headImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = STHeight(25);
    [bodyView addSubview:_headImageView];
    
    _nameLabel = [[UILabel alloc]initWithFont:STFont(16) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [bodyView addSubview:_nameLabel];
    
    _stateLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    [bodyView addSubview:_stateLabel];
    
    
    _activeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(345) - STWidth(15) - STHeight(20), STHeight(22), STHeight(20), STHeight(20))];
    _activeImageView.contentMode = UIViewContentModeScaleAspectFill;
    [bodyView addSubview:_activeImageView];
    
    _changeBtn = [[UIButton alloc]initWithFont:STFont(15) text:@"启用" textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil];
    [_changeBtn setImage:[UIImage imageNamed:IMAGE_FORBID_WHITELIST] forState:UIControlStateNormal];
    _changeBtn.frame = CGRectMake(STWidth(15), STHeight(81), STWidth(60), STHeight(59));
    [_changeBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -STWidth(6), 0.0, 0.0)];
    [bodyView addSubview:_changeBtn];
    

    
    _editBtn = [[UIButton alloc]initWithFont:STFont(15) text:@"编辑" textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil];
    [_editBtn setImage:[UIImage imageNamed:IMAGE_EDIT_WHITELIST] forState:UIControlStateNormal];
    _editBtn.frame = CGRectMake(STWidth(96), STHeight(81), STWidth(82), STHeight(59));
    [_editBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -STWidth(6), 0.0, 0.0)];
    [bodyView addSubview:_editBtn];
    
    _cpBtn = [[UIButton alloc]initWithFont:STFont(15) text:@"复制" textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil];
    [_cpBtn setImage:[UIImage imageNamed:IMAGE_COPY_WHITELIST] forState:UIControlStateNormal];
    _cpBtn.frame = CGRectMake(STWidth(278), STHeight(81), STWidth(51), STHeight(59));
    [_cpBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -STWidth(6), 0.0, 0.0)];
    [bodyView addSubview:_cpBtn];

    
}

-(void)updateData:(WTRecordModel *)model{
    
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.headUrl]];
    
    _nameLabel.text = model.userName;
    CGSize titleSize = [_nameLabel.text sizeWithMaxWidth:STWidth(220) font:STFont(16)];
    _nameLabel.frame = CGRectMake(STHeight(50) + STWidth(25), STHeight(22), titleSize.width, STHeight(22));
    
    _stateLabel.text = [NSString stringWithFormat:@"状态：%@",(model.whiteListState == 1) ? @"正常" : @"禁用"];
    CGSize stateSize = [_stateLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _stateLabel.frame = CGRectMake(STHeight(50) + STWidth(25), STHeight(49), stateSize.width, STHeight(21));
    
    _activeImageView.image = (model.whiteListState == 1) ? [UIImage imageNamed:IMAGE_OPEN_STATE] : [UIImage imageNamed:IMAGE_FORBID_STATE];
    
    if(model.whiteListState == 1){
        [_changeBtn setImage:[UIImage imageNamed:IMAGE_FORBIT_WHITELIST] forState:UIControlStateNormal];
        [_changeBtn setTitle:@"禁用" forState:UIControlStateNormal];
    }else{
        [_changeBtn setImage:[UIImage imageNamed:IMAGE_OPEN_WHITELIST] forState:UIControlStateNormal];
        [_changeBtn setTitle:@"启用" forState:UIControlStateNormal];
    }
}

+(NSString *)identify{
    return NSStringFromClass([WTRecordCell class]);
}


@end
