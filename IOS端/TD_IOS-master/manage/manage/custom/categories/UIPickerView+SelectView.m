//
//  UIPickerView+SelectView.m
//  manage
//
//  Created by by.huang on 2018/10/31.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "UIPickerView+SelectView.h"

static NSMutableArray *tempDatas;

@implementation UIPickerView(SelectView)

-(instancetype)initWithDatas:(NSMutableArray *)datas{
    if(self == [super init]){
        tempDatas = datas;
    }
    return self;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSDictionary *attrDic = @{NSForegroundColorAttributeName:c01,
                              NSFontAttributeName:[UIFont systemFontOfSize:STFont(18)]};
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[tempDatas objectAtIndex:row] attributes:attrDic];
    
    return attrString;
}
@end
