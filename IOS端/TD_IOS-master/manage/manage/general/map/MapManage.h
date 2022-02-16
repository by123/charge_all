////
////  MapManage.h
////  manage
////
////  Created by by.huang on 2019/6/13.
////  Copyright © 2019 by.huang. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//#import <AMapFoundationKit/AMapFoundationKit.h>
//#import <AMapSearchKit/AMapSearchKit.h>
//#import <AMapLocationKit/AMapLocationKit.h>
//
//@protocol MapDelegate
//
//-(void)onSearchPOIResult:(NSArray *)pois nextPage:(Boolean)nextPage;
//-(void)onPositionLocation:(CLLocation *)location regeocode:(AMapLocationReGeocode *)regeocode;
//
//@end
//
//@interface MapManage : NSObject
//SINGLETON_DECLARATION(MapManage)
//
//@property(weak, nonatomic)id<MapDelegate> delegate;
//@property(strong, nonatomic)AMapLocationManager *locationManager;
//
//-(void)initMap;
//-(void)searchPOI:(NSString *)keywords nextPage:(Boolean)nextPage;
//-(void)searchPOIWithLocation:(double )latitude longitude:(double)longitude nextPage:(Boolean)nextPage;
//-(void)positionLocation;
//
//
//-(void)openAppleMap:(double )latitude longitude:(double)longitude name:(NSString*)name;
//-(void)openMaMap:(double )latitude longitude:(double)longitude name:(NSString*)name;
//-(void)openBaiduMap:(double )latitude longitude:(double)longitude name:(NSString*)name;
//-(void)openTencent:(double)myLatitude myLongitude:(double)myLongitude latitude:(double)latitude longitude:(double)longitude name:(NSString *)name;
//
//@end
//
