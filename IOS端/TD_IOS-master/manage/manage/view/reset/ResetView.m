
//
//  ResetView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "ResetView.h"
#import <MediaPlayer/MediaPlayer.h>

#define URL_INTRODUCE @"http://xhdianapp.oss-cn-beijing.aliyuncs.co/action.mp4"

@interface ResetView()

@property(strong, nonatomic)ResetViewModel *mViewModel;
@property(strong, nonatomic)UIScrollView *scrollView;
@property(strong, nonatomic)UILabel *pswLabel;
@property(strong, nonatomic)UIButton *resetBtn;
@property(nonatomic,strong)MPMoviePlayerController *playerController;

@end

@implementation ResetView

-(instancetype)initWithViewModel:(ResetViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
        [self initView];
    }
    return self;
}

-(void)initView{

    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ContentHeight)];
    [self addSubview:_scrollView];
    
    
    [self initTop];
    [self initStep];
    [self initBottom];
    _scrollView.contentSize = CGSizeMake(ScreenWidth, STHeight(810));

}

-(void)initTop{
    UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"操作指引" textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    titleLabel.frame = CGRectMake(0, STHeight(10), ScreenWidth, STHeight(24));
    [_scrollView addSubview:titleLabel];
    
    UIView *leftLine = [[UIView alloc]initWithFrame:CGRectMake(STWidth(48), STHeight(20), STWidth(90), LineHeight)];
    leftLine.backgroundColor = cline;
    [_scrollView addSubview:leftLine];
    
    UIView *rightLine = [[UIView alloc]initWithFrame:CGRectMake(STWidth(237), STHeight(20), STWidth(90), LineHeight)];
    rightLine.backgroundColor = cline;
    [_scrollView addSubview:rightLine];
    
    UIButton *videoView = [[UIButton alloc]initWithFrame:CGRectMake(STWidth(24), STHeight(47), STWidth(327), STHeight(184))];
    videoView.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [videoView addTarget:self action:@selector(onVideoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:videoView];
    
    NSURL *videoUrl = [NSURL URLWithString:URL_INTRODUCE];
    _playerController =[[MPMoviePlayerController alloc]initWithContentURL:videoUrl];
    _playerController.view.frame = CGRectMake(0, 0, STWidth(327), STHeight(184));
    [videoView addSubview: _playerController.view];
    
    //第四步：设置播放器属性
    //设置控制面板风格:无，嵌入，全屏，默认
    _playerController.controlStyle = MPMovieControlStyleDefault;
    //设置是否自动播放(默认为YES）
    _playerController.shouldAutoplay = NO;
    //设置播放器显示模式，类似于图片的处理，设置Fill有可能造成部分区域被裁剪
    _playerController.scalingMode = MPMovieScalingModeAspectFit;
    //设置重复模式
    _playerController.repeatMode = MPMovieRepeatModeNone;
    //第五步：播放视频
    //播放前的准备，会中断当前正在活跃的音频会话
    [ _playerController  prepareToPlay];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(246), STWidth(345), LineHeight)];
    lineView.backgroundColor = cline;
    [_scrollView addSubview:lineView];
}


-(void)initStep{
    [self buildStep:@"第一步" content:@"请在充电器输入密码，并等待按键指示灯闪烁一次" position:STHeight(264)];
    
    UIView *pswView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(25), STHeight(348), STWidth(326), STHeight(92))];
    pswView.backgroundColor = cwhite;
    pswView.layer.shadowOffset = CGSizeMake(1, 1);
    pswView.layer.shadowOpacity = 0.8;
    pswView.layer.shadowColor = c03.CGColor;
    pswView.layer.cornerRadius = 2;
    [_scrollView addSubview:pswView];
    
    _pswLabel = [[UILabel alloc]initWithFont:STFont(30) text:@"***** *****" textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [UILabel changeWordSpaceForLabel:_pswLabel WithSpace:STWidth(5)];
    [_pswLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(30)]];
    _pswLabel.frame =CGRectMake(0, 0, STWidth(326), STHeight(92));
    _pswLabel.textAlignment = NSTextAlignmentCenter;
    [pswView addSubview:_pswLabel];
    
    
    [self updateView:_mViewModel.psw];
    
    [self buildStep:@"第二步" content:@"请点击确认设备密码重置按钮，完成设备密码重置" position:STHeight(448)];
    
    _resetBtn = [[UIButton alloc]initWithFont:STFont(18) text:@"确认密码重置" textColor:c_btn_txt_highlight backgroundColor:c01 corner:2 borderWidth:0 borderColor:nil];
    [_resetBtn setBackgroundColor:c02 forState:UIControlStateHighlighted];
    _resetBtn.frame = CGRectMake(STWidth(122), STHeight(507), STWidth(120), STHeight(42));
    [_resetBtn addTarget:self action:@selector(onResetClicked) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_resetBtn];
}


-(void)buildStep:(NSString *)step content:(NSString *)content position:(CGFloat)height{
    
    UILabel *stepLabel = [[UILabel alloc]initWithFont:STFont(16) text:step textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize stepSize = [step sizeWithMaxWidth:ScreenWidth font:STFont(16) fontName:FONT_MIDDLE];
    stepLabel.frame = CGRectMake(STWidth(15), height, stepSize.width, STHeight(22));
    [stepLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(16)]];
    [_scrollView addSubview:stepLabel];
    
    
    UILabel *contentLabel = [[UILabel alloc]initWithFont:STFont(15) text:content textAlignment:NSTextAlignmentLeft textColor:c11 backgroundColor:nil multiLine:YES];
    CGSize contentSize = [content sizeWithMaxWidth:STWidth(345) font:STFont(15)];
    contentLabel.frame = CGRectMake(STWidth(15), height+STHeight(27), contentSize.width, contentSize.height);
    [_scrollView addSubview:contentLabel];
   
}


-(void)initBottom{
    NSString *tipsStr = @"提示：\n1、请再30秒内完成密码输入\n2、密码输入正确后，按键指示灯将闪烁一次\n3、充电器操作完成后，一定要在本页面点“确认重置密码”";
    UILabel *tipsLabel = [[UILabel alloc]initWithFont:STFont(14) text:tipsStr textAlignment:NSTextAlignmentLeft textColor:c05 backgroundColor:nil multiLine:YES];
    [UILabel changeLineSpaceForLabel:tipsLabel WithSpace:STHeight(5)];
//    CGSize contentSize = [tipsStr sizeWithMaxWidth:STWidth(323) font:STFont(14)];
    tipsLabel.frame = CGRectMake(STWidth(15), STHeight(582), STWidth(323), STHeight(120));
    [_scrollView addSubview:tipsLabel];
    
    
    UILabel *contactLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"如需更多帮助，请联系客服" textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:YES];
    contactLabel.frame = CGRectMake(0, STHeight(727), ScreenWidth, STHeight(21));
    [_scrollView addSubview:contactLabel];
    
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:contactLabel.text];
    NSRange range = NSMakeRange(7, contactLabel.text.length - 7);
    [noteStr addAttribute:NSForegroundColorAttributeName value:c12 range:range];
    [contactLabel setAttributedText:noteStr];
    
    UIButton *contactBtn = [[UIButton alloc]initWithFrame:CGRectMake(STWidth(196), STHeight(727), STWidth(80), STHeight(21))];
    [contactBtn addTarget:self action:@selector(onContactClicked) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:contactBtn];
}

//UI更新
-(void)updateView:(NSString *)psw{
    if(!IS_NS_STRING_EMPTY(psw) && psw.length == 10){
        NSString *front = [psw substringWithRange:NSMakeRange(0, 5)];
        NSString *tail = [psw substringWithRange:NSMakeRange(5, 5)];
        _pswLabel.text = [NSString stringWithFormat:@"%@ %@",front,tail];
        [UILabel changeWordSpaceForLabel:_pswLabel WithSpace:STWidth(5)];
        _pswLabel.frame =CGRectMake(0, 0, STWidth(326), STHeight(92));
        _pswLabel.textAlignment = NSTextAlignmentCenter;
    }
}


//确认重置密码
-(void)onResetClicked{
    if(_mViewModel){
        [_mViewModel confirmReset];
    }
}


//联系客服
-(void)onContactClicked{
    if(_mViewModel){
        [_mViewModel doCall];
    }
}

-(void)onVideoBtnClick{
    [_playerController  play];
}


-(void)dealloc{
    [_playerController stop];
    _playerController = nil;
}


@end

