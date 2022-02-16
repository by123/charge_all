//
//  STYearMonthLayerView.m
//  manage
//
//  Created by by.huang on 2018/11/16.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "STYearMonthLayerView.h"
#import "UIPickerView+SelectView.h"

@interface STYearMonthLayerView()<UIPickerViewDataSource,UIPickerViewDelegate>

@property(strong, nonatomic)UIPickerView *yearPickerView;
@property(strong, nonatomic)UIPickerView *monthPickerView;
@property(strong, nonatomic)UIButton *confirmBtn;
@property(strong, nonatomic)UILabel *mainLabel;
@property(strong, nonatomic)NSMutableArray *mYears;
@property(strong, nonatomic)NSMutableArray *mMonths;

@end

@implementation STYearMonthLayerView{
    NSInteger yearPosition;
    NSInteger monthPosition;

}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        _mYears = [[NSMutableArray alloc]init];
        _mMonths = [[NSMutableArray alloc]init];
        for(int i = 2018 ; i <= 2118 ; i ++){
            [_mYears addObject:[NSString stringWithFormat:@"%d",i]];
        }
        for(int i = 1 ; i <= 12 ; i ++){
            [_mMonths addObject:[NSString stringWithFormat:@"%d",i]];
        }
        [self initView];
    }
    return self;
}


-(void)initView{
    self.backgroundColor = [cblack colorWithAlphaComponent:0.8];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OnClickLayerView)];
    [self addGestureRecognizer:recognizer];    
    
    
    UIView *dialogView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - STHeight(300), ScreenWidth, STHeight(300))];
    dialogView.backgroundColor = cwhite;
    
    CAShapeLayer *bodyLayer = [[CAShapeLayer alloc] init];
    bodyLayer.frame = dialogView.bounds;
    bodyLayer.path = [UIBezierPath bezierPathWithRoundedRect:dialogView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(STWidth(30), STWidth(30))].CGPath;
    dialogView.layer.mask = bodyLayer;
    
    
    [self addSubview:dialogView];
    
    
    
    [dialogView addSubview:[self yearPickerView]];
    [dialogView addSubview:[self monthPickerView]];
    [dialogView addSubview:[self mainLabel]];
    [dialogView addSubview:[self confirmBtn]];
}


-(UIPickerView *)yearPickerView{
    if(_yearPickerView == nil){
        _yearPickerView = [[UIPickerView alloc]initWithDatas:_mYears];
        _yearPickerView.frame = CGRectMake(0, STHeight(50), ScreenWidth/2, STHeight(250));
        _yearPickerView.showsSelectionIndicator = YES;
        _yearPickerView.backgroundColor = cwhite;
        _yearPickerView.delegate = self;
        _yearPickerView.dataSource = self;
    }
    return _yearPickerView;
}


-(UIPickerView *)monthPickerView{
    if(_monthPickerView == nil){
        _monthPickerView = [[UIPickerView alloc]initWithDatas:_mMonths];
        _monthPickerView.frame = CGRectMake(ScreenWidth/2, STHeight(50), ScreenWidth/2, STHeight(250));
        _monthPickerView.showsSelectionIndicator = YES;
        _monthPickerView.backgroundColor = cwhite;
        _monthPickerView.delegate = self;
        _monthPickerView.dataSource = self;
    }
    return _monthPickerView;
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
    UILabel *selectLabel = [[UILabel alloc]init];
    selectLabel.textColor = c11;
    selectLabel.textAlignment = NSTextAlignmentCenter;
    selectLabel.font = [UIFont systemFontOfSize:STFont(16)];
    if(pickerView == _yearPickerView){
        selectLabel.text = [_mYears objectAtIndex:row];
        if(yearPosition == row){
            selectLabel.textColor = c01;
            selectLabel.font = [UIFont fontWithName:FONT_MIDDLE size:STFont(18)];
        }
    }else if(pickerView == _monthPickerView){
        selectLabel.text = [_mMonths objectAtIndex:row];
        if(monthPosition == row){
            selectLabel.textColor = c01;
            selectLabel.font = [UIFont fontWithName:FONT_MIDDLE size:STFont(18)];
        }
    }
    
    return selectLabel;
    
}




-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(pickerView == _yearPickerView){
        return [_mYears count];
    }
    return [_mMonths count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if(IS_NS_COLLECTION_EMPTY(_mYears) || IS_NS_COLLECTION_EMPTY(_mMonths)){
        return MSG_EMPTY;
    }
    if(pickerView == _yearPickerView){
        return [_mYears objectAtIndex:row];
    }
    return [_mMonths objectAtIndex:row];
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(pickerView == _yearPickerView){
        yearPosition = row;
    }else if(pickerView == _monthPickerView){
        monthPosition = row;
    }
    [pickerView reloadComponent:component];
}


-(void)OnClickLayerView{
    self.hidden = YES;
}


-(void)OnClickConfirmBtn{
    self.hidden = YES;
    NSString *yearStr = [_mYears objectAtIndex:yearPosition];
    NSString *monthStr = [_mMonths objectAtIndex:monthPosition];
    NSString *resultStr = [NSString stringWithFormat:@"%@年%@月",yearStr,monthStr];

    if(_delegate){
        [_delegate onSelectResult:resultStr layerView:self yearposition:[yearStr intValue] monthposition:[monthStr intValue]];
    }
}


-(void)setData:(NSString *)year month:(NSString *)month{
    if(IS_NS_COLLECTION_EMPTY(_mYears) || IS_NS_COLLECTION_EMPTY(_mMonths)){
        return;
    }
    
    for(int i = 0 ; i < [_mYears count] ; i ++){
        NSString *temp = [_mYears objectAtIndex:i];
        if([temp isEqualToString:year]){
            yearPosition = i;
            break;
        }
    }
    
    
    for(int i = 0 ; i < [_mMonths count] ; i ++){
        NSString *temp = [_mMonths objectAtIndex:i];
        if([temp isEqualToString:month]){
            monthPosition = i;
            break;
        }
    }
    
    [_yearPickerView selectRow:yearPosition inComponent:0 animated:YES];
    [_monthPickerView selectRow:monthPosition inComponent:0 animated:YES];
}

@end
