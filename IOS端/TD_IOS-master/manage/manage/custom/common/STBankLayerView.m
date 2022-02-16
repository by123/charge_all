//
//  STBankLayerView.m
//  manage
//
//  Created by by.huang on 2018/12/4.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "STBankLayerView.h"
#import "UIPickerView+SelectView.h"
#import "STConvertUtil.h"

@interface STBankLayerView()<UIPickerViewDataSource,UIPickerViewDelegate>

@property(strong, nonatomic)UIPickerView *pickerView;
@property(strong, nonatomic)UIButton *confirmBtn;
@property(strong, nonatomic)UILabel *mainLabel;
@property(strong, nonatomic)NSMutableArray *mPickerDatas;
@property(strong, nonatomic)NSMutableArray *mDatas;
@property(strong, nonatomic)UIView *dialogView;
@end

@implementation STBankLayerView{
    NSInteger position;
}

-(instancetype)init{
    if(self == [super init]){
        _mPickerDatas = [[NSMutableArray alloc]init];
        _mDatas = [[NSMutableArray alloc]init];
        [self initView];
    }
    return self;
}


-(void)getBankList{
    WS(weakSelf)
    NSURL *url = [NSURL URLWithString:URL_BANK];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *sessionDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(data){
            NSString *result =[[ NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            dispatch_main_async_safe(^{
                [weakSelf updateView:result];
            });
        }
    }];
    [sessionDataTask resume];
}

-(void)initView{
    self.frame = CGRectMake(0, 0, ScreenWidth, ContentHeight);
    self.backgroundColor = [cblack colorWithAlphaComponent:0.8];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(OnClickLayerView)];
    [self addGestureRecognizer:recognizer];
    
    
    
    _dialogView = [[UIView alloc]initWithFrame:CGRectMake(0, ContentHeight - STHeight(300), ScreenWidth, STHeight(300))];
    _dialogView.backgroundColor = cwhite;
    
    CAShapeLayer *bodyLayer = [[CAShapeLayer alloc] init];
    bodyLayer.frame = _dialogView.bounds;
    bodyLayer.path = [UIBezierPath bezierPathWithRoundedRect:_dialogView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(STWidth(30), STWidth(30))].CGPath;
    _dialogView.layer.mask = bodyLayer;
    [self addSubview:_dialogView];
    
    [_dialogView addSubview:[self mainLabel]];
    [_dialogView addSubview:[self confirmBtn]];
    [self getBankList];

}


-(void)updateView:(NSString *)result{
    NSMutableArray *array = (NSMutableArray *)[STConvertUtil jsonToDic:result];
    if(!IS_NS_COLLECTION_EMPTY(array)){
        for(NSDictionary *dic in array){
            id obj = [dic objectForKey:@"node"];
            BankSelectModel *model = [BankSelectModel mj_objectWithKeyValues:obj];
            [_mPickerDatas addObject:model.bank_name];
            [_mDatas addObject:model];
        }
    }
    [_dialogView addSubview:[self pickerView]];
}

-(UIPickerView *)pickerView{
    if(_pickerView == nil){
        _pickerView = [[UIPickerView alloc]initWithDatas:_mPickerDatas];
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
    selectLabel.text = [_mPickerDatas objectAtIndex:row];
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
    return [_mPickerDatas count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if(IS_NS_COLLECTION_EMPTY(_mPickerDatas)){
        return MSG_EMPTY;
    }
    return [_mPickerDatas objectAtIndex:row];
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    position = row;
    [pickerView reloadComponent:component];
}

    
-(void)updatePosition:(BankSelectModel *)model{
    if(!IS_NS_COLLECTION_EMPTY(_mPickerDatas)){
        for(int i = 0 ; i < _mPickerDatas.count ; i ++){
            NSString *bankName = [_mPickerDatas objectAtIndex:i];
            if([model.bank_name isEqualToString:bankName]){
                position = i;
                break;
            }
        }
    }
}


-(void)OnClickLayerView{
    self.hidden = YES;
}


-(void)OnClickConfirmBtn{
    self.hidden = YES;
    if(IS_NS_COLLECTION_EMPTY(_mDatas)){
        return;
    }
    BankSelectModel *model = [_mDatas objectAtIndex:position];
    if(_delegate){
        [_delegate onSelectResult:model layerView:self position:position];
    }
}


-(BankSelectModel *)getCurrentModel{
    if(IS_NS_COLLECTION_EMPTY(_mDatas)){
        return nil;
    }
    return [_mDatas objectAtIndex:position];
}


@end
