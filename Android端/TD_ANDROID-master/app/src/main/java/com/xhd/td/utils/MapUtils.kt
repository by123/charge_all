package com.xhd.td.utils

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.Canvas
import android.net.Uri
import android.text.TextUtils
import android.util.DisplayMetrics
import android.view.View
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.Toast
import com.amap.api.location.AMapLocation
import com.amap.api.maps.AMap
import com.amap.api.maps.CameraUpdateFactory
import com.amap.api.maps.model.LatLng
import com.amap.api.services.core.LatLonPoint
import com.amap.api.services.core.PoiItem
import com.amap.api.services.geocoder.GeocodeResult
import com.amap.api.services.geocoder.GeocodeSearch
import com.amap.api.services.geocoder.RegeocodeQuery
import com.amap.api.services.geocoder.RegeocodeResult
import com.xhd.td.constants.Constants


/**
 * Created by Administrator on 2017/2/28.
 */
object MapUtils {

    private val zoomLovel = 18

    fun moveMapToLat(aMap: AMap, latLng: LatLng) {
        aMap.animateCamera(
            CameraUpdateFactory.newLatLngZoom(
                LatLng(latLng.latitude, latLng.longitude),
                zoomLovel.toFloat()
            )
        )
    }

    /**
     * 经纬度转换成地址
     * @param latLng
     */
    fun locationToAddress(mContext: Context, latLng: LatLng, tv: TextView) {
        val geocodeSearch = GeocodeSearch(mContext)
        val query = RegeocodeQuery(LatLonPoint(latLng.latitude, latLng.longitude), 200f, GeocodeSearch.AMAP)
        geocodeSearch.getFromLocationAsyn(query)
        geocodeSearch.setOnGeocodeSearchListener(object : GeocodeSearch.OnGeocodeSearchListener {
            override fun onRegeocodeSearched(regeocodeResult: RegeocodeResult?, rCode: Int) {
                if (rCode != 1000) {
                    return
                }

                if (null != regeocodeResult && null != regeocodeResult.regeocodeAddress) {
                    val address = regeocodeResult.regeocodeAddress
                    tv.text = address.formatAddress
                }
            }

            override fun onGeocodeSearched(geocodeResult: GeocodeResult, rCode: Int) {

            }
        })
    }

    /**
     * 计算两点之间距离
     *
     * @param startLatLng
     * @param endLatLng
     * @return 米
     */
    fun getDistance(startLatLng: LatLng, endLatLng: LatLng): Double {

        val lat1 = Math.PI / 180 * startLatLng.latitude
        val lat2 = Math.PI / 180 * endLatLng.latitude

        val lon1 = Math.PI / 180 * startLatLng.longitude
        val lon2 = Math.PI / 180 * endLatLng.longitude

        //地球半径
        val R = 6371.0

        //两点间距离 km，如果想要米的话，结果*1000就可以了
        val d = Math.acos(Math.sin(lat1) * Math.sin(lat2) + Math.cos(lat1) * Math.cos(lat2) * Math.cos(lon2 - lon1)) * R

        return d * 1000
    }


    fun createDrawableFromView(mContext: Context, view: View): Bitmap {
        val displayMetrics = DisplayMetrics()
        (mContext as Activity).windowManager.defaultDisplay.getMetrics(displayMetrics)
        view.layoutParams =
            LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT)
        view.measure(displayMetrics.widthPixels, displayMetrics.heightPixels)
        view.layout(0, 0, displayMetrics.widthPixels, displayMetrics.heightPixels)
        view.buildDrawingCache()
        val bitmap = Bitmap.createBitmap(view.measuredWidth, view.measuredHeight, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        view.draw(canvas)
        return bitmap
    }

    /**
     * view 转 bitmap
     * @param view
     * @return
     */
    fun convertViewToBitmap(view: View): Bitmap {
        val bitmap = Bitmap.createBitmap(view.width, view.height, Bitmap.Config.ARGB_8888)
        //利用bitmap生成画布
        val canvas = Canvas(bitmap)
        //把view中的内容绘制在画布上
        view.draw(canvas)
        return bitmap
    }


    fun changeToAMapLocation(poiItem: PoiItem?): AMapLocation? {
        if (null != poiItem) {
            try {
                val aMapLocation = AMapLocation("lbs")
                aMapLocation.adCode = poiItem.adCode
                aMapLocation.address = poiItem.provinceName + poiItem.cityName + poiItem.adName + poiItem.snippet
                aMapLocation.city = poiItem.cityName
                aMapLocation.cityCode = poiItem.cityCode
                aMapLocation.district = poiItem.adName
                aMapLocation.latitude = poiItem.latLonPoint.latitude
                aMapLocation.longitude = poiItem.latLonPoint.longitude
                aMapLocation.poiName = poiItem.title
                aMapLocation.province = poiItem.provinceName
                aMapLocation.street = poiItem.businessArea
                return aMapLocation
            } catch (ex: Exception) {
                ex.printStackTrace()
                return null
            }

        }
        return null
    }

    fun changeToPoiItem(data: AMapLocation?): PoiItem? {
        if (null != data) {
            try {
                var title = data.description
                if (TextUtils.isEmpty(title)) {
                    title = data.poiName
                }
                if (TextUtils.isEmpty(title)) {
                    title = data.street
                }
                if (TextUtils.isEmpty(title)) {
                    title = "[位置]"
                }

                val poiItem = PoiItem(data.buildingId, LatLonPoint(data.latitude, data.longitude), title, data.address)

                poiItem.adCode = data.adCode
                poiItem.adName = data.district
                poiItem.businessArea = data.street
                poiItem.cityCode = data.cityCode
                poiItem.cityName = data.city
                poiItem.provinceName = data.province

                return poiItem
            } catch (ex: Exception) {
                ex.printStackTrace()
                return null
            }

        }
        return null
    }

    fun changeToPoiItem(data: RegeocodeResult?): PoiItem? {
        if (null != data) {
            try {
                var title = data.regeocodeAddress.building

                if (TextUtils.isEmpty(title)) {
                    title = data.regeocodeAddress.streetNumber.street + data.regeocodeAddress.streetNumber.number
                }

                if (TextUtils.isEmpty(title)) {
                    title = data.regeocodeAddress.neighborhood
                }
                if (TextUtils.isEmpty(title)) {
                    title = data.regeocodeAddress.township
                }
                if (TextUtils.isEmpty(title)) {
                    title = "[位置]"
                }

                val snippet = data.regeocodeAddress.township + (data.regeocodeAddress.streetNumber?.street?:"") + (data.regeocodeAddress.streetNumber?.number?:"") + (data.regeocodeAddress.aois.getOrNull(0)?.aoiName?:"")

                val poiItem = PoiItem(
                    data.regeocodeAddress.building,
                    data.regeocodeQuery.point,
                    title,
                    snippet
                )

                poiItem.businessArea = data.regeocodeAddress?.businessAreas?.getOrNull(0)?.name
                poiItem.adCode = data.regeocodeAddress.adCode
                poiItem.adName = data.regeocodeAddress.district
                poiItem.cityCode = data.regeocodeAddress.cityCode
                poiItem.cityName = data.regeocodeAddress.city
                poiItem.provinceName = data.regeocodeAddress.province

                return poiItem
            } catch (ex: Exception) {
                ex.printStackTrace()
                return null
            }

        }
        return null
    }


    fun getMapApp(context: Context): List<String> {

        val lPackageName = AppUtils.getPackageName(context)
        val mapAppList = arrayListOf<String>()

        if (lPackageName.contains(Constants.BAI_DU_MAP)){
            mapAppList.add(Constants.BAI_DU_MAP_TYPE)
        }

        if (lPackageName.contains(Constants.AMAP)){
            mapAppList.add(Constants.AMAP_TYPE)
        }

        if (lPackageName.contains(Constants.TENCENT_MAP)){
            mapAppList.add(Constants.TENCENT_MAP_TYPE)
        }

        if (mapAppList.isEmpty()){
            Toast.makeText(context, "请先安装地图APP", Toast.LENGTH_LONG).show()
        }

        return mapAppList
    }


    fun navigate(context: Context, mapType: String, destination: LatLng) {
        val stringBuffer = StringBuilder()

        when {
            mapType.contains(Constants.BAI_DU_MAP_TYPE) -> {
                //百度地图导航
                //官方文档http://lbsyun.baidu.com/index.php?title=uri/api/android
                val i1 = Intent()
                val point = CoordinateTransformUtils.gcj02ToBd09(destination.longitude,destination.latitude)
                stringBuffer.append("baidumap://map/direction?")
                    .append("coord_type=bd09ll")
                    .append("origin=")
//                    .append("name:").append(mPoiName).append("|")
//                    .append("latlng:").append(origin.latitude).append(",").append(origin.longitude)
                    .append("&destination=").append(point.lat).append(",").append(point.lng)
                    .append("&mode=driving")

                i1.data = Uri.parse(stringBuffer.toString())
                context.startActivity(i1)
            }
            mapType.contains(Constants.AMAP_TYPE) -> {
                //高德地图导航
                //官方文档http://lbs.amap.com/api/amap-mobile/guide/android/navigation
                val intent = Intent("android.intent.action.VIEW")
                stringBuffer.append("androidamap://navi?sourceApplication=").append(context.packageName)
                stringBuffer.append("&lat=").append(destination.latitude)
                    .append("&lon=").append(destination.longitude)
                    .append("&dev=").append("0")


                intent.addCategory("android.intent.category.DEFAULT")
                intent.setPackage("com.autonavi.minimap")
                intent.data = Uri.parse(stringBuffer.toString())
                context.startActivity(intent)
            }

            mapType.contains(Constants.TENCENT_MAP_TYPE) -> {
                //腾讯地图导航
                val i1 = Intent()
                stringBuffer.append("qqmap://map/routeplan?type=drive")
                    .append("&fromcoord=CurrentLocation")
                    .append("&tocoord=").append(destination.latitude).append(",").append(destination.longitude)
//                    .append("&referer=driving")

//                i1.data = Uri.parse("qqmap://map/routeplan?type=drive&from=清华&fromcoord=39.994745,116.247282&to=怡和世家&tocoord=39.867192,116.493187&referer=OB4BZ-D4W3U-B7VVO-4PJWW-6TKDJ-WPB77")
                i1.data = Uri.parse(stringBuffer.toString())
                context.startActivity(i1)
            }
        }
    }


}
