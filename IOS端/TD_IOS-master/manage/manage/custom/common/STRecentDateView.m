//
//  STRecentDateView.m
//  manage
//
//  Created by by.huang on 2019/6/18.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "STRecentDateView.h"

@interface STRecentDateView()

@property(strong, nonatomic)NSMutableArray *buttons;
@property(assign, nonatomic)NSInteger selectPosition;
@property(strong, nonatomic)NSArray *btnStrs;

@end


@implementation STRecentDateView

-(instancetype)init{
    if(self == [super init]){
        _buttons = [[NSMutableArray alloc]init];
        _btnStrs = @[@"今日",@"最近7天",@"最近30天"];
        [self initView];
    }
    return self;
}

-(void)initView{
    
    NSString *titleStr = @"日期范围";
    UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(14) text:titleStr textAlignment:NSTextAlignmentCenter textColor:c05 backgroundColor:nil multiLine:NO];
    CGSize titleSize = [titleStr sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    titleLabel.frame = CGRectMake(STWidth(15), 0, titleSize.width, STHeight(21));
    [self addSubview:titleLabel];
    
    CGFloat left = STWidth(70);
    for(int i = 0; i < _btnStrs.count ; i ++){
        UIButton *dateBtn = [[UIButton alloc]initWithFont:STFont(12) text:_btnStrs[i] textColor:c05 backgroundColor:nil corner:2 borderWidth:LineHeight borderColor:c05];
        CGSize dateSize = [_btnStrs[i] sizeWithMaxWidth:ScreenWidth font:STFont(12)];
        dateBtn.frame = CGRectMake(left + STWidth(10), 0, STWidth(20) + dateSize.width, STHeight(21));
        dateBtn.tag = i;
        [dateBtn addTarget:self action:@selector(onDateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if(i == 0){
            [dateBtn setTitleColor:c10 forState:UIControlStateNormal];
            dateBtn.layer.borderColor = c10.CGColor;
        }
        [self addSubview:dateBtn];
        [_buttons addObject:dateBtn];
        left += STWidth(30) + dateSize.width;
    }
}

-(void)onDateBtnClick:(id)sender{
    UIButton *btn = sender;
    NSInteger tag = btn.tag;
    //上次选中按钮处理
    if(_selectPosition >= 0){
        UIButton *lastSelectBtn = [_buttons objectAtIndex:_selectPosition];
        [lastSelectBtn setTitleColor:c05 forState:UIControlStateNormal];
        lastSelectBtn.layer.borderColor = c05.CGColor;
    }
    //当前选中按钮处理
    UIButton *selectBtn = [_buttons objectAtIndex:tag];
    [selectBtn setTitleColor:c10 forState:UIControlStateNormal];
    selectBtn.layer.borderColor = c10.CGColor;
    //
    _selectPosition = tag;
    if(_delegate){
        [_delegate onRecentDateViewSelected:_selectPosition str:_btnStrs[_selectPosition]];
    }
}

-(void)setRecentDateSelect:(int)position{
    //上次选中按钮处理
    if(_selectPosition >= 0){
        UIButton *lastSelectBtn = [_buttons objectAtIndex:_selectPosition];
        [lastSelectBtn setTitleColor:c05 forState:UIControlStateNormal];
        lastSelectBtn.layer.borderColor = c05.CGColor;
    }
    //当前选中按钮处理
    UIButton *selectBtn = [_buttons objectAtIndex:position];
    [selectBtn setTitleColor:c10 forState:UIControlStateNormal];
    selectBtn.layer.borderColor = c10.CGColor;
    //
    _selectPosition = position;
}

-(void)clearAllDateSelect{
    //上次选中按钮处理
    if(_selectPosition >= 0){
        UIButton *lastSelectBtn = [_buttons objectAtIndex:_selectPosition];
        [lastSelectBtn setTitleColor:c05 forState:UIControlStateNormal];
        lastSelectBtn.layer.borderColor = c05.CGColor;
        _selectPosition = -1;
    }
}

@end
