//
//  STPerformanceSearchView.m
//  manage
//
//  Created by by.huang on 2019/6/18.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "STPerformanceSearchView.h"

@interface STPerformanceSearchView()<UITextFieldDelegate>

@property(strong, nonatomic)NSMutableArray *buttons;
@property(assign, nonatomic)NSInteger selectPosition;
@property(strong, nonatomic)UITextField *textFiled;
@property(assign, nonatomic)Boolean searchBtnHidden;

@end

@implementation STPerformanceSearchView{
    NSArray *btnStrs;
}

-(instancetype)initWithSearchView:(CGRect)frame searchBtn:(Boolean)hidden{
    if(self == [super initWithFrame:frame]){
        _searchBtnHidden = hidden;
        _buttons = [[NSMutableArray alloc]init];
        btnStrs = @[@"直属拓展",@"下级拓展"];
        [self initView];
    }
    return self;
}

-(void)initView{
    if(!_searchBtnHidden){
        [self initSelectBtn];
    }
    [self initSearchView];
}

-(void)initSelectBtn{
    CGFloat left = STWidth(15);
    for(int i = 0; i < btnStrs.count ; i++){
        UIButton *agentBtn = [[UIButton alloc]initWithFont:STFont(12) text:btnStrs[i] textColor:c05 backgroundColor:nil corner:2 borderWidth:LineHeight borderColor:c05];
        CGSize dateSize = [btnStrs[i] sizeWithMaxWidth:ScreenWidth font:STFont(12)];
        agentBtn.frame = CGRectMake(left, STHeight(15), STWidth(20) + dateSize.width, STHeight(25));
        agentBtn.tag = i;
        [agentBtn addTarget:self action:@selector(onAgentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if(i == 0){
            [agentBtn setTitleColor:cwhite forState:UIControlStateNormal];
            agentBtn.layer.borderColor = c01.CGColor;
            agentBtn.backgroundColor = c01;
        }
        [self addSubview:agentBtn];
        [_buttons addObject:agentBtn];
        left += STWidth(30) + dateSize.width;
    }
}


-(void)onAgentBtnClick:(id)sender{
    UIButton *btn = sender;
    NSInteger tag = btn.tag;
    //上次选中按钮处理
    UIButton *lastSelectBtn = [_buttons objectAtIndex:_selectPosition];
    [lastSelectBtn setTitleColor:c05 forState:UIControlStateNormal];
    lastSelectBtn.layer.borderColor = c05.CGColor;
    lastSelectBtn.backgroundColor = cwhite;
    //当前选中按钮处理
    UIButton *selectBtn = [_buttons objectAtIndex:tag];
    [selectBtn setTitleColor:cwhite forState:UIControlStateNormal];
    selectBtn.layer.borderColor = c01.CGColor;
    selectBtn.backgroundColor = c01;
    //
    _selectPosition = tag;
    if(_delegate){
        [_delegate onPerformanceSearchBtnSelected:_selectPosition content:btnStrs[tag]];
    }
}



-(void)initSearchView{
    _textFiled = [[UITextField alloc]initWithFont:STFont(14) textColor:c10 backgroundColor:cbg corner:2 borderWidth:0 borderColor:0 padding:STWidth(40)];
    _textFiled.textAlignment = NSTextAlignmentLeft;
    if(_searchBtnHidden){
        _textFiled.frame = CGRectMake(STWidth(15), STHeight(15) , STWidth(260),STHeight(36));
    }else{
        _textFiled.frame = CGRectMake(STWidth(15), STHeight(55) , STWidth(260),STHeight(36));
    }
    _textFiled.delegate = self;
    _textFiled.clearButtonMode=UITextFieldViewModeWhileEditing;
    _textFiled.returnKeyType = UIReturnKeySearch;
    [_textFiled setPlaceholder:@"请输入代理商名称" color:c05 fontSize:STFont(14)];
    [_textFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_textFiled];
    
    UIImageView *searchImageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(15), (STHeight(36)-STWidth(14))/2, STWidth(14), STWidth(14))];
    searchImageView.image = [UIImage imageNamed:IMAGE_SEARCH];
    searchImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_textFiled addSubview:searchImageView];
}


-(void)hiddenKeyboard{
    [_textFiled resignFirstResponder];
}

- (void)textFieldDidChange:(UITextField *)textField{
    if(_delegate){
        [_delegate onPerformanceSearchTextFieldChange:textField.text];
    }
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_textFiled resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if(_delegate){
        [_delegate onPerformanceSearchClicked:textField.text];
    }
    return YES;
}


@end
