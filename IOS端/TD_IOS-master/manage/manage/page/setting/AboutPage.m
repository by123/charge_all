//
//  AboutPage.m
//  manage
//
//  Created by by.huang on 2018/11/6.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "AboutPage.h"
#import "SettingViewCell.h"
#import "AgreementPage.h"
@interface AboutPage ()<UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic)UITableView *tableView;

@end

@implementation AboutPage{
    NSArray *titles;
}

+(void)show:(BaseViewController *)controller{
    AboutPage *page = [[AboutPage alloc]init];
    [controller pushPage:page];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showSTNavigationBar:MSG_TITLE_ABOUT needback:YES];
    [self initView];

}


-(void)initView{
    UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - STWidth(90))/2, STHeight(140), STWidth(90), STWidth(90))];
    logoImageView.image = [UIImage imageNamed:IMAGE_ABOUT];
    logoImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:logoImageView];
    
    NSString *logoStr = MSG_VERSION;
    UILabel *logoLabel = [[UILabel alloc]initWithFont:STFont(15) text:logoStr textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    logoLabel.frame = CGRectMake(0, STHeight(245), ScreenWidth, STHeight(21));
    [self.view addSubview:logoLabel];
    
    titles = @[MSG_TITLE_AGREEMENT];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, STHeight(309), ScreenWidth, titles.count * STHeight(50))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView useDefaultProperty];
    
    [self.view addSubview:_tableView];
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [titles count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return STHeight(50);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[SettingViewCell identify]];
    if(!cell){
        cell = [[SettingViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[SettingViewCell identify]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(!IS_NS_COLLECTION_EMPTY(titles)){
        [cell updateData:[titles objectAtIndex:indexPath.row] line:NO];
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [AgreementPage show:self];
}


@end
