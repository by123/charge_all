//
//  STYearMonthDayLayerView.m
//  manage
//
//  Created by by.huang on 2019/1/17.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "STYearMonthDayLayerView.h"
#import "UIPickerView+SelectView.h"
#import "STTimeUtil.h"

@interface STYearMonthDayLayerView()<UIPickerViewDataSource,UIPickerViewDelegate>

@property(strong, nonatomic)UIPickerView *yearPickerView;
@property(strong, nonatomic)UIPickerView *monthPickerView;
@property(strong, nonatomic)UIPickerView *dayPickerView;
@property(strong, nonatomic)UIButton *confirmBtn;
@property(strong, nonatomic)UILabel *mainLabel;
@property(strong, nonatomic)NSMutableArray *mYears;
@property(strong, nonatomic)NSMutableArray *mMonths;
@property(strong, nonatomic)NSMutableArray *mDays;

@end

@implementation STYearMonthDayLayerView{
    NSInteger yearPosition;
    NSInteger monthPosition;
    NSInteger dayPosition;

}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        _mYears = [[NSMutableArray alloc]init];
        _mMonths = [[NSMutableArray alloc]init];
        _mDays = [[NSMutableArray alloc]init];
        for(int i = 2018 ; i <= 2118 ; i ++){
            [_mYears addObject:[NSString stringWithFormat:@"%d",i]];
        }
        for(int i = 1 ; i <= 12 ; i ++){
            [_mMonths addObject:[NSString stringWithFormat:@"%d",i]];
        }
        for(int i = 1 ; i <= 31 ; i ++){
            [_mDays addObject:[NSString stringWithFormat:@"%d",i]];
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
    [dialogView addSubview:[self dayPickerView]];
    [dialogView addSubview:[self mainLabel]];
    [dialogView addSubview:[self confirmBtn]];
}


-(UIPickerView *)yearPickerView{
    if(_yearPickerView == nil){
        _yearPickerView = [[UIPickerView alloc]initWithDatas:_mYears];
        _yearPickerView.frame = CGRectMake(0, STHeight(50), ScreenWidth/3, STHeight(250));
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
        _monthPickerView.frame = CGRectMake(ScreenWidth /3, STHeight(50), ScreenWidth/3, STHeight(250));
        _monthPickerView.showsSelectionIndicator = YES;
        _monthPickerView.backgroundColor = cwhite;
        _monthPickerView.delegate = self;
        _monthPickerView.dataSource = self;
    }
    return _monthPickerView;
}

-(UIPickerView *)dayPickerView{
    if(_dayPickerView == nil){
        _dayPickerView = [[UIPickerView alloc]initWithDatas:_mDays];
        _dayPickerView.frame = CGRectMake(ScreenWidth * 2/3, STHeight(50), ScreenWidth/3, STHeight(250));
        _dayPickerView.showsSelectionIndicator = YES;
        _dayPickerView.backgroundColor = cwhite;
        _dayPickerView.delegate = self;
        _dayPickerView.dataSource = self;
    }
    return _dayPickerView;
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
    }else if(pickerView == _dayPickerView){
        selectLabel.text = [_mDays objectAtIndex:row];
        if(dayPosition == row){
            selectLabel.textColor = c01;
            selectLabel.font = [UIFont fontWithName:FONT_MIDDLE size:STFont(18)];
        }
    }
    
    return selectLabel;
    
}




-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(pickerView == _yearPickerView){
        return [_mYears count];
    }else if(pickerView == _monthPickerView){
        return [_mMonths count];
    }else{
        return [_mDays count];
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if(IS_NS_COLLECTION_EMPTY(_mYears) || IS_NS_COLLECTION_EMPTY(_mMonths) || IS_NS_COLLECTION_EMPTY(_mDays)){
        return MSG_EMPTY;
    }
    if(pickerView == _yearPickerView){
        return [_mYears objectAtIndex:row];
    }else if(pickerView == _monthPickerView){
        return [_mMonths objectAtIndex:row];
    }else{
        return [_mDays objectAtIndex:row];
    }
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(pickerView == _yearPickerView){
        yearPosition = row;
        [self updateDays];
    }else if(pickerView == _monthPickerView){
        monthPosition = row;
        [self updateDays];
    }else{
        dayPosition = row;
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
    NSString *dayStr = [_mDays objectAtIndex:dayPosition];
    NSString *resultStr = [NSString stringWithFormat:@"%@年%@月%@日",yearStr,monthStr,dayStr];
    
    if(_delegate){
        [_delegate onSelectResult:resultStr layerView:self yearposition:[yearStr intValue] monthposition:[monthStr intValue] daypostion:[dayStr intValue]];
    }
}


-(void)setData:(NSString *)year month:(NSString *)month day:(NSString *)day{
    if(IS_NS_COLLECTION_EMPTY(_mYears) || IS_NS_COLLECTION_EMPTY(_mMonths) || IS_NS_COLLECTION_EMPTY(_mDays)){
        return;
    }
    
    for(int i = 0 ; i < [_mYears count] ; i ++){
        NSString *temp = [_mYears objectAtIndex:i];
        if([temp intValue] == [year intValue]){
            yearPosition = i;
            break;
        }
    }
    
    
    for(int i = 0 ; i < [_mMonths count] ; i ++){
        NSString *temp = [_mMonths objectAtIndex:i];
        if([temp intValue] == [month intValue]){
            monthPosition = i;
            break;
        }
    }
    
    [self updateDays];
    for(int i = 0 ; i < [_mDays count] ; i ++){
        NSString *temp = [_mDays objectAtIndex:i];
        if([temp intValue] == [day intValue]){
            dayPosition = i;
            break;
        }
    }
    
    [_yearPickerView selectRow:yearPosition inComponent:0 animated:YES];
    [_monthPickerView selectRow:monthPosition inComponent:0 animated:YES];
    [_dayPickerView selectRow:dayPosition inComponent:0 animated:YES];
}

-(void)updateDays{
    NSString *year = [_mYears objectAtIndex:yearPosition];
    NSString *month = [_mMonths objectAtIndex:monthPosition];
    NSInteger count = [STTimeUtil getMaxDay:year month:month];
    [_mDays removeAllObjects];
    
    
    for(int i = 1 ; i <= count ; i ++){
        [_mDays addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [_dayPickerView reloadAllComponents];
}

@end

