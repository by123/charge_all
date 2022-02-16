//
//  STPageLineView.m
//  manage
//
//  Created by by.huang on 2018/12/7.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "STPageLineView.h"

#define MAX_COUNT 5
@interface STPageLineView()

@property(strong, nonatomic)NSArray *mTitles;
@property(strong, nonatomic)UIView *lineView;
@property(strong, nonatomic)NSMutableArray *buttons;
@property(strong, nonatomic)UIView *topView;
@property(assign, nonatomic)CGFloat perWidth;
@property(assign, nonatomic)CGFloat perLine;

@end

@implementation STPageLineView

-(instancetype)initWithTitles:(NSArray *)titles{
    if(self == [super init]){
        _perLine = 0.4;
        _buttons = [[NSMutableArray alloc]init];
        _mTitles = titles;
        _perWidth = (ScreenWidth / [_mTitles count]);
        if(_mTitles.count >= MAX_COUNT){
            _perWidth = ScreenWidth / MAX_COUNT;
        }
        [self initView];
    }
    return self;
}


-(void)initView{
    _topView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _perWidth * _mTitles.count, STHeight(38))];
    [self addSubview:_topView];
    
    for(int i = 0 ; i < [_mTitles count] ; i ++ ){
        UIButton *btn = [[UIButton alloc]initWithFont:STFont(16) text:_mTitles[i] textColor:c11 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil];
        btn.tag = i;
        btn.frame = CGRectMake(_perWidth * i, 0, _perWidth, STHeight(38));
        [btn addTarget:self action:@selector(OnItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:btn];
        if(i == 0){
            [btn setTitleColor:c10 forState:UIControlStateNormal];
        }
        [_buttons addObject:btn];
    }
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(_perWidth *  (1 - _perLine)/2 , STHeight(38) - STWidth(4), _perWidth *  _perLine, STWidth(4))];
    _lineView.backgroundColor = c01;
    [_topView addSubview:_lineView];
}

-(void)OnItemClicked:(id)sender{
    NSInteger current = ((UIButton *)sender).tag;
    [self changeLinePosition:current];
}


-(void)changeLinePosition:(NSInteger)current{
    [self changeTextColor:current];
    
    if(_mTitles.count >= MAX_COUNT+1){
        WS(weakSelf)
        if(current == 0 || current == 1){
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.topView.frame = CGRectMake(0, 0, weakSelf.perWidth * weakSelf.mTitles.count, STHeight(38));
            }];
        }else if(current == _mTitles.count -1 || current == _mTitles.count - 2){
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.topView.frame = CGRectMake(-((weakSelf.mTitles.count - MAX_COUNT) * weakSelf.perWidth), 0, weakSelf.perWidth * weakSelf.mTitles.count, STHeight(38));
            }];
        }
        else{
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.topView.frame = CGRectMake(-(current - 2) * weakSelf.perWidth, 0, weakSelf.perWidth * weakSelf.mTitles.count, STHeight(38));
            }];
        }
    }
    
//    if(_delegate){
//        [_delegate onPageViewSelect:current view:[_mViews objectAtIndex:current]];
//    }
}

-(void)changeTextColor:(NSInteger)current{
    if(!IS_NS_COLLECTION_EMPTY(_buttons)){
        for(int i = 0; i < _buttons.count ; i ++){
            UIButton *tempBtn = [_buttons objectAtIndex:i];
            if(i == current){
                [tempBtn setTitleColor:c10 forState:UIControlStateNormal];
            }else{
                [tempBtn setTitleColor:c11 forState:UIControlStateNormal];
            }
        }
    }
}

@end
