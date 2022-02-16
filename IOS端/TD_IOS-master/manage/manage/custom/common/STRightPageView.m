//
//  STRightPageView.m
//  manage
//
//  Created by by.huang on 2019/1/15.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "STRightPageView.h"

@interface STRightPageView()<UIScrollViewDelegate>

@property(strong, nonatomic)NSMutableArray *mViews;
@property(strong, nonatomic)NSArray *mTitles;
@property(strong, nonatomic)UIScrollView *topScroll;
@property(strong, nonatomic)UIScrollView *scrollView;
@property(strong, nonatomic)UIView *lineView;
@property(strong, nonatomic)NSMutableArray *buttons;
@property(assign, nonatomic)CGFloat perWidth;
@property(assign, nonatomic)CGFloat perLine;
@property(assign, nonatomic)NSInteger mCurrent;


@end

@implementation STRightPageView

-(instancetype)initWithFrame:(CGRect)frame views:(NSMutableArray *)views titles:(NSArray *)titles perLine:(CGFloat)perLine{
    if(self == [super initWithFrame:frame]){
        _perLine = perLine;
        _buttons = [[NSMutableArray alloc]init];
        _mViews = views;
        _mTitles = titles;
        _perWidth = STWidth(70);
        _mCurrent = 0;
        [self initView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame views:(NSMutableArray *)views titles:(NSArray *)titles{
    return [self initWithFrame:frame views:views titles:titles perLine:0.8f];
}

-(void)initView{
    if(IS_NS_COLLECTION_EMPTY(_mTitles) || IS_NS_COLLECTION_EMPTY(_mViews)) return;
    
    [self initContent];
    [self initTop];
    
}

-(void)initTop{
    _topScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(STWidth(15), 0, STWidth(345), STHeight(38))];
    _topScroll.showsHorizontalScrollIndicator = NO;
    _topScroll.showsVerticalScrollIndicator = NO;
    _topScroll.backgroundColor = cwhite;
    [self addSubview:_topScroll];

    
    for(int i = 0 ; i < [_mTitles count] ; i ++ ){
        UIButton *btn = [[UIButton alloc]initWithFont:STFont(16) text:_mTitles[i] textColor:c11 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil];
        btn.tag = i;
        btn.frame = CGRectMake(STWidth(345)  - (_mTitles.count - i) * _perWidth - STWidth(20) * (_mTitles.count - i - 1) , 0, _perWidth, STHeight(38));
        [btn addTarget:self action:@selector(OnItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_topScroll addSubview:btn];
        if(i == 0){
            [btn setTitleColor:c10 forState:UIControlStateNormal];
        }
        [_buttons addObject:btn];
    }
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(345)  - _mTitles.count * _perWidth - STWidth(20) * (_mTitles.count - 1)  + _perWidth *   (1 -_perLine) / 2, STHeight(38) - STWidth(4), _perWidth *  _perLine, STWidth(4))];
    _lineView.backgroundColor = c22;
    [_topScroll addSubview:_lineView];
    
}

-(void)initContent{
    CGFloat height = self.frame.size.height - STHeight(38);
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, STHeight(38), ScreenWidth, height)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    _scrollView.contentSize = CGSizeMake(ScreenWidth * _mTitles.count, height);
    for(int i = 0 ; i < [_mViews count] ; i ++ ){
        UIView *view = [_mViews objectAtIndex:i];
        view.frame = CGRectMake(ScreenWidth * i, 0, ScreenWidth, view.frame.size.height);
        [_scrollView addSubview:view];
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat x =  scrollView.mj_offsetX;
    NSInteger current =  x / ScreenWidth;
    [self changeLinePosition:current];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat x =  scrollView.mj_offsetX;
    CGFloat left = x/ScreenWidth * (_perWidth + STWidth(20));
    _lineView.frame = CGRectMake(STWidth(345)  - _mTitles.count * _perWidth - STWidth(20) * (_mTitles.count - 1)  + _perWidth *   (1 -_perLine) / 2 + left , STHeight(38) - STWidth(4), _perWidth * _perLine, STWidth(4));
//    [STLog print:[NSString stringWithFormat:@"x= %.f",x]];
    
}

-(void)OnItemClicked:(id)sender{
    NSInteger current = ((UIButton *)sender).tag;
    [self changeLinePosition:current];
}


-(void)changeLinePosition:(NSInteger)current{
    _mCurrent = current;
    [self changeTextColor:current];
    [_scrollView setContentOffset:CGPointMake(current * ScreenWidth, 0) animated:YES];
    
//    if(_mTitles.count >= MAX_COUNT+1){
//        //        WS(weakSelf)
//        if(_mTitles.count - current >= MAX_COUNT){
//            [_topScroll setContentOffset:CGPointMake(current * _perWidth, 0) animated:YES];
//        }
        //        if(current == 0 || current == 1){
        //            [UIView animateWithDuration:0.3 animations:^{
        //                weakSelf.topView.frame = CGRectMake(0, 0, weakSelf.perWidth * weakSelf.mTitles.count, STHeight(38));
        //            }];
        //        }else if(current == _mTitles.count -1 || current == _mTitles.count - 2){
        //            [UIView animateWithDuration:0.3 animations:^{
        //                weakSelf.topView.frame = CGRectMake(-((weakSelf.mTitles.count - MAX_COUNT) * weakSelf.perWidth), 0, weakSelf.perWidth * weakSelf.mTitles.count, STHeight(38));
        //            }];
        //        }
        //        else{
        //            [UIView animateWithDuration:0.3 animations:^{
        //                weakSelf.topView.frame = CGRectMake(-(current - 2) * weakSelf.perWidth, 0, weakSelf.perWidth * weakSelf.mTitles.count, STHeight(38));
        //            }];
        //        }
//    }

    if(_delegate){
        [_delegate onPageViewSelect:current view:[_mViews objectAtIndex:current]];
    }
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

-(void)setCurrentTab:(NSInteger)tab{
    [self changeLinePosition:tab];
    
}


-(void)changeFrame:(CGFloat)height{
    self.frame = CGRectMake(0, self.frame.origin.y, ScreenWidth, height);
    _scrollView.frame = CGRectMake(0, STHeight(38), ScreenWidth, height- STHeight(38));
    _scrollView.contentSize = CGSizeMake(ScreenWidth * _mViews.count, height- STHeight(38));
    for(int i = 0 ; i < [_mViews count] ; i ++ ){
        UIView *view = [_mViews objectAtIndex:i];
        view.frame = CGRectMake(ScreenWidth * i, 0, ScreenWidth, height - STHeight(38));
    }
}


-(void)fastenTopView:(CGFloat)top{
    _topScroll.mj_y = top;
    
}


-(id)getCurrentView{
    return [_mViews objectAtIndex:_mCurrent];
}


@end
