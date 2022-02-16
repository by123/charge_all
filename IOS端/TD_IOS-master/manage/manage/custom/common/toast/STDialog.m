//
//  STDialog.m
//  manage
//
//  Created by by.huang on 2019/5/21.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "STDialog.h"
@interface STDialog()

@property(copy, nonatomic)NSString *title;
@property(copy, nonatomic)NSString *content;
@property(copy, nonatomic)NSString *subContent;
@property(assign, nonatomic)CGSize size;
@property(strong,nonatomic)UIView *bodyView;

@end

@implementation STDialog

-(instancetype)initWithTitle:(NSString *)title content:(NSString *)content subContent:(NSString *)subContent size:(CGSize)size{
    if(self == [super init]){
        self.title = title;
        self.content = content;
        self.subContent = subContent;
        self.size = size;
        [self initView];
    }
    return self;
}

-(void)initView{
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.backgroundColor = [cblack colorWithAlphaComponent:0.7];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 2;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    _bodyView = [[UIView alloc]initWithFrame:CGRectMake((ScreenWidth - _size.width)/2 , (ScreenHeight - _size.height)/2, _size.width, _size.height)];
    _bodyView.backgroundColor = cwhite;
    [self addSubview:_bodyView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _size.height - STHeight(50) - LineHeight, _size.width, LineHeight)];
    lineView.backgroundColor = cline;
    [_bodyView addSubview:lineView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(18) text:_title textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    titleLabel.frame = CGRectMake(0, STHeight(20), _size.width, STHeight(25));
    [titleLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(18)]];
    [_bodyView addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc]initWithFont:STFont(15) text:_content textAlignment:NSTextAlignmentLeft textColor:c11 backgroundColor:nil multiLine:YES];
    CGSize contentSize = [contentLabel.text sizeWithMaxWidth:_size.width - STWidth(120) font:STFont(15)];
    contentLabel.frame = CGRectMake(STWidth(60), STHeight(65), _size.width - STWidth(120), contentSize.height);
    [_bodyView addSubview:contentLabel];
    
    UILabel *subContentLabel = [[UILabel alloc]initWithFont:STFont(16) text:_subContent textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    subContentLabel.frame = CGRectMake(0, STHeight(114), _size.width, STHeight(22));
    [subContentLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(16)]];
    [_bodyView addSubview:subContentLabel];
    
}


-(void)showConfirmBtn:(Boolean)confirm cancelBtn:(Boolean)cancel{
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFont:STFont(16) text:MSG_CANCEL textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil];
    [cancelBtn addTarget:self action:@selector(onCancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bodyView addSubview:cancelBtn];

    UIButton *confirmBtn = [[UIButton alloc]initWithFont:STFont(16) text:MSG_CONFIRM textColor:c10 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil];
    [confirmBtn addTarget:self action:@selector(onConfirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bodyView addSubview:confirmBtn];
    
    if(cancel && confirm){
        cancelBtn.frame = CGRectMake(0,  _size.height - STHeight(50), _size.width/2, STHeight(50));
        confirmBtn.frame = CGRectMake(_size.width/2,  _size.height - STHeight(50), _size.width/2, STHeight(50));
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(_size.width/2-LineHeight, _size.height - STHeight(50), LineHeight, STHeight(50))];
        lineView.backgroundColor = cline;
        [_bodyView addSubview:lineView];
        return;
    }
    
    if(cancel && !confirm){
        cancelBtn.frame = CGRectMake(0, _size.height - STHeight(50), _size.width, STHeight(50));
        confirmBtn.hidden = YES;
        return;
    }
    
    if(!cancel && confirm){
        confirmBtn.frame = CGRectMake(0, _size.height - STHeight(50), _size.width, STHeight(50));
        cancelBtn.hidden = YES;
        return;
    }
    
}

-(void)onConfirmBtnClick{
    if(_delegate){
        [_delegate onConfirmBtnClicked];
    }
}

-(void)onCancelBtnClick{
    if(_delegate){
        [_delegate onCancelBtnClicked];
    }
}

@end
