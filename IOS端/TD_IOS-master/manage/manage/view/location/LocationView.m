////
////  LocationView.m
////  manage
////
////  Created by by.huang on 2018/11/14.
////  Copyright © 2018 by.huang. All rights reserved.
////
//
//#import "LocationView.h"
//#import <MAMapKit/MAMapKit.h>
//#import <AMapFoundationKit/AMapFoundationKit.h>
//#import "MapManage.h"
//#import "LocationViewCell.h"
//
//@interface LocationView()<MapDelegate,UITableViewDelegate,UITableViewDataSource,MAMapViewDelegate>
//
//@property(strong, nonatomic)LocationViewModel *mViewModel;
//@property(strong, nonatomic)MAMapView *mapView;
//@property(strong, nonatomic)UITableView *tableView;
//@property(strong, nonatomic)MAPointAnnotation *pointAnnotation;
//@property(strong, nonatomic)UIView *mapContentView;
//@property(strong, nonatomic)UIButton *positionBtn;
//@end
//
//@implementation LocationView{
//    LocationModel *selectModel;
//    LocationModel *currentModel;
//    Boolean isExpand;
//}
//
//-(instancetype)initWithViewModel:(LocationViewModel *)viewModel{
//    if(self == [super init]){
//        _mViewModel = viewModel;
//        [self initView];
//    }
//    return self;
//}
//
//-(void)initView{
//    [self initMapView];
//    [self initTableView];
//}
//
//-(void)initMapView{
//    
//    _mapContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, STHeight(250))];
//    [self addSubview:_mapContentView];
//    
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
//    
//    
//    [MapManage sharedMapManage].delegate = self;
//    //    [[MapManage sharedMapManage] searchPOI:@"大厦"];
//    [[MapManage sharedMapManage] positionLocation];
//    
//    
//    _positionBtn = [[UIButton alloc]init];
//    _positionBtn.frame = CGRectMake(ScreenWidth - STWidth(45), STHeight(250) -STWidth(45), STWidth(30), STWidth(30));
//    [_positionBtn addTarget:self action:@selector(onPositionBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_positionBtn];
//    
//}
//
//
//-(void)onSearchPOIResult:(NSArray *)pois nextPage:(Boolean)nextPage{
//    if(!nextPage){
//        [_mViewModel.datas removeAllObjects];
//    }
//    if(!IS_NS_COLLECTION_EMPTY(pois)){
//        [_tableView.mj_footer resetNoMoreData];
//        WS(weakSelf)
//        [pois enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            LocationModel *model = [[LocationModel alloc]init];
//            model.poi = obj;
//            model.isSelect = NO;
//            [weakSelf.mViewModel.datas addObject:model];
//        }];
//        LocationModel *firstModel = [weakSelf.mViewModel.datas objectAtIndex:0];
//        firstModel.isSelect = YES;
//        selectModel = firstModel;
//        for(AMapAOI *point in pois){
//            [STLog print:point.name content:[NSString stringWithFormat:@"经度：%.4f,纬度：%.4f",point.location.latitude,point.location.longitude]];
//        }
//    }else{
//        [_tableView.mj_footer endRefreshingWithNoMoreData];
//    }
//    [_tableView reloadData];
//}
//
//
//-(void)initTableView{
//    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, STHeight(250), ScreenWidth, ContentHeight-STHeight(250))];
//    _tableView.delegate = self;
//    _tableView.dataSource = self;
//    [_tableView useDefaultProperty];
//    
//    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(uploadMore)];
//    _tableView.mj_footer = footer;
//    
//    [self addSubview:_tableView];
//}
//
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return [_mViewModel.datas count];
//}
//
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
//
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(indexPath.row == 0){
//        return STHeight(51);
//    }
//    return STHeight(72);
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    LocationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[LocationViewCell identify]];
//    if(!cell){
//        cell = [[LocationViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[LocationViewCell identify]];
//    }
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.datas)){
//        [cell updateData:[_mViewModel.datas objectAtIndex:indexPath.row] position:indexPath.row];
//    }
//    return cell;
//}
//
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(!IS_NS_COLLECTION_EMPTY(_mViewModel.datas)){
//        if(selectModel){
//            selectModel.isSelect = NO;
//        }
//        LocationModel *model = [_mViewModel.datas objectAtIndex:indexPath.row];
//        model.isSelect = YES;
//        [_tableView.mj_footer resetNoMoreData];
//        [_tableView reloadData];
//        selectModel = model;
//        
//        WS(weakSelf)
//        [UIView animateWithDuration:0.3f animations:^{
//            weakSelf.pointAnnotation.coordinate = CLLocationCoordinate2DMake(model.poi.location.latitude,model.poi.location.longitude);
//            weakSelf.pointAnnotation.lockedScreenPoint = CGPointMake(ScreenWidth/2, STHeight(125));
//            weakSelf.pointAnnotation.lockedToScreen = YES;
//            weakSelf.mapView.centerCoordinate = CLLocationCoordinate2DMake(model.poi.location.latitude,model.poi.location.longitude);
//        }];
//        
//        [_positionBtn setImage:[UIImage imageNamed:IMAGE_POSITION_LOCATION_NORMAL] forState:UIControlStateNormal];
//    }
//    
//}
//
//-(void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction{
//    if(wasUserAction){
//        [_positionBtn setImage:[UIImage imageNamed:IMAGE_POSITION_LOCATION_NORMAL] forState:UIControlStateNormal];
//        [STLog print:[NSString stringWithFormat:@"%.4f,%.4f",_pointAnnotation.coordinate.longitude,_pointAnnotation.coordinate.latitude]];
//        [[MapManage sharedMapManage] searchPOIWithLocation:_pointAnnotation.coordinate.latitude longitude:_pointAnnotation.coordinate.longitude nextPage:NO];
//        //tableview滑到顶部
//        [_tableView setContentOffset:CGPointMake(0,0) animated:YES];
//    }
//}
//
//
//
//
//-(void)updateView{
//    [_tableView reloadData];
//}
//
//
//
//-(void)onPositionBtnClick{
//    [[MapManage sharedMapManage] positionLocation];
//}
//
//
//-(void)onPositionLocation:(CLLocation *)location regeocode:(AMapLocationReGeocode *)regeocode{
//    [[MapManage sharedMapManage] searchPOIWithLocation:location.coordinate.longitude longitude:location.coordinate.latitude nextPage:NO];
//    [_positionBtn setImage:[UIImage imageNamed:IMAGE_POSITION_LOCATION_SELECT] forState:UIControlStateNormal];
//    if(_pointAnnotation == nil){
//        _pointAnnotation = [[MAPointAnnotation alloc] init];
//        _pointAnnotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude ,location.coordinate.longitude);
//        _pointAnnotation.lockedScreenPoint = CGPointMake(ScreenWidth/2, STHeight(125));
//        _pointAnnotation.lockedToScreen = YES;
//        [_mapView addAnnotation:_pointAnnotation];
//    }else{
//        _pointAnnotation.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude);
//        _pointAnnotation.lockedScreenPoint = CGPointMake(ScreenWidth/2, STHeight(125));
//        _pointAnnotation.lockedToScreen = YES;
//        _mapView.centerCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude);
//    }
//}
//
//
//-(void)uploadMore{
//    [[MapManage sharedMapManage] searchPOIWithLocation:_pointAnnotation.coordinate.longitude longitude:_pointAnnotation.coordinate.latitude nextPage:YES];
//    
//}
//
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGFloat offsetY = _tableView.mj_offsetY;
////    STPrint(DoubleStr(offsetY));
//    WS(weakSelf)
//    if(offsetY > 0 && !isExpand){
//        isExpand = YES;
//        WS(weakSelf)
//        [UIView animateWithDuration:0.3f animations:^{
//            weakSelf.tableView.frame = CGRectMake(0, STHeight(150), ScreenWidth, ContentHeight-STHeight(150));
//            weakSelf.mapContentView.frame = CGRectMake(0, 0, ScreenWidth, STHeight(150));
//            weakSelf.mapView.frame = weakSelf.mapContentView.bounds;
//            weakSelf.pointAnnotation.lockedScreenPoint = CGPointMake(ScreenWidth/2, STHeight(75));
//            weakSelf.positionBtn.frame = CGRectMake(ScreenWidth - STWidth(45), STHeight(150) -STWidth(45), STWidth(30), STWidth(30));
//        }];
//        return;
//    }
//    if(offsetY < 0 && isExpand){
//        isExpand = NO;
//        [UIView animateWithDuration:0.3f animations:^{
//            weakSelf.tableView.frame = CGRectMake(0, STHeight(250), ScreenWidth, ContentHeight-STHeight(250));
//            weakSelf.mapContentView.frame = CGRectMake(0, 0, ScreenWidth, STHeight(250));
//            weakSelf.mapView.frame = weakSelf.mapContentView.bounds;
//            weakSelf.pointAnnotation.lockedScreenPoint = CGPointMake(ScreenWidth/2, STHeight(125));
//            weakSelf.positionBtn.frame = CGRectMake(ScreenWidth - STWidth(45), STHeight(250) -STWidth(45), STWidth(30), STWidth(30));
//
//        }];
//        return;
//    }
//}
//
//
//
////- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
////    if ([annotation isKindOfClass:[MAPointAnnotation class]]){
////        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
////        MAAnnotationView *annotationView = (MAAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
////        if (annotationView == nil){
////            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIndetifier];
////        }
////        annotationView.image = [UIImage imageNamed:IMAGE_POINTANNOTATION];
////        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
////        annotationView.centerOffset = CGPointMake(0, -18);
////        return annotationView;
////    }
////    return nil;
////}
//
//
//
//@end
//
