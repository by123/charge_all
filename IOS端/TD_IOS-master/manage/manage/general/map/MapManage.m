////
////  MapManage.m
////  manage
////
////  Created by by.huang on 2019/6/13.
////  Copyright © 2019 by.huang. All rights reserved.
////
//
//#import "MapManage.h"
//#import <MapKit/MapKit.h>
//
//#define Max_Locations 10
//@interface MapManage()<AMapSearchDelegate>
//
//@property(strong, nonatomic)AMapSearchAPI *search;
//@property(assign, nonatomic)int page;
//@property(assign, nonatomic)Boolean nextPage;
//
//@end
//
//
//@implementation MapManage
//SINGLETON_IMPLEMENTION(MapManage)
//
//
//-(void)initMap{
//    [AMapServices sharedServices].apiKey = MAP_KEY;
//    _search = [[AMapSearchAPI alloc] init];
//    _search.delegate = self;
//    _page = 1;
//    
//    //    //设置允许后台定位参数，保持不会被系统挂起
//    //    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
//    //
//    //    [self.locationManager setAllowsBackgroundLocationUpdates:YES];//iOS9(含)以上系统需设置
//    //
//    //    //开始持续定位
//    //    [self.locationManager startUpdatingLocation];
//    
//}
//
//
//-(void)searchPOI:(NSString *)keywords nextPage:(Boolean)nextPage{
//    _nextPage = nextPage;
//    if(!nextPage){
//        _page = 1;
//    }
//    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
//    request.keywords = keywords;
//    request.requireExtension = YES;
//    request.cityLimit  = YES;
//    request.requireSubPOIs = YES;
//    request.page = _page;
//    request.offset = Max_Locations;
//    request.sortrule = 0;
//    [_search AMapPOIKeywordsSearch:request];
//}
//
//
//-(void)searchPOIWithLocation:(double )latitude longitude:(double)longitude nextPage:(Boolean)nextPage{
//    _nextPage = nextPage;
//    if(!nextPage){
//        _page = 1;
//    }
//    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
//    request.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];;
//    request.requireExtension = YES;
//    request.cityLimit  = YES;
//    request.requireSubPOIs = YES;
//    request.page = _page;
//    request.offset = Max_Locations;
//    request.sortrule = 0;
//    [_search AMapPOIKeywordsSearch:request];
//    [STLog print:@"请求页数" content:IntStr(_page)];
//}
//
//-(void)positionLocation{
//    WS(weakSelf)
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        weakSelf.locationManager = [[AMapLocationManager alloc]init];
//        //带逆地理信息的一次定位（返回坐标和地址信息）
//        [weakSelf.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
//        //定位超时时间，最低2s，此处设置为10s
//        weakSelf.locationManager.locationTimeout =2;
//        //逆地理请求超时时间，最低2s，此处设置为10s
//        weakSelf.locationManager.reGeocodeTimeout = 2;
//        // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
//        [weakSelf.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
//            if(error){
//                NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
//                if (error.code == AMapLocationErrorLocateFailed){
//                    return;
//                }
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if(weakSelf.delegate){
//                    [weakSelf.delegate onPositionLocation:location regeocode:regeocode];
//                }
//            });
//            
//        }];
//    });
//}
//
//
//-(void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
//    NSArray<AMapPOI *> *points = response.pois;
//    [STLog print:@"返回个数" content:LongStr(points.count)];
//    if(_delegate){
//        _page ++;
//        [_delegate onSearchPOIResult:points nextPage:_nextPage];
//    }
//}
//
//
//-(void)openAppleMap:(double )latitude longitude:(double)longitude name:(NSString*)name{
//    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
//    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
//    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil]];
//    toLocation.name = name;
//    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
//                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
//}
//
//-(void)openMaMap:(double )latitude longitude:(double)longitude name:(NSString*)name{
//    NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&sid=BGVIS1&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=0&t=0",@"",latitude,longitude,name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
////    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
////    }else{
////        [LCProgressHUD showMessage:@"请检查是否安装高德地图App"];
////    }
//}
//
//-(void)openBaiduMap:(double )latitude longitude:(double)longitude name:(NSString*)name{
//    NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name:%@&mode=driving&coord_type=gcj02",latitude, longitude,name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
////    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
////    }
////    else{
////        [LCProgressHUD showMessage:@"请检查是否安装百度地图App"];
////    }
//}
//
//-(void)openTencent:(double)myLatitude myLongitude:(double)myLongitude latitude:(double)latitude longitude:(double)longitude name:(NSString *)name{
//        NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&from=我的位置&fromcoord=%f,%f&tocoord=%f,%f&to=%@&refer=WAIBZ-UFZW4-XZCUY-XEUEE-OX2KS-IMBSC",
//                                    myLatitude,
//                                    myLongitude,
//                                    latitude,
//                                    longitude,
//                                    name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
////    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
////    }else{
////        [LCProgressHUD showMessage:@"请检查是否安装腾讯地图App"];
////    }
//}
//@end
