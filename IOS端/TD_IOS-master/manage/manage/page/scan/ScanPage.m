//
//  ScanPage.m
//  manage
//
//  Created by by.huang on 2018/10/13.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import "ScanPage.h"
#import <AudioToolbox/AudioToolbox.h>
#import "StyleDIY.h"
#import "STNetUtil.h"
#import "AccountManager.h"
#import "BindMerchantPage.h"
#import "ResetPage.h"
#import "TaxiPage.h"
#import "STObserverManager.h"

@interface ScanPage()

@property(strong, nonatomic)UILabel *resultTitleLabel;
@property(strong, nonatomic)UILabel *countLabel;
@property(strong, nonatomic)UIButton *finishBtn;
@property(strong, nonatomic)UIButton *lightBtn;
@property(strong, nonatomic)UIImageView *lightImageView;
@property(strong, nonatomic)UILabel *lightLabel;
@property(strong, nonatomic)UIView *unBindDialog;
@property(strong, nonatomic)UILabel *snLabel;
@property(strong, nonatomic)UILabel *addressLabel;

@property(assign, nonatomic)int count;
@property(assign, nonatomic)Boolean lightOpen;


@property(assign, nonatomic)NSInteger type;
@property(copy, nonatomic)NSString *mchId;
@property(copy, nonatomic)NSString *mchName;



@end


@implementation ScanPage{
    BOOL isStart;
}

+(void)show:(BaseViewController *)controller type:(ScanType)type mchId:(NSString *)mchId mchName:(NSString *)mchName{
    ScanPage *vc = [[ScanPage alloc]init];
    vc.type = type;
    vc.mchId = mchId;
    vc.mchName = mchName;
    vc.style = [StyleDIY xhcStyle];
    vc.isOpenInterestRect = YES;
    vc.libraryType = SLT_ZXing;
    vc.scanCodeType = SCT_QRCode;
    
    [controller.navigationController pushViewController:vc animated:YES];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.cameraInvokeMsg = MSG_SCAN_LUNCHER;
    WS(weakSelf)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf initView];
    });
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setStatuBarBackgroud:[cblack colorWithAlphaComponent:0.0f] style:UIStatusBarStyleLightContent];
}




-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)setStatuBarBackgroud : (UIColor *)color style:(UIStatusBarStyle)statuBarStyle{
       UIView *statusBar;
      if (@available(iOS 13.0, *)) {
          // iOS 13  弃用keyWindow属性  从所有windowl数组中取
          UIWindow *keyWindow = [UIApplication sharedApplication].windows[0];
          statusBar = [[UIView alloc] initWithFrame:keyWindow.windowScene.statusBarManager.statusBarFrame];
          [keyWindow addSubview:statusBar];
      } else {
          statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
      }
      if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
          statusBar.backgroundColor = color;
      }
}


-(void)initView{
    
    NSString *title = MSG_SCAN_ACTIVE_DEVICE;
    if(_type == ScanType_BIND_MERCHANT){
        title = MSG_TITLE_BIND_MERCHANT;
    }else if(_type == ScanType_RESET_PSW){
        title = MENU_RESET;
    }else if(_type == ScanType_BIND_GROUP){
        title = MSG_TITLE_ADD_DEVICE;
    }else if(_type == ScanType_UNBIND_DEVICE){
        title = MENU_UNBINDING;
    }

    UILabel *titleLabel = [[UILabel alloc]initWithFont:STFont(17) text:title textAlignment:NSTextAlignmentCenter textColor:cwhite backgroundColor:nil multiLine:NO];
    titleLabel.frame =  CGRectMake(0, StatuBarHeight, ScreenWidth, STHeight(44));
    [self.view addSubview:titleLabel];
    
    UIButton *backBtn = [[UIButton alloc]init];
    backBtn.frame = CGRectMake(0, StatuBarHeight, STWidth(64), STHeight(44));
    [backBtn setImage:[UIImage imageNamed:IMAGE_LIGHT_BACK] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(onBackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *phothAlbumBtn = [[UIButton alloc]initWithFont:STFont(14) text:@"相册" textColor:cwhite backgroundColor:nil corner:0 borderWidth:0 borderColor:nil];
    phothAlbumBtn.frame = CGRectMake(ScreenWidth - STWidth(64), StatuBarHeight, STWidth(64), STHeight(44));
    [phothAlbumBtn addTarget:self action:@selector(onPhothAlbumBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phothAlbumBtn];

    NSString *resultTitle = MSG_SCAN_HAS_ACTIVE;
    if(_type == ScanType_BIND_MERCHANT){
        resultTitle = MSG_SCAN_QRCODE;
    }else if(_type == ScanType_RESET_PSW){
        resultTitle = MSG_SCAN_RESET_QRCODE;
    }else if(_type == ScanType_BIND_GROUP){
        resultTitle = MSG_SCAN_HAS_ADD;
    }else if(_type == ScanType_UNBIND_DEVICE){
        resultTitle = @"";
    }
    _resultTitleLabel = [[UILabel alloc]initWithFont:STFont(18) text:resultTitle textAlignment:NSTextAlignmentCenter textColor:cwhite backgroundColor:nil multiLine:YES];
    if(IS_IPHONE_678 || IS_IPHONE_678P){
        _resultTitleLabel.frame = CGRectMake(0, STHeight(486), ScreenWidth, STHeight(25));
    }else{
        _resultTitleLabel.frame = CGRectMake(0, STHeight(566), ScreenWidth, STHeight(25));
    }
    [self.view addSubview:_resultTitleLabel];
    
    if(_type == ScanType_ACTIVE_DEVICE || _type == ScanType_BIND_GROUP){
        
        UILabel *positionLabel = [[UILabel alloc]initWithFont:STFont(17) text:_mchName textAlignment:NSTextAlignmentCenter textColor:cwhite backgroundColor:nil multiLine:NO];
        CGSize positionSize = [positionLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(17)];
        
        CGFloat left = (ScreenWidth - positionSize.width - STWidth(26))/2;
        UIImageView *positionImageView = [[UIImageView alloc]initWithFrame:CGRectMake(left, STHeight(98), STWidth(15), STWidth(18))];
        positionImageView.image = [UIImage imageNamed:IMAGE_MCH_POSITION];
        positionImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:positionImageView];
        
     
        positionLabel.frame = CGRectMake(left + STWidth(26), STHeight(98), positionSize.width, STHeight(17));
        [self.view addSubview:positionLabel];
        

        _countLabel = [[UILabel alloc]initWithFont:STFont(48) text:@"0" textAlignment:NSTextAlignmentCenter textColor:cwhite backgroundColor:nil multiLine:NO];
        if(IS_IPHONE_678 || IS_IPHONE_678P){
            _countLabel.frame = CGRectMake(0, STHeight(423), ScreenWidth, STHeight(67));
        }else{
            _countLabel.frame = CGRectMake(0, STHeight(503), ScreenWidth, STHeight(67));
        }
        [self.view addSubview:_countLabel];

        _finishBtn = [[UIButton alloc]initWithFont:STFont(18) text:MSG_FINISH textColor:c01 backgroundColor:nil corner:2 borderWidth:0.5 borderColor:c01];
        _finishBtn.frame = CGRectMake(STWidth(88), ScreenHeight - STHeight(95), STWidth(200), STHeight(45));
        [_finishBtn addTarget:self action:@selector(onFinishBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_finishBtn];
    }else if(_type == ScanType_UNBIND_DEVICE){
        UILabel *tipsLabel = [[UILabel alloc]initWithFont:STFont(12) text:MSG_UNBIND_MERCHANT_TIPS textAlignment:NSTextAlignmentLeft textColor:cwhite backgroundColor:nil multiLine:YES];
        CGSize tipsSize = [tipsLabel.text sizeWithMaxWidth:STWidth(345) font:STFont(12)];
        tipsLabel.frame = CGRectMake(STWidth(15), STHeight(100), STWidth(345), tipsSize.height);
        [self.view addSubview:tipsLabel];
        
        [self createUnBindDialog];
    }

    
    if(IS_IPHONE_678 || IS_IPHONE_678P){
            _lightBtn = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth - STWidth(100))/2, STHeight(330), STWidth(100), STHeight(50))];
    }else{
         _lightBtn = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth - STWidth(100))/2, STHeight(370), STWidth(100), STHeight(50))];
    }
    [_lightBtn addTarget:self action:@selector(onLightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _lightBtn.hidden = YES;
    [self.view addSubview:_lightBtn];
    
    _lightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(100 - 25)/2, 0, STWidth(25), STWidth(25))];
    _lightImageView.image = [UIImage imageNamed:IMAGE_OPEN_LIGHT];
    _lightImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_lightBtn addSubview:_lightImageView];
    
    _lightLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_SCAN_OPEN_LIGHT textAlignment:NSTextAlignmentCenter textColor:cwhite backgroundColor:nil multiLine:NO];
    _lightLabel.frame = CGRectMake(0, STHeight(30), STWidth(100), STHeight(21));
    [_lightBtn addSubview:_lightLabel];
}


-(void)createUnBindDialog{
    _unBindDialog = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - STHeight(215), ScreenWidth, STHeight(215))];
    _unBindDialog.backgroundColor = cwhite;
    _unBindDialog.hidden = YES;
    CAShapeLayer *bodyLayer = [[CAShapeLayer alloc] init];
    bodyLayer.frame = _unBindDialog.bounds;
    bodyLayer.path = [UIBezierPath bezierPathWithRoundedRect:_unBindDialog.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(STWidth(20), STWidth(20))].CGPath;
    _unBindDialog.layer.mask = bodyLayer;
    [self.view addSubview:_unBindDialog];
    
    UILabel *snTitleLabel = [[UILabel alloc]initWithFont:STFont(14) text:MSG_UNBIND_DEVICE_SN textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize snTitleSize = [snTitleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    snTitleLabel.frame = CGRectMake(STWidth(91), STHeight(30), snTitleSize.width, STHeight(20));
    [_unBindDialog addSubview:snTitleLabel];
    
    _snLabel = [[UILabel alloc]initWithFont:STFont(20) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [_snLabel setFont:[UIFont fontWithName:FONT_MIDDLE size:STFont(20)]];
    [_unBindDialog addSubview:_snLabel];
    
    _addressLabel = [[UILabel alloc]initWithFont:STFont(12) text:MSG_EMPTY textAlignment:NSTextAlignmentCenter textColor:c10 backgroundColor:nil multiLine:NO];
    [_unBindDialog addSubview:_addressLabel];
    
    UIButton *unBindBtn = [[UIButton alloc]initWithFont:STFont(18) text:MSG_UNBIND_BTN textColor:c10 backgroundColor:c01 corner:2 borderWidth:0 borderColor:nil];
    unBindBtn.frame = CGRectMake((ScreenWidth - STWidth(232))/2, STHeight(130), STWidth(232), STHeight(50));
    [unBindBtn addTarget:self action:@selector(onUnBindBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_unBindDialog addSubview:unBindBtn];
}


#pragma mark -实现类继承该方法，作出对应处理
- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array{
    if (!array ||  array.count < 1){
        [self popAlertMsgWithScanResult:nil];
        return;
    }
    
    LBXScanResult *scanResult = array[0];
    NSString*strResult = scanResult.strScanned;
 
    if([strResult isEqualToString:@"open"]){
        _lightBtn.hidden = NO;
        return;
    }else if([strResult isEqualToString:@"close"]){
        if(self.lightOpen){
            _lightBtn.hidden = NO;
        }else{
            _lightBtn.hidden = YES;
        }
        return;
    }
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    SystemSoundID soundID = 0;
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"ring.wav" withExtension:nil];
    CFURLRef urlRef = (__bridge CFURLRef)(url);
    AudioServicesCreateSystemSoundID(urlRef, &soundID);
    AudioServicesPlaySystemSound(soundID);
    [self showNextVCWithScanResult:scanResult];
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult{
    if (!strResult) {
        strResult = MSG_SCAN_FAIL;
    }
}

- (void)showNextVCWithScanResult:(LBXScanResult*)strResult{
    NSString *result = strResult.strScanned;
    [STLog print:@"scan result" content:result];
     if(_type == ScanType_ACTIVE_DEVICE){
        if([result containsString:DEFAULT_SCAN_URL] && result.length > DEFAULT_SCAN_URL.length){
            NSString *deviceSn = [result substringWithRange:NSMakeRange(DEFAULT_SCAN_URL.length, result.length - DEFAULT_SCAN_URL.length)];
                [self doAddDevice:deviceSn];
        }else{
            [self showScanFailErrorQRCode];
        }
         return;
     }
     else if(_type == ScanType_BIND_MERCHANT){
         [self doBindMerchant:result];
         return;
     }else if(_type == ScanType_RESET_PSW){
         if([result containsString:DEFAULT_SCAN_URL] && result.length > DEFAULT_SCAN_URL.length){
          NSString *deviceSn = [result substringWithRange:NSMakeRange(DEFAULT_SCAN_URL.length, result.length - DEFAULT_SCAN_URL.length)];
             [self goResetPage:deviceSn];
         }else{
             [self showScanFailErrorQRCode];
         }
         return;
     } else if(_type == ScanType_BIND_GROUP){
         [self doBindGroup:result];
         return;
     }else if(_type == ScanType_UNBIND_DEVICE){
         if([result containsString:DEFAULT_SCAN_URL] && result.length > DEFAULT_SCAN_URL.length){
             NSString *deviceSn = [result substringWithRange:NSMakeRange(DEFAULT_SCAN_URL.length, result.length - DEFAULT_SCAN_URL.length)];
             [self getDeviceInfo:deviceSn];
             WS(weakSelf)
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [weakSelf reStartDevice];
             });
         }else{
             [self showScanFailErrorQRCode];
         }
         return;
     }
    [self showScanFailAndRestart];
   
}


#pragma mark 扫码后下一步

-(void)goResetPage:(NSString *)deviceSn{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"deviceSn"] = deviceSn;
    WS(weakSelf)
    [STNetUtil get:URL_RESET_PSW parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            [ResetPage show:weakSelf scanStr:deviceSn pswStr:respondModel.data];
        }else{
            [weakSelf showErrorInfoAndRestart:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf showScanFailAndRestart];
    }];
}


-(void)doAddDevice:(NSString *)deviceSn{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"deviceSn"] = deviceSn;
    dic[@"mchId"] = _mchId;
    WS(weakSelf)
    [STNetUtil post:URL_ACTIVE_DEVICE content:dic.mj_JSONString success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            [self onDeviceAddSuccess:MSG_DEVICE_ACTIVE_SUCCESS];
        }else{
            [weakSelf showErrorInfoAndRestart:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf showScanFailAndRestart];
    }];
}


-(void)doBindMerchant:(NSString *)scanResult{
    
    id result = scanResult.mj_JSONObject;
    NSString *openId = [result objectForKey:@"openid"];
    NSString *unionId = [result objectForKey:@"unionid"];
    NSString *type = [result objectForKey:@"type"];
    if(IS_NS_STRING_EMPTY(openId) || IS_NS_STRING_EMPTY(unionId)){
        [LCProgressHUD showMessage:MSG_SCAN_TIPS];
        [self reStartDevice];
        return;
    }

    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"openId"] = openId;
    dic[@"unionid"] = unionId;
    dic[@"type"] = type;

    WS(weakSelf)
    [STNetUtil get:URL_CHECK_OPENID parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            [weakSelf onCheckOpenIdSuccess:openId unionId:unionId type:type];
        }else{
            [weakSelf showErrorInfoAndRestart:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf showScanFailAndRestart];
    }];
}

-(void)doBindGroup:(NSString *)result{
    if([result containsString:DEFAULT_SCAN_URL] && result.length > DEFAULT_SCAN_URL.length){
        NSString *deviceSn = [result substringWithRange:NSMakeRange(DEFAULT_SCAN_URL.length, result.length - DEFAULT_SCAN_URL.length)];
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
        [array addObject:deviceSn];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        dic[@"groupId"] = _mchId;
        dic[@"lstSn"] = array;
        WS(weakSelf)
        [STNetUtil post:URL_GROUP_ADD_DEVICE content:dic.mj_JSONString success:^(RespondModel *respondModel) {
            if([respondModel.status isEqualToString:STATU_SUCCESS]){
                NSMutableArray *datas = [NSMutableArray mj_objectArrayWithKeyValuesArray:respondModel.data];
                if(!IS_NS_COLLECTION_EMPTY(datas)){                    NSDictionary *dic = [datas objectAtIndex:0];
                    BOOL result = [[dic objectForKey:@"result"] boolValue];
                    if(result){
                        [weakSelf onDeviceAddSuccess:MSG_DEVICE_ADD_SUCCESS];
                    }else{
                        NSString *errorMsg = [dic objectForKey:@"errMsg"];
                        [weakSelf showErrorInfoAndRestart:errorMsg];
                    }
                }
                return;
            }
            [self showErrorInfoAndRestart:respondModel.msg];
        } failure:^(int errorCode) {
            [self showScanFailAndRestart];
        }];
    }else{
        [self showScanFailAndRestart];
    }
}

-(void)doUnBindDevice:(NSString *)deviceSn{
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [array addObject:deviceSn];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"deviceSnLst"] = array;
    WS(weakSelf)
    [STNetUtil post:URL_UNBIND_DEVICE content:dic.mj_JSONString success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            NSMutableArray *datas = [NSMutableArray mj_objectArrayWithKeyValuesArray:respondModel.data];
            if(!IS_NS_COLLECTION_EMPTY(datas)){
                NSDictionary *dic = [datas objectAtIndex:0];
                BOOL result = [[dic objectForKey:@"result"] boolValue];
                if(result){
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [LCProgressHUD showMessage:@"解绑成功"];
                    });
                    weakSelf.unBindDialog.hidden = YES;
                }else{
                    NSString *errorMsg = [dic objectForKey:@"errMsg"];
                    [weakSelf showErrorInfoAndRestart:[NSString stringWithFormat:@"解绑失败：%@",errorMsg]];
                }
            }
            return;
        }
        [self showErrorInfoAndRestart:respondModel.msg];

    } failure:^(int errorCode) {
        [weakSelf showScanFailAndRestart];
    }];
}

-(void)getDeviceInfo:(NSString *)deviceSn{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    dic[@"sn"] = deviceSn;
    WS(weakSelf)
    [STNetUtil get:URL_DEVICE_INFO parameters:dic success:^(RespondModel *respondModel) {
        if([respondModel.status isEqualToString:STATU_SUCCESS]){
            id mch = [respondModel.data objectForKey:@"deviceMach"];
            NSMutableArray *datas = [NSMutableArray mj_objectArrayWithKeyValuesArray:mch];
            if(!IS_NS_COLLECTION_EMPTY(datas)){
                id result = [datas objectAtIndex:datas.count - 1];
                NSString *mchName = [result objectForKey:@"mchName"];
                if(!IS_NS_STRING_EMPTY(mchName)){
                    weakSelf.addressLabel.text = mchName;
                    CGSize mchNameSize = [mchName sizeWithMaxWidth:ScreenWidth font:STFont(12)];
                    weakSelf.addressLabel.frame = CGRectMake(STWidth(91), STHeight(83), mchNameSize.width, STHeight(17));
                    
                    weakSelf.unBindDialog.hidden = NO;
                    weakSelf.snLabel.text = deviceSn;
                    CGSize snSize = [weakSelf.snLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(20) fontName:FONT_MIDDLE];
                    weakSelf.snLabel.frame = CGRectMake(STWidth(91), STHeight(55), snSize.width, STHeight(30));
                }
            }else{
                [weakSelf showScanFailDeviceNoExit];
            }
        }else{
            [weakSelf showErrorInfoAndRestart:respondModel.msg];
        }
    } failure:^(int errorCode) {
        [weakSelf showScanFailAndRestart];
    }];
}


#pragma mark 弹窗显示
//显示扫码后异常信息
-(void)showErrorInfoAndRestart:(NSString *)msg{
    if(!IS_NS_STRING_EMPTY(msg)){
        WS(weakSelf)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [LCProgressHUD showFailure:msg];
            [weakSelf reStartDevice];
        });
    }
}

//显示扫描失败并重启
-(void)showScanFailAndRestart{
    WS(weakSelf)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [LCProgressHUD showFailure:MSG_SCAN_FAIL];
        [weakSelf reStartDevice];
    });
}

//二维码无法识别并重启
-(void)showScanFailDeviceNoExit{
    _unBindDialog.hidden = YES;
    WS(weakSelf)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [LCProgressHUD showMessage:MSG_SCAN_FAIL_DEVICE_NO_EXIT];
        [weakSelf reStartDevice];
    });
}

//二维码无法识别并重启
-(void)showScanFailErrorQRCode{
    WS(weakSelf)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [LCProgressHUD showMessage:MSG_SCAN_FAIL_ERROR_QRCODE];
        [weakSelf reStartDevice];
    });
}


#pragma mark 点击事件处理

//检测openid成功
-(void)onCheckOpenIdSuccess:(NSString *)openId unionId:(NSString *)unionId type:(NSString *)type{
    [BindMerchantPage show:self openid:openId unionid:unionId type:type from:MerchantFromType_BIND];
}

//设备绑定成功
-(void)onDeviceAddSuccess:(NSString *)msg{
    _count++;
    _countLabel.text = IntStr(_count);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [LCProgressHUD showSuccess:msg];
        [self reStartDevice];
    });
}

-(void)onBackBtnClick{
    [self onFinishBtnClick];
}

-(void)onPhothAlbumBtnClick{
    [self openLocalPhoto:YES];
}

-(void)onFinishBtnClick{
    if(_type == ScanType_BIND_GROUP){
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[TaxiPage class]]) {
                TaxiPage *page =(TaxiPage *)controller;
                [self.navigationController popToViewController:page animated:YES];
                [[STObserverManager sharedSTObserverManager] sendMessage:NOTIFY_UPDATE_GROUP_LIST msg:nil];
            }
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)onLightBtnClick{
    [self openOrCloseFlash];
    _lightOpen = ! _lightOpen;
    if(_lightOpen){
        _lightImageView.image = [UIImage imageNamed:IMAGE_CLOSE_LIGHT];
        _lightLabel.text = MSG_SCAN_CLOSE_LIGHT;
        _lightLabel.textColor = c01;
    }else{
        _lightImageView.image = [UIImage imageNamed:IMAGE_OPEN_LIGHT];
        _lightLabel.text = MSG_SCAN_OPEN_LIGHT;
        _lightLabel.textColor = cwhite;
    }
}

-(void)onUnBindBtnClick{
    [self doUnBindDevice:_snLabel.text];
}

@end
