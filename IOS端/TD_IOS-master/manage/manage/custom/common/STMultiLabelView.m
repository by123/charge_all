//
//  STMultiLabelView.m
//  manage
//
//  Created by by.huang on 2019/6/18.
//  Copyright © 2019 by.huang. All rights reserved.
//

#import "STMultiLabelView.h"
@interface STMultiLabelView()

@property(strong, nonatomic)NSMutableArray *titleLabels;
@property(strong, nonatomic)NSMutableArray *lineViews;

@end

@implementation STMultiLabelView{
    NSArray *titles;
}


-(instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        _titleLabels = [[NSMutableArray alloc]init];
        _lineViews = [[NSMutableArray alloc]init];
        titles = @[@"直属拓展代理:",@"直属拓展商户:",@"下级拓展代理:",@"下级拓展商户:"];
        [self initView];
    }
    return self;
}

-(void)initView{
    for(int i = 0 ; i < titles.count; i++){
        UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(14) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
        titleLabel.tag = i;
        [self addSubview:titleLabel];
        [_titleLabels addObject:titleLabel];
        
        if(i % 2 == 0){
            UIView *lineView = [[UIView alloc]init];
            lineView.backgroundColor = cline;
            lineView.tag = i / 2;
            [self addSubview:lineView];
            [_lineViews addObject:lineView];
        }
    }
    
    self.frame = CGRectMake(STWidth(15), self.frame.origin.y, STWidth(345), STHeight(80));
}

-(void)setDatas:(NSArray *)numbers{
    if(!IS_NS_COLLECTION_EMPTY(numbers) && (numbers.count == titles.count)){
        CGFloat left = 0;
        for(int i = 0 ; i < numbers.count ; i ++ ){
            UILabel *titleLabel = [_titleLabels objectAtIndex:i];
            titleLabel.text  = [NSString stringWithFormat:@"%@%@家",titles[i],numbers[i]];
            CGSize titleSize = [titleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
            if(i % 2 == 0){
                titleLabel.frame = CGRectMake(0,STHeight(15) + STHeight(30) * (i/2), titleSize.width, STHeight(20));
                left += STWidth(32) + titleSize.width;
            }else{
                
                UIView *lineView = [_lineViews objectAtIndex:(i/2)];
                lineView.frame = CGRectMake(left-STWidth(16),STHeight(20) + STHeight(30) * (i/2), LineHeight, STHeight(10));
                
                titleLabel.frame = CGRectMake(left, STHeight(15) + STHeight(30) * (i/2), titleSize.width, STHeight(20));
                left = 0;
            }
        }
    }
    
    

}


@end
