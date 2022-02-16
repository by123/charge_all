package com.xhd.td.utils

/**
 * create by xuexuan
 * time 2019/6/17 13:00
 */

//经度和纬度
data class Point(var  lng:Double, var  lat:Double)

object CoordinateTransformUtils {

    // 圆周率π
    private val PI = 3.1415926535897932384626

    // 火星坐标系与百度坐标系转换的中间量
    private val X_PI = 3.14159265358979324 * 3000.0 / 180.0

    // Krasovsky 1940
    // 长半轴a = 6378245.0, 1/f = 298.3
    // b = a * (1 - f)
    // 扁率ee = (a^2 - b^2) / a^2;

    // 长半轴
    private val SEMI_MAJOR = 6378245.0

    // 扁率
    private val FLATTENING = 0.00669342162296594323

    // WGS84=>GCJ02 地球坐标系=>火星坐标系
    fun wgs84ToGcj02(lng: Double, lat: Double): Point {
        if (outOfChina(lng, lat)) {
            return Point(lng, lat)
        }

        val offset = offset(lng, lat)
        val mglng = lng + offset[0]
        val mglat = lat + offset[1]

        return Point(mglng, mglat)
    }

    // GCJ02=>WGS84 火星坐标系=>地球坐标系(粗略)
    fun gcj02ToWgs84(lng: Double, lat: Double): Point {
        if (outOfChina(lng, lat)) {
            return Point(lng, lat)
        }

        val offset = offset(lng, lat)
        val mglng = lng - offset[0]
        val mglat = lat - offset[1]

        return Point(mglng, mglat)
    }

    // GCJ02=>WGS84 火星坐标系=>地球坐标系（精确）
    fun gcj02ToWgs84Exactly(lng: Double, lat: Double): Point {
        if (outOfChina(lng, lat)) {
            return Point(lng, lat)
        }

        val initDelta = 0.01
        val threshold = 0.000000001
        var dLat = initDelta
        var dLon = initDelta
        var mLat = lat - dLat
        var mLon = lng - dLon
        var pLat = lat + dLat
        var pLon = lng + dLon
        var wgsLat: Double
        var wgsLng: Double
        var i = 0.0
        while (true) {
            wgsLat = (mLat + pLat) / 2
            wgsLng = (mLon + pLon) / 2
            val point = wgs84ToGcj02(wgsLng, wgsLat)
            dLon = point.lng - lng
            dLat = point.lat - lat
            if (Math.abs(dLat) < threshold && Math.abs(dLon) < threshold)
                break

            if (dLat > 0)
                pLat = wgsLat
            else
                mLat = wgsLat
            if (dLon > 0)
                pLon = wgsLng
            else
                mLon = wgsLng

            if (++i > 10000)
                break
        }

        return Point(wgsLng, wgsLat)
    }

    // GCJ-02=>BD09 火星坐标系=>百度坐标系
    fun gcj02ToBd09(lng: Double, lat: Double): Point {
        val z = Math.sqrt(lng * lng + lat * lat) + 0.00002 * Math.sin(lat * X_PI)
        val theta = Math.atan2(lat, lng) + 0.000003 * Math.cos(lng * X_PI)
        val bd_lng = z * Math.cos(theta) + 0.0065
        val bd_lat = z * Math.sin(theta) + 0.006
        return Point(bd_lng, bd_lat)
    }

    // BD09=>GCJ-02 百度坐标系=>火星坐标系
    fun bd09ToGcj02(lng: Double, lat: Double): Point {
        val x = lng - 0.0065
        val y = lat - 0.006
        val z = Math.sqrt(x * x + y * y) - 0.00002 * Math.sin(y * X_PI)
        val theta = Math.atan2(y, x) - 0.000003 * Math.cos(x * X_PI)
        val gcj_lng = z * Math.cos(theta)
        val gcj_lat = z * Math.sin(theta)
        return Point(gcj_lng, gcj_lat)
    }

    // WGS84=>BD09 地球坐标系=>百度坐标系
    fun wgs84ToBd09(lng: Double, lat: Double): Point {
        val point = wgs84ToGcj02(lng, lat)
        return gcj02ToBd09(point.lng, point.lat)
    }

    // BD09=>WGS84 百度坐标系=>地球坐标系
    fun bd09ToWgs84(lng: Double, lat: Double): Point {
        val point = bd09ToGcj02(lng, lat)
        return gcj02ToWgs84(point.lng, point.lat)
    }

    /**
     * Description: 中国境外返回true,境内返回false
     * @param lng    经度
     * @param lat    纬度
     * @return
     */
    fun outOfChina(lng: Double, lat: Double): Boolean {
        if (lng < 72.004 || lng > 137.8347)
            return true
        return if (lat < 0.8293 || lat > 55.8271) true else false
    }

    // 经度偏移量
    private fun transformLng(lng: Double, lat: Double): Double {
        var ret = 300.0 + lng + 2.0 * lat + 0.1 * lng * lng + 0.1 * lng * lat + 0.1 * Math.sqrt(Math.abs(lng))
        ret += (20.0 * Math.sin(6.0 * lng * PI) + 20.0 * Math.sin(2.0 * lng * PI)) * 2.0 / 3.0
        ret += (20.0 * Math.sin(lng * PI) + 40.0 * Math.sin(lng / 3.0 * PI)) * 2.0 / 3.0
        ret += (150.0 * Math.sin(lng / 12.0 * PI) + 300.0 * Math.sin(lng / 30.0 * PI)) * 2.0 / 3.0
        return ret
    }

    // 纬度偏移量
    private fun transformLat(lng: Double, lat: Double): Double {
        var ret = (-100.0 + 2.0 * lng + 3.0 * lat + 0.2 * lat * lat + 0.1 * lng * lat
                + 0.2 * Math.sqrt(Math.abs(lng)))
        ret += (20.0 * Math.sin(6.0 * lng * PI) + 20.0 * Math.sin(2.0 * lng * PI)) * 2.0 / 3.0
        ret += (20.0 * Math.sin(lat * PI) + 40.0 * Math.sin(lat / 3.0 * PI)) * 2.0 / 3.0
        ret += (160.0 * Math.sin(lat / 12.0 * PI) + 320 * Math.sin(lat * PI / 30.0)) * 2.0 / 3.0
        return ret
    }

    // 偏移量
    fun offset(lng: Double, lat: Double): DoubleArray {
        val lngLat = DoubleArray(2)
        var dlng = transformLng(lng - 105.0, lat - 35.0)
        var dlat = transformLat(lng - 105.0, lat - 35.0)
        val radlat = lat / 180.0 * PI
        var magic = Math.sin(radlat)
        magic = 1 - FLATTENING * magic * magic
        val sqrtmagic = Math.sqrt(magic)
        dlng = dlng * 180.0 / (SEMI_MAJOR / sqrtmagic * Math.cos(radlat) * PI)
        dlat = dlat * 180.0 / (SEMI_MAJOR * (1 - FLATTENING) / (magic * sqrtmagic) * PI)
        lngLat[0] = dlng
        lngLat[1] = dlat
        return lngLat
    }

}