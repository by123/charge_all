//
//  MsgDetailView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "MsgDetailView.h"
#import "STTimeUtil.h"

@interface MsgDetailView()

@property(strong, nonatomic)MsgDetailViewModel *mViewModel;
@property(strong, nonatomic)UILabel *timeLabel;
@property(strong, nonatomic)UILabel *titleLabel;
@property(strong, nonatomic)UIScrollView *scrollView;
@property(assign, nonatomic)CGFloat height;
@property(assign, nonatomic)int count;

@end

@implementation MsgDetailView

-(instancetype)initWithViewModel:(MsgDetailViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        _count = 0;
        [self initView];
    }
    return self;
}

-(void)initView{
    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, 0, ScreenWidth, ContentHeight);
    [self addSubview:_scrollView];
    
    _titleLabel = [[UILabel alloc]initWithFont:STFont(18) text:MSG_EMPTY textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:YES];
    [_titleLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(18)]];
    [_scrollView addSubview:_titleLabel];
    
    _timeLabel = [[UILabel alloc]initWithFont:STFont(12) text:MSG_EMPTY textAlignment:NSTextAlignmentLeft textColor:c05 backgroundColor:nil multiLine:NO];
    [_scrollView addSubview:_timeLabel];
    
}

-(void)updateView{
 
    MsgModel *model = _mViewModel.model;
    
    _titleLabel.text = model.title;
    CGSize titleSize = [_titleLabel.text sizeWithMaxWidth:STWidth(345) font:STFont(18) fontName:FONT_MIDDLE];
    _titleLabel.frame = CGRectMake(STWidth(15), STHeight(10), STWidth(345), titleSize.height);
    
    _timeLabel.text = [STTimeUtil generateDate: LongStr(model.publishTime) format:@"yyyy-MM-dd HH:mm:ss"];
    CGSize timeSize = [_timeLabel.text sizeWithMaxWidth:STWidth(345) font:STFont(12)];
    _timeLabel.frame = CGRectMake(STWidth(15), STHeight(15) + titleSize.height, timeSize.width, STHeight(17));
   
    _height = STHeight(52) + titleSize.height;
    [self add];
    
}

-(void)add{
    MsgModel *model = _mViewModel.model;
    NSMutableArray *datas = [STConvertUtil jsonToDic:model.content];
    if(_count < datas.count){
        if(!IS_NS_COLLECTION_EMPTY(datas)){
            NSMutableDictionary *dic = [datas objectAtIndex:_count];
            NSString *type = [dic objectForKey:@"type"];
            NSString *content = [dic objectForKey:@"content"];
            _count ++;
            if([type isEqualToString:@"img"]){
                [self addImg:content];
            }else if([type isEqualToString:@"text"]){
                [self addLabel:content];
            }
        }
    }
}



-(void)addLabel:(NSString *)text{
    UILabel *cotentLabel = [[UILabel alloc]initWithFont:STFont(14) text:text textAlignment:NSTextAlignmentLeft textColor:c11 backgroundColor:nil multiLine:YES];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.maximumLineHeight = STHeight(27);
    paragraphStyle.minimumLineHeight = STHeight(27);;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    CGFloat baselineOffset = (STHeight(27) - cotentLabel.font.lineHeight) / 4;
    [attributes setObject:@(baselineOffset) forKey:NSBaselineOffsetAttributeName];
    cotentLabel.attributedText = [[NSAttributedString alloc] initWithString:cotentLabel.text attributes:attributes];
    
    CGSize contentSize = [cotentLabel.text sizeWithMaxWidth:STWidth(345) font:STFont(14)];
    CGFloat realHeight = contentSize.height / STFont(14) * STHeight(27);
    cotentLabel.frame = CGRectMake(STWidth(15), _height, STWidth(345), realHeight);
    
    [_scrollView addSubview:cotentLabel];
    _height += realHeight;
    [_scrollView setContentSize:CGSizeMake(ScreenWidth, _height)];
    NSLog(@"执行完成:文字");
    [self add];
}

-(void)addImg:(NSString *)url{
    UIImageView *imageView = [[UIImageView alloc]init];
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:imageView];
    
    WS(weakSelf)
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        CGFloat imgHeight = image.size.height * STWidth(345) / image.size.width;
        imageView.frame = CGRectMake(STWidth(15), weakSelf.height, STWidth(345),imgHeight);
        weakSelf.height += imgHeight;
        [weakSelf.scrollView setContentSize:CGSizeMake(ScreenWidth, weakSelf.height)];
        NSLog(@"执行完成:图片");
        [weakSelf add];
    }];
}

@end

