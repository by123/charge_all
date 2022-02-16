//
//  STSelectLayerButton.m
//  framework
//
//  Created by 黄成实 on 2018/6/6.
//  Copyright © 2018年 黄成实. All rights reserved.
//

#import "STSelectLayerButton.h"

@interface STSelectLayerButton()

@property(strong, nonatomic)UILabel *selectLabel;
@property(strong, nonatomic)UILabel *holderLabel;

@end

@implementation STSelectLayerButton

-(instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        [self initView:frame];
    }
    return self;
}


-(void)initView:(CGRect)rect{
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(rect.size.width  - STWidth(13), (rect.size.height - STWidth(13))/2, STWidth(13), STWidth(13))];
    imageView.image = [UIImage imageNamed:IMAGE_REFRESH];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView];
    
    _holderLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c05 backgroundColor:nil multiLine:NO];
    [self addSubview:_holderLabel];
    
    _selectLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    _selectLabel.hidden = YES;
    [self addSubview:_selectLabel];
}


-(void)setHolderText:(NSString *)text{
    _holderLabel.hidden = NO;
    _selectLabel.hidden = YES;
    _holderLabel.text = text;
    CGSize textSize = [_holderLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _holderLabel.frame = CGRectMake(self.frame.size.width -  STWidth(21) - textSize.width, (self.frame.size.height  - STHeight(15))/2, textSize.width, STHeight(15));

}

-(void)setSelectText:(NSString *)text{
    _holderLabel.hidden = YES;
    _selectLabel.hidden = NO;
    CGSize textSize = [text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    _selectLabel.text = text;
    _selectLabel.frame = CGRectMake(self.frame.size.width -  STWidth(21) - textSize.width, (self.frame.size.height  - STHeight(15))/2, textSize.width, STHeight(15));
}


-(NSString *)getSelectText{
    return _selectLabel.text;
}
@end
