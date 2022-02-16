//
//  STListLayerView.m
//  manage
//
//  Created by by.huang on 2019/1/7.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "STListLayerView.h"


@interface STListLayerView()

@property(strong, nonatomic)NSMutableArray *datas;
@property(assign, nonatomic)CGFloat left;
@property(assign, nonatomic)CGFloat top;

@end

@implementation STListLayerView

-(instancetype)initWithDatas:(NSMutableArray *)datas left:(CGFloat)left top:(CGFloat)top{
    if(self == [super init]){
        _datas = datas;
        _left = left;
        _top = top;
        [self initView];
    }
    return self;
}

-(void)initView{
    
    CGFloat itemHeight = STHeight(40);
    self.frame = CGRectMake(_left, _top, STWidth(80), itemHeight * _datas.count);
    self.backgroundColor = cwhite;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowColor = c03.CGColor;
    
    if(!IS_NS_COLLECTION_EMPTY(_datas)){
        for(int i = 0 ; i < _datas.count ; i ++ ){
            UIButton *itemBtn = [[UIButton alloc]initWithFont:STFont(14) text:[_datas objectAtIndex:i] textColor:c11 backgroundColor:cwhite corner:0 borderWidth:0 borderColor:nil];
            [itemBtn setBackgroundColor:c03 forState:UIControlStateHighlighted];
            itemBtn.tag = i;
            itemBtn.frame = CGRectMake(0, i * itemHeight, STWidth(80), itemHeight);
            [itemBtn addTarget:self action:@selector(onItemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:itemBtn];
        }
        
        for(int i = 1 ; i < _datas.count ; i ++ ){
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(5), itemHeight * i, STWidth(70), LineHeight)];
            lineView.backgroundColor = cline;
            [self addSubview:lineView];
        }
    }
}

-(void)onItemBtnClick:(id)sender{
    UIButton *button = sender;
    NSInteger tag = button.tag;
    self.hidden = YES;
    if(_delegate){
        [_delegate onListLayerItemSelected:[_datas objectAtIndex:tag] position:tag];
    }
}

@end
