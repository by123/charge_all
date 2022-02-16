//
//  STConfirmLayerView.m
//  manage
//
//  Created by by.huang on 2018/12/3.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "STConfirmLayerView.h"

@interface STConfirmLayerView()

@property(copy, nonatomic)NSString *mTitle;
@property(strong, nonatomic)NSMutableArray *mDatas;
@property(strong, nonatomic)NSMutableArray *contentLabels;

@end

@implementation STConfirmLayerView

-(instancetype)initWithTitle:(NSString *)title datas:(NSMutableArray *)datas{
    if(self == [super init]){
        _mTitle = title;
        _mDatas = datas;
        _contentLabels = [[NSMutableArray alloc]init];
        [self initView];
    }
    return self;
}

-(void)initView{
    
    self.frame = CGRectMake(0, 0, ScreenWidth, ContentHeight);
    self.backgroundColor = [cblack colorWithAlphaComponent:0.8];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OnClickLayerView)];
    [self addGestureRecognizer:recognizer];
    
    
    UIView *dialogView = [[UIView alloc]initWithFrame:CGRectMake(0, ContentHeight - STHeight(400), ScreenWidth, STHeight(400))];
    dialogView.backgroundColor = cwhite;
    
    CAShapeLayer *bodyLayer = [[CAShapeLayer alloc] init];
    bodyLayer.frame = dialogView.bounds;
    bodyLayer.path = [UIBezierPath bezierPathWithRoundedRect:dialogView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(STWidth(30), STWidth(30))].CGPath;
    dialogView.layer.mask = bodyLayer;
    
    
    [self addSubview:dialogView];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(20) text:_mTitle textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [titleLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(20)]];
    titleLabel.frame = CGRectMake(0, STHeight(20), ScreenWidth, STHeight(28));
    [dialogView addSubview:titleLabel];
    
    
    if(!IS_NS_COLLECTION_EMPTY(_mDatas)){
        for(int i = 0; i < _mDatas.count ; i ++){
            TitleContentModel *model = [_mDatas objectAtIndex:i];
            UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:model.title textAlignment:NSTextAlignmentLeft textColor:c11 backgroundColor:nil multiLine:NO];
            CGSize titleSize = [model.title sizeWithMaxWidth:ScreenWidth font:STFont(15)];
            titleLabel.frame = CGRectMake(STWidth(40), STHeight(78) + STHeight(36) * i, titleSize.width, STHeight(21));
            [dialogView addSubview:titleLabel];
            
            UILabel *contentLabel = [[UILabel alloc]initWithFont:STFont(15) text:model.content textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:NO];
            CGSize contentSize = [model.content sizeWithMaxWidth:ScreenWidth font:STFont(15)];
            contentLabel.frame = CGRectMake(ScreenWidth - contentSize.width -  STWidth(40), STHeight(78) + STHeight(36) * i, contentSize.width, STHeight(21));
            [dialogView addSubview:contentLabel];
            
            [_contentLabels addObject:contentLabel];
        }
    }
    
    
    UIButton *updateBtn = [[UIButton alloc]initWithFont:STFont(18) text:@"修改" textColor:c10 backgroundColor:cwhite corner:2 borderWidth:LineHeight borderColor:c10];
    updateBtn.frame = CGRectMake(STWidth(60), STHeight(320), STWidth(120), STHeight(42));
    [updateBtn addTarget:self action:@selector(onUpdateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [dialogView addSubview:updateBtn];
    
    
    UIButton *confirmBtn = [[UIButton alloc]initWithFont:STFont(18) text:@"确认" textColor:c21 backgroundColor:c01 corner:2 borderWidth:0 borderColor:nil];
    confirmBtn.frame = CGRectMake(STWidth(195), STHeight(320), STWidth(120), STHeight(42));
    [confirmBtn addTarget:self action:@selector(onConfirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [dialogView addSubview:confirmBtn];
 
}

-(void)updateContents:(NSMutableArray *)datas{
    if(!IS_NS_COLLECTION_EMPTY(datas)){
        for(int i = 0; i < datas.count; i ++){
            TitleContentModel *model = [datas objectAtIndex:i];
            UILabel *contentLabel = [_contentLabels objectAtIndex:i];
            contentLabel.text = model.content;
            CGSize contentSize = [model.content sizeWithMaxWidth:ScreenWidth font:STFont(15)];
            contentLabel.frame = CGRectMake(ScreenWidth - contentSize.width -  STWidth(40), STHeight(78) + STHeight(36) * i, contentSize.width, STHeight(21));

        }
    }
}

-(void)OnClickLayerView{
    self.hidden = YES;
}

-(void)onUpdateBtnClick{
    if(_delegate){
        [_delegate onUpdateBtnClicked];
    }
}

-(void)onConfirmBtnClick{
    if(_delegate){
        [_delegate onConfirmBtnClicked];
    }
}

@end


