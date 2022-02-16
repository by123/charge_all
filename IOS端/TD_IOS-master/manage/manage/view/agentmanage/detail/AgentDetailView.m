//
//  AgentDetailView.m
//  manage
//
//  Created by by.huang on 2018/11/14.
//  Copyright © 2018 by.huang. All rights reserved.
//

#import "AgentDetailView.h"
#import "DetailViewCell.h"
//#import <MAMapKit/MAMapKit.h>
//#import <AMapFoundationKit/AMapFoundationKit.h>
//#import "MapManage.h"
#import "LocationModel.h"

@interface AgentDetailView()<UITableViewDelegate,UITableViewDataSource>

@property(strong, nonatomic)AgentDetailViewModel *mViewModel;
@property(strong, nonatomic)UITableView *infoTableView;
@property(strong, nonatomic)UITableView *agentTableView;
@property(strong, nonatomic)UITableView *deviceTableView;
@property(strong, nonatomic)UIScrollView *scrollView;
@property(strong, nonatomic)UIButton *editBtn;

@property(strong, nonatomic)UIView *addressView;
@property(strong, nonatomic)UILabel *addressLabel;
@property(strong, nonatomic)UIView *addressLine;
@property(strong, nonatomic)UIView *mapViews;
@property(strong, nonatomic)UILabel *mapAddressLabel;

//@property(strong, nonatomic)MAMapView *mapView;
//@property(strong, nonatomic)MAPointAnnotation *pointAnnotation;
@property(strong, nonatomic)UIView *mapContentView;

@end

@implementation AgentDetailView{
    double latitude;
    double longitude;
    NSString *name;
}

-(instancetype)initWithViewModel:(AgentDetailViewModel *)viewModel{
    if(self == [super init]){
        _mViewModel = viewModel;
    }
    return self;
}

-(void)initView{
    
    CGFloat tableHeight = 0;
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.frame = CGRectMake(0, 0, ScreenWidth, ContentHeight);
    [self addSubview:_scrollView];
    
    NSString *infoStr = @"代理商信息";
    UILabel *infoLabel = [[UILabel alloc]initWithFont:STFont(14) text:infoStr textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize infoSize = [infoStr sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    infoLabel.frame = CGRectMake(STWidth(15), STHeight(20), infoSize.width, STHeight(20));
    [_scrollView addSubview:infoLabel];
    
    
    _infoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, STHeight(44), ScreenWidth, _mViewModel.infoDatas.count* STHeight(50))];
    _infoTableView.delegate = self;
    _infoTableView.dataSource = self;
    [_infoTableView setScrollEnabled:NO];
    [_infoTableView useDefaultProperty];
    
    [_scrollView addSubview:_infoTableView];
    
    
    tableHeight =  _mViewModel.infoDatas.count* STHeight(50);
    UILabel *agentLabel = [[UILabel alloc]initWithFont:STFont(14) text:@"代理信息" textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize agentSize = [agentLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    agentLabel.frame = CGRectMake(STWidth(15), STHeight(20) + STHeight(44) +tableHeight, agentSize.width, STHeight(20));
    [_scrollView addSubview:agentLabel];
    
    
    _agentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, STHeight(88) + tableHeight, ScreenWidth, _mViewModel.agentDatas.count* STHeight(50))];
    _agentTableView.delegate = self;
    _agentTableView.dataSource = self;
    [_agentTableView setScrollEnabled:NO];
    [_agentTableView useDefaultProperty];
    
    [_scrollView addSubview:_agentTableView];
    
    if(IS_NS_COLLECTION_EMPTY(_mViewModel.agentDatas)){
        agentLabel.hidden = YES;
        tableHeight -= STHeight(44);
    }
    
    
    tableHeight += _mViewModel.agentDatas.count* STHeight(50);
    NSString *deviceStr = @"设备信息";
    UILabel *deviceLabel = [[UILabel alloc]initWithFont:STFont(14) text:deviceStr textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize deviceSize = [deviceStr sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    deviceLabel.frame = CGRectMake(STWidth(15), STHeight(20) + STHeight(88) + tableHeight, deviceSize.width, STHeight(20));
    [_scrollView addSubview:deviceLabel];
    
    
    _deviceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, STHeight(132) + tableHeight, ScreenWidth, _mViewModel.deviceDatas.count* STHeight(50))];
    _deviceTableView.delegate = self;
    _deviceTableView.dataSource = self;
    [_deviceTableView setScrollEnabled:NO];
    [_deviceTableView useDefaultProperty];
    
    [_scrollView addSubview:_deviceTableView];
    
    tableHeight += _mViewModel.deviceDatas.count* STHeight(50);

    NSString *addressStr = @"区域位置";
    UILabel *addressLabel = [[UILabel alloc]initWithFont:STFont(14) text:addressStr textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:NO];
    CGSize addressSize = [addressStr sizeWithMaxWidth:ScreenWidth font:STFont(14)];
    addressLabel.frame = CGRectMake(STWidth(15), STHeight(20) + STHeight(132) + tableHeight , addressSize.width, STHeight(20));
    [_scrollView addSubview:addressLabel];
    
    if(IS_NS_STRING_EMPTY(_mViewModel.model.province)){
        addressLabel.hidden = YES;
    }
    
    [self initAddressView];
    
    [_scrollView setContentSize:CGSizeMake(ScreenWidth, STHeight(178) + tableHeight + STHeight(77) + STHeight(343))];
    
    
    _editBtn = [[UIButton alloc]initWithFont:STFont(18) text:@"编辑" textColor:c_btn_txt_highlight backgroundColor:c01 corner:0 borderWidth:0 borderColor:nil];
    _editBtn.frame = CGRectMake(0, ContentHeight - STHeight(50), ScreenWidth, STHeight(50));
    [_editBtn addTarget:self action:@selector(onEditBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_editBtn];
    
    
    latitude = _mViewModel.model.mchLocationLatitude;
    longitude = _mViewModel.model.mchLocationLongitude;
    name = _mViewModel.model.mchLocationDetailAddr;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == _infoTableView){
        return [_mViewModel.infoDatas count];
    }else if(tableView == _agentTableView){
        return [_mViewModel.agentDatas count];
    }
    return [_mViewModel.deviceDatas count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return STHeight(50);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DetailViewCell identify]];
    if(!cell){
        cell = [[DetailViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[DetailViewCell identify]];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if(tableView == _infoTableView){
        if(indexPath.row == [_mViewModel.infoDatas count] - 1){
            [cell updateData:[_mViewModel.infoDatas objectAtIndex:indexPath.row] lineHidden:YES];
        }else{
            [cell updateData:[_mViewModel.infoDatas objectAtIndex:indexPath.row] lineHidden:NO];
        }
    }else if(tableView == _agentTableView){
        if(indexPath.row == [_mViewModel.agentDatas count] - 1){
            [cell updateData:[_mViewModel.agentDatas objectAtIndex:indexPath.row] lineHidden:YES];
        }else{
            [cell updateData:[_mViewModel.agentDatas objectAtIndex:indexPath.row] lineHidden:NO];
        }
    }
    else{
        if(indexPath.row == [_mViewModel.deviceDatas count] - 1){
            [cell updateData:[_mViewModel.deviceDatas objectAtIndex:indexPath.row] lineHidden:YES];
        }else{
            [cell updateData:[_mViewModel.deviceDatas objectAtIndex:indexPath.row] lineHidden:NO];
        }
    }
    return cell;
}


-(void)updateView{
    [_scrollView removeFromSuperview];
    [_editBtn removeFromSuperview];
    [self initView];
}

-(void)onEditBtnClick{
    if(_mViewModel){
        [_mViewModel goAgentEditPage];
    }
}



/**地址控件**/
-(void)initAddressView{
    CGFloat tableHeight = (_mViewModel.infoDatas.count + _mViewModel.deviceDatas.count + _mViewModel.agentDatas.count )* STHeight(50);
    if(IS_NS_COLLECTION_EMPTY(_mViewModel.agentDatas)){
        tableHeight -= STHeight(44);
    }
    
    _addressView = [[UIView alloc]initWithFrame:CGRectMake(0, STHeight(44) * 4 + tableHeight, ScreenWidth, STHeight(343))];
    _addressView.backgroundColor = cwhite;
    [_scrollView addSubview:_addressView];
    
    if(IS_NS_STRING_EMPTY(_mViewModel.model.province)){
        _addressView.hidden = YES;
    }
    
    _addressLabel = [[UILabel alloc]initWithFont:STFont(15) text:MSG_EMPTY textAlignment:NSTextAlignmentLeft textColor:c10 backgroundColor:nil multiLine:YES];
    [_addressView addSubview:_addressLabel];
    
    _addressLine = [[UIView alloc]init];
    _addressLine.backgroundColor = cline;
    [_addressView addSubview:_addressLine];
    if(_mViewModel.model.mchLocationLongitude == 0 ||
       _mViewModel.model.mchLocationLatitude == 0){
        //未获取到经纬度
        _addressLine.hidden = YES;
        _addressView.frame = CGRectMake(0, STHeight(44) * 4 + tableHeight, ScreenWidth, STHeight(72));
    }else{
        _mapViews = [[UIView alloc]init];
        [_addressView addSubview:_mapViews];
        [self initMapView];
    }

    _mViewModel.model.province = IS_NS_STRING_EMPTY(_mViewModel.model.province) ? MSG_EMPTY : _mViewModel.model.province;
    _mViewModel.model.city = IS_NS_STRING_EMPTY(_mViewModel.model.city) ? MSG_EMPTY : _mViewModel.model.city;
    _mViewModel.model.area = IS_NS_STRING_EMPTY(_mViewModel.model.area) ? MSG_EMPTY : _mViewModel.model.area;
    _mViewModel.model.detailAddr = IS_NS_STRING_EMPTY(_mViewModel.model.detailAddr) ? MSG_EMPTY : _mViewModel.model.detailAddr;

    [self updateAddressView:[NSString stringWithFormat:@"%@%@%@%@",_mViewModel.model.province,_mViewModel.model.city,_mViewModel.model.area,_mViewModel.model.detailAddr]];

}

-(void)updateAddressView:(NSString *)addressStr{
    _addressLabel.text = addressStr;
    CGSize addressSize = [_addressLabel.text sizeWithMaxWidth:ScreenWidth-STWidth(30) font:STFont(15)];
    _addressLabel.frame = CGRectMake(STWidth(15), 0, ScreenWidth-STWidth(30), STHeight(30)+addressSize.height);

    _addressLine.frame = CGRectMake(STWidth(15), STHeight(30)+addressSize.height-LineHeight, ScreenWidth-STWidth(30), LineHeight);
    _mapViews.frame = CGRectMake(0, STHeight(30)+addressSize.height, ScreenWidth, STHeight(270));
}

-(void)initMapView{
    UILabel *gpsLabel = [[UILabel alloc]initWithFont:STFont(15) text:@"GPS位置" textAlignment:NSTextAlignmentCenter textColor:c11 backgroundColor:nil multiLine:NO];
    CGSize gpsSize = [gpsLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    gpsLabel.frame = CGRectMake(STWidth(15), STHeight(15), gpsSize.width, STHeight(21));
    [_mapViews addSubview:gpsLabel];
    
    UIButton *gpsBtn = [[UIButton alloc]initWithFont:STFont(15) text:@"去导航" textColor:c12 backgroundColor:nil corner:0 borderWidth:0 borderColor:nil];
    CGSize gpsBtnSize = [gpsBtn.titleLabel.text sizeWithMaxWidth:ScreenWidth font:STFont(15)];
    gpsBtn.frame = CGRectMake(ScreenWidth - STWidth(15) - gpsBtnSize.width, STHeight(15), gpsBtnSize.width, STHeight(21));
    [gpsBtn addTarget:self action:@selector(onGpsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_mapViews addSubview:gpsBtn];
    
    UIImageView *gpsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(48), STWidth(20), STWidth(20))];
    gpsImageView.image = [UIImage imageNamed:IMAGE_LOCATION];
    gpsImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_mapViews addSubview:gpsImageView];
    
    _mapAddressLabel = [[UILabel alloc]initWithFont:STFont(15) text:[NSString stringWithFormat:@"%@%@%@%@",_mViewModel.model.mchLocationProvince,_mViewModel.model.mchLocationCity,_mViewModel.model.mchLocationArea,_mViewModel.model.mchLocationDetailAddr] textAlignment:NSTextAlignmentLeft textColor:c11 backgroundColor:nil multiLine:NO];
    _mapAddressLabel.frame = CGRectMake(STWidth(45), STHeight(46), ScreenWidth-STWidth(45), STHeight(21));
    [_mapViews addSubview:_mapAddressLabel];
    
    
    _mapContentView = [[UIView alloc]initWithFrame:CGRectMake(STWidth(15), STHeight(80), STWidth(345), STHeight(150))];
    [_mapViews addSubview:_mapContentView];
    
//    [AMapServices sharedServices].enableHTTPS = YES;
//    _mapView = [[MAMapView alloc] initWithFrame:_mapContentView.bounds];
//    _mapView.delegate = self;
//    _mapView.zoomLevel = 15;
//    _mapView.scrollEnabled = YES;
//    _mapView.zoomEnabled = YES;
//    _mapView.rotateEnabled = YES;
//    [_mapContentView addSubview:_mapView];
//    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
//    _mapView.showsUserLocation = YES;
//    _mapView.userTrackingMode = MAUserTrackingModeFollow;
//    _mapView.centerCoordinate = CLLocationCoordinate2DMake(_mViewModel.model.mchLocationLatitude, _mViewModel.model.mchLocationLongitude);
    
    
//    [MapManage sharedMapManage].delegate = self;
//    [[MapManage sharedMapManage] positionLocation];
    
//    _pointAnnotation = [[MAPointAnnotation alloc] init];
//    _pointAnnotation.coordinate = CLLocationCoordinate2DMake(_mViewModel.model.mchLocationLatitude ,_mViewModel.model.mchLocationLongitude);
//    _pointAnnotation.lockedScreenPoint = CGPointMake(STWidth(345)/2, STHeight(75));
//    _pointAnnotation.lockedToScreen = YES;
//    [_mapView addAnnotation:_pointAnnotation];

}


//-(void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction{
//    if(wasUserAction){
//        [STLog print:[NSString stringWithFormat:@"%.4f,%.4f",_pointAnnotation.coordinate.longitude,_pointAnnotation.coordinate.latitude]];
//        [[MapManage sharedMapManage] searchPOIWithLocation:_pointAnnotation.coordinate.latitude longitude:_pointAnnotation.coordinate.longitude nextPage:NO];
//
//    }
//}

//-(void)onPositionLocation:(CLLocation *)location regeocode:(AMapLocationReGeocode *)regeocode{
//    if(_pointAnnotation == nil){
//        _pointAnnotation = [[MAPointAnnotation alloc] init];
//        _pointAnnotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude ,location.coordinate.longitude);
//        _pointAnnotation.lockedScreenPoint = CGPointMake(STWidth(345)/2, STHeight(75));
//        _pointAnnotation.lockedToScreen = YES;
//        [_mapView addAnnotation:_pointAnnotation];
//    }else{
//        _pointAnnotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude);
//        _pointAnnotation.lockedScreenPoint = CGPointMake(STWidth(345)/2, STHeight(75));
//        _pointAnnotation.lockedToScreen = YES;
//        _mapView.centerCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude);
//    }
//
//}

//-(void)onSearchPOIResult:(NSArray *)pois nextPage:(Boolean)nextPage{
//    if(!IS_NS_COLLECTION_EMPTY(pois)){
//        AMapPOI *poi = [pois objectAtIndex:0];
//        _mapAddressLabel.text = poi.name;
//        latitude = poi.location.latitude;
//        longitude = poi.location.longitude;
//        name = poi.name;
//    }
//}


-(void)onGpsBtnClick{
    if(_mViewModel){
//        [_mViewModel goNavigation:_pointAnnotation.coordinate.latitude myLongitude:_pointAnnotation.coordinate.longitude latitude:latitude longitude:longitude name:name];        
    }
}


@end

