//
//  STSinglePickerLayerView.m
//  framework
//
//  Created by 黄成实 on 2018/5/28.
//  Copyright © 2018年 黄成实. All rights reserved.
//

#import "STSinglePickerLayerView.h"
#import "UIPickerView+SelectView.h"

@interface STSinglePickerLayerView()<UIPickerViewDataSource,UIPickerViewDelegate>

@property(strong, nonatomic)UIPickerView *pickerView;
@property(strong, nonatomic)UIButton *confirmBtn;
@property(strong, nonatomic)UILabel *mainLabel;
@property(strong, nonatomic)NSMutableArray *mDatas;
@end

@implementation STSinglePickerLayerView{
    NSInteger position;
}

-(instancetype)initWithDatas:(NSMutableArray *)datas{
    if(self == [super init]){
        _mDatas = [[NSMutableArray alloc]init];
        [_mDatas addObjectsFromArray:datas];
        [self initView];
    }
    return self;
}


-(void)initView{
    self.frame = CGRectMake(0, 0, ScreenWidth, ContentHeight);
    self.backgroundColor = [cblack colorWithAlphaComponent:0.8];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OnClickLayerView)];
    [self addGestureRecognizer:recognizer];
    
    
    
    UIView *dialogView = [[UIView alloc]initWithFrame:CGRectMake(0, ContentHeight - STHeight(300), ScreenWidth, STHeight(300))];
    dialogView.backgroundColor = cwhite;
    
    CAShapeLayer *bodyLayer = [[CAShapeLayer alloc] init];
    bodyLayer.frame = dialogView.bounds;
    bodyLayer.path = [UIBezierPath bezierPathWithRoundedRect:dialogView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(STWidth(30), STWidth(30))].CGPath;
    dialogView.layer.mask = bodyLayer;

    
    [self addSubview:dialogView];
    
    

    [dialogView addSubview:[self pickerView]];
    [dialogView addSubview:[self mainLabel]];
    [dialogView addSubview:[self confirmBtn]];
}


-(UIPickerView *)pickerView{
    if(_pickerView == nil){
        _pickerView = [[UIPickerView alloc]initWithDatas:_mDatas];
        _pickerView.frame = CGRectMake(0, STHeight(50), ScreenWidth, STHeight(250));
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.backgroundColor = cwhite;
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}


-(UILabel *)mainLabel{
    if(_mainLabel == nil){
        _mainLabel = [[UILabel alloc]initWithFont:STFont(20) text:@"请选择" textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
        _mainLabel.frame = CGRectMake(0, STHeight(20), ScreenWidth, STHeight(28));
        [_mainLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(20)]];
    }
    return _mainLabel;
}


-(UIButton *)confirmBtn{
    if(_confirmBtn == nil){
        _confirmBtn = [[UIButton alloc]initWithFont:STFont(16) text:MSG_CONFIRM textColor:c11 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil];
        _confirmBtn.frame = CGRectMake(ScreenWidth - STWidth(70), 0, STWidth(70), STWidth(70));
        [_confirmBtn addTarget:self action:@selector(OnClickConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _confirmBtn;
}


-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return STHeight(60);
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//    [STLog print:[NSString stringWithFormat:@"当前position:%ld",(long)row]];
    UILabel *selectLabel = [[UILabel alloc]init];
    selectLabel.text = [_mDatas objectAtIndex:row];
    selectLabel.textColor = c11;
    selectLabel.textAlignment = NSTextAlignmentCenter;
    selectLabel.font = [UIFont systemFontOfSize:STFont(16)];
    if(position == row){
        selectLabel.textColor = c01;
        selectLabel.font = [UIFont fontWithName:FONT_MIDDLE size:STFont(18)];

    }
    
    return selectLabel;

}




-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_mDatas count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if(IS_NS_COLLECTION_EMPTY(_mDatas)){
        return MSG_EMPTY;
    }
    return [_mDatas objectAtIndex:row];
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    position = row;
    [pickerView reloadComponent:component];
}


-(void)OnClickLayerView{
    self.hidden = YES;
}


-(void)OnClickConfirmBtn{
    self.hidden = YES;
    if(IS_NS_COLLECTION_EMPTY(_mDatas)){
        return;
    }
    NSString *resultStr = [_mDatas objectAtIndex:position];
    if(_delegate){
        [_delegate onSelectResult:resultStr layerView:self position:position];
    }
}


-(void)setData:(NSString *)data{
    if(IS_NS_COLLECTION_EMPTY(_mDatas)){
        return;
    }
    
    for(int i = 0 ; i < [_mDatas count] ; i ++){
        NSString *temp = [_mDatas objectAtIndex:i];
        if([temp isEqualToString:data]){
            position = i;
            break;
        }
    }
    
    [_pickerView selectRow:position inComponent:0 animated:YES];
}

-(void)updateDatas:(NSMutableArray *)datas{
    [_mDatas removeAllObjects];
    [_mDatas addObjectsFromArray:datas];;
    [_pickerView reloadAllComponents];
}
    
-(NSMutableArray *)getDatas{
    return _mDatas;
}

-(void)setSelect:(NSInteger)p{
    position = p;
    [_pickerView selectRow:position inComponent:0 animated:YES];
}

@end
