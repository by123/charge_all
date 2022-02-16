//
//  MerchantSearchCell.m
//  manage
//
//  Created by by.huang on 2019/1/7.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "MerchantSearchCell.h"


@interface MerchantSearchCell()

@property(strong, nonatomic)UILabel *contentLabel;
@end

@implementation MerchantSearchCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}


-(void)initView{
    _contentLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [self addSubview:_contentLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(50)-LineHeight, ScreenWidth, LineHeight)];
    lineView.backgroundColor = cline;
    [self addSubview:lineView];
    
}

-(void)updateData:(NSString *)result{
    _contentLabel.text = result;
    CGSize nameSize = [ _contentLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _contentLabel.frame = CGRectMake(STWidth(15), 0, nameSize.width, STHeight(50));
}


+(NSString *)identify{
    return NSStringFromClass([MerchantSearchCell class]);
}


@end
