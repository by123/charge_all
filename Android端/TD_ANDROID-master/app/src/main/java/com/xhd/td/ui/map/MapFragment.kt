package com.xhd.td.ui.map

import android.animation.ObjectAnimator
import android.graphics.BitmapFactory
import android.graphics.Color
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.RelativeLayout
import androidx.coordinatorlayout.widget.CoordinatorLayout
import androidx.lifecycle.ViewModelProviders
import cn.droidlover.xrecyclerview.RecyclerItemCallback
import cn.xuexuan.mvvm.event.BusProvider
import com.amap.api.maps.AMap
import com.amap.api.maps.CameraUpdateFactory
import com.amap.api.maps.UiSettings
import com.amap.api.maps.model.*
import com.amap.api.services.core.LatLonPoint
import com.amap.api.services.core.PoiItem
import com.amap.api.services.geocoder.*
import com.amap.api.services.poisearch.PoiResult
import com.amap.api.services.poisearch.PoiSearch
import com.google.android.material.appbar.AppBarLayout
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.adapter.map.MapAdapter
import com.xhd.td.base.BaseFragment
import com.xhd.td.constants.EventKey
import com.xhd.td.model.EventMessage
import com.xhd.td.model.bean.OrderData
import com.xhd.td.utils.MapUtils
import com.xhd.td.view.LoadMoreView
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.map.MapCB
import com.xhd.td.vm.map.MapVM
import kotlinx.android.synthetic.main.fragment_map.*
import kotlinx.android.synthetic.main.title_bar.*
import javax.inject.Inject


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

class MapFragment : BaseFragment<com.xhd.td.databinding.FragmentMapBinding, MapVM, MapCB>(), MapCB {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_map
    override val viewModel: MapVM get() = ViewModelProviders.of(this, factory).get(MapVM::class.java)


    lateinit var mListLayout: LoadMoreView<PoiItem, MapAdapter.ViewHolder>
    private var mAMap: AMap? = null

    private var mTransAnimator: ObjectAnimator? = null//地图中心标志动态
    private var mUiSettings: UiSettings? = null

    //创建adapter，并设置点击回调事件
    private lateinit var mListAdapter: MapAdapter


    private var mSelectLatLng: LatLng? = null
    private var mPhoneLatLng: LatLng? = null
    private var mSelectAddress: RegeocodeAddress? = null
    private var mOnPoiSearchListener: PoiSearch.OnPoiSearchListener? = null
    private var mQuery: PoiSearch.Query? = null

    private var mSearchNowPageIndex = 1
    //一次用户主动拖拽，执行一次动作，在本次的拖拽中，其他的操作都不执行
    private var mHandleSlipEvent = false

    override fun initView(view: View) {
        super.initView(view)
        viewModel.mCallback = this
        toolBar.setNavigationOnClickListener { close() }
        title.text = "位置"

        mListAdapter = MapAdapter(context!!, { params -> })
        mListLayout = LoadMoreView(context!!, mListAdapter) { pageId: Int -> getMoreData(pageId) }

        val view = mListLayout.initView()
        val lp = RelativeLayout.LayoutParams(
            RelativeLayout.LayoutParams.MATCH_PARENT,
            RelativeLayout.LayoutParams.MATCH_PARENT
        )

        lp.addRule(RelativeLayout.ALIGN_PARENT_LEFT)//与父容器的左侧对齐
        lp.addRule(RelativeLayout.ALIGN_PARENT_TOP)//与父容器的上侧对齐
//      view.setId(1)//设置这个View 的id
        view.layoutParams = lp//设置布局参数
        rl_content.addView(view)

        mTransAnimator = ObjectAnimator.ofFloat(img_center_location, "translationY", 0f, -80f, 0f)
        mTransAnimator?.duration = 500
    }


    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        //在activity执行onCreate时执行mMapView.onCreate(savedInstanceState)，创建地图
        map.onCreate(savedInstanceState)
        mAMap = map.map
        initListener()
    }


    override fun onLazyInitView(savedInstanceState: Bundle?) {
        super.onLazyInitView(savedInstanceState)
        //设置地图的ui界面
        mUiSettings = mAMap?.uiSettings
        mUiSettings?.isZoomControlsEnabled = false//是否显示地图中放大缩小按钮
        mUiSettings?.isMyLocationButtonEnabled = false // 是否显示默认的定位按钮
        mUiSettings?.isScaleControlsEnabled = true//是否显示缩放级别

    }

    override fun onSupportVisible() {
        super.onSupportVisible()
        map.onResume()
    }

    override fun onSupportInvisible() {
        super.onSupportInvisible()
        map.onPause()
    }


    override fun onDestroyView() {
        super.onDestroyView()
        map.onDestroy()
    }


    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        //在activity执行onSaveInstanceState时执行mMapView.onSaveInstanceState (outState)，保存地图当前的状态
        map.onSaveInstanceState(outState)
    }


    private var mToShrink = false

    private fun changeMapLayout() {

        val l = map.layoutParams
        if (mToShrink) {
            l.height = l.height - 400
        } else {
            l.height = l.height + 400

        }
        map.layoutParams = l
        //防止上拉的时候，地图缩小，导致启动刷新按钮
        mListLayout.mXRecyclerView.isRefreshEnabled = false
    }


    private var mRefreshPoi = true


    private fun initListener() {

        mAMap?.setOnMapLoadedListener {
            // 自定义系统定位小蓝点
            //初始化定位蓝点样式类myLocationStyle.myLocationType(MyLocationStyle.LOCATION_TYPE_LOCATION_ROTATE);//连续定位、且将视角移动到地图中心点，定位点依照设备方向旋转，并且会跟随设备移动。（1秒1次定位）如果不设置myLocationType，默认也会执行此种模式。
            val myLocationStyle = MyLocationStyle()
            myLocationStyle.myLocationType(MyLocationStyle.LOCATION_TYPE_SHOW) //只定位一次。
            // 设置小蓝点的图标
            myLocationStyle.myLocationIcon(BitmapDescriptorFactory.fromResource(com.xhd.td.R.drawable.map_location_direction))
            // 设置圆形的填充颜色
            myLocationStyle.radiusFillColor(Color.argb(20, 0, 0, 220))
            // 设置圆形的边框颜色
            myLocationStyle.strokeColor(Color.argb(30, 0, 0, 220))
            // 设置圆形的边框粗细
            myLocationStyle.strokeWidth(1.0f)
            mAMap?.myLocationStyle = myLocationStyle//设置定位蓝点的Style
            mAMap?.isMyLocationEnabled = true// 设置为true表示启动显示定位蓝点，false表示隐藏定位蓝点并不进行定位，默认是false。 }

        }

        //监测地图画面的移动
        mAMap?.setOnCameraChangeListener(object : AMap.OnCameraChangeListener {
            override fun onCameraChangeFinish(cameraPosition: CameraPosition?) {
                if (null != cameraPosition && mRefreshPoi) {
                    //重新选点之后，需要清除之前的POI数据
                    mListAdapter.clearData()
                    mPoiItemList.clear()
                    //再次开始搜索POI，从第0页开始搜索
                    mSearchNowPageIndex = 1
                    getAddressInfoByLatLong(cameraPosition.target.latitude, cameraPosition.target.longitude)
                    startTransAnimator()
                }
                //如果mRefreshPoi为false，说明是选择了poi自动移动地图，这里重新置位true，保障下次手动移动可以正常的定位
                if (!mRefreshPoi) {
                    mRefreshPoi = true
                }
            }

            override fun onCameraChange(cameraPosition: CameraPosition) {

            }
        })

        //设置触摸地图监听器
        mAMap?.setOnMapClickListener {
            mRefreshPoi = true
            if (mToShrink) {
                //向上滚动就缩小map的高
                mToShrink = false
                changeMapLayout()
            }
        }


        //设置SDK 自带定位消息监听
        mAMap?.setOnMyLocationChangeListener { location ->
            // 定位回调监听
            if (location != null) {
                Log.e("amap", "onMyLocationChange 定位成功， lat: " + location.latitude + " lon: " + location.longitude)
                mSelectLatLng = LatLng(location.latitude, location.longitude)
                mPhoneLatLng = LatLng(location.latitude, location.longitude)
                moveMapCamera(mSelectLatLng)
                val bundle = location.extras
                if (bundle != null) {
                    val errorCode = bundle.getInt(MyLocationStyle.ERROR_CODE)
                    val errorInfo = bundle.getString(MyLocationStyle.ERROR_INFO)
                    // 定位类型，可能为GPS WIFI等，具体可以参考官网的定位SDK介绍
                    val locationType = bundle.getInt(MyLocationStyle.LOCATION_TYPE)

                    /*
                errorCode
                errorInfo
                locationType
                */
                    Log.e("amap", "定位信息， code: $errorCode errorInfo: $errorInfo locationType: $locationType")
                } else {
                    Log.e("amap", "定位信息， bundle is null ")
                }
            } else {
                Log.e("amap", "定位失败")
            }
        }


        //重写Poi搜索监听器，可扩展上拉加载数据，下拉刷新
        mOnPoiSearchListener = object : PoiSearch.OnPoiSearchListener {
            override fun onPoiSearched(result: PoiResult?, i: Int) {
                if (i == 1000) {
                    if (result != null && result.query != null) {// 搜索poi的结果
                        if (result.query == mQuery) {// 是否是同一条
                            mListLayout.setTotal(mSearchNowPageIndex, result.pageCount, result.pois.size)
                            mPoiItemList.addAll(result.pois)
                            mListAdapter.setData(mPoiItemList)
                            mListAdapter.setSelectPosition(0)
                        }
                    }
                }
            }

            override fun onPoiItemSearched(poiItem: PoiItem, i: Int) {

            }
        }

        //列表item 点击监听
        mListAdapter.recItemClick = object : RecyclerItemCallback<PoiItem, MapAdapter.ViewHolder>() {
            override fun onItemClick(position: Int, model: PoiItem?, tag: Int, holder: MapAdapter.ViewHolder?) {
                super.onItemClick(position, model, tag, holder)
                val latLonPoint = model?.latLonPoint
                if (latLonPoint != null) {
                    moveMapCamera(latLonPoint.latitude, latLonPoint.longitude)
//                    refreshMarkByPoi(latLonPoint.latitude, latLonPoint.longitude)
                    mRefreshPoi = false


                }
            }
        }

        //防止在appBarLayout 中的地图拖拽事件，被CoordinatorLayout，导致滑动了appBarLayout，而不是拖拽地图
        val params = appBarLayout.layoutParams as CoordinatorLayout.LayoutParams
        val appBarLayoutBehaviour = AppBarLayout.Behavior()
        appBarLayoutBehaviour.setDragCallback(object : AppBarLayout.Behavior.DragCallback() {
            override fun canDrag(appBarLayout: AppBarLayout): Boolean {
                return false
            }
        })
        params.behavior = appBarLayoutBehaviour

        img_phone_location.setOnClickListener { moveMapCamera(mPhoneLatLng) }

        //滑动时间监听
//        mListLayout.mXRecyclerView.addOnScrollListener(object : RecyclerView.OnScrollListener() {
//            override fun onScrolled(recyclerView: RecyclerView, dx: Int, dy: Int) {
//                super.onScrolled(recyclerView, dx, dy)
//
//
//                Log.i("滑动监听", "-----------onScrolled-----------");
//                Log.i("滑动监听", "dx: " + dx);
//                Log.i("滑动监听", "dy: " + dy);
//                Log.i("滑动监听", "CHECK_SCROLL_UP: " + recyclerView.canScrollVertically(-1));
//                Log.i("滑动监听", "CHECK_SCROLL_DOWN: " + recyclerView.canScrollVertically(1));
//                //dy大于0，表示向上滚动
//                if (dy > 10) {
//                    if (mHandleSlipEvent) {
//                        if (!mToShrink) {
//                            //向上滚动就缩小map的高
//                            mToShrink = true
//                            //手指滑动，
//                            mHandleSlipEvent = false
//                            changeMapLayout()
//
//                        }
//                    }
//                } else if (dy == 0 && !recyclerView.canScrollVertically(-1)) {
//                    //向下滚动，滚动到顶部，不能再继续向下滚动，恢复map的高
//                    //已经滑到第一项，滑不动了
//
//                        if (mToShrink) {
//                            mToShrink = false
//                            //手指滑动，
//                            mHandleSlipEvent = false
//                            changeMapLayout()
//                        }
//
//                }
//            }
//
//            override fun onScrollStateChanged(recyclerView: RecyclerView, newState: Int) {
//                super.onScrollStateChanged(recyclerView, newState)
//                Log.i("滑动类型", "-----------onScrollStateChanged-----------")
//                Log.i("滑动类型", "newState: " + newState)
//                mHandleSlipEvent = newState == SCROLL_STATE_DRAGGING
//            }
//        })

    }


    private var mPoiItemList: ArrayList<PoiItem?> = arrayListOf()

    /**
     * 通过经纬度获取当前地址详细信息，逆地址编码
     *
     * @param latitude
     * @param longitude
     */
    private fun getAddressInfoByLatLong(latitude: Double, longitude: Double) {
        mSelectLatLng = LatLng(latitude, longitude)
        val geocodeSearch = GeocodeSearch(_mActivity)
        /*
        point - 要进行逆地理编码的地理坐标点。
        radius - 查找范围。默认值为1000，取值范围1-3000，单位米。
        latLonType - 输入参数坐标类型。包含GPS坐标和高德坐标。 可以参考RegeocodeQuery.setLatLonType(String)
        */

//        val query = RegeocodeQuery(LatLonPoint(35.6040100000, 110.9831100000), 3000f, GeocodeSearch.AMAP)
        val query = RegeocodeQuery(LatLonPoint(latitude, longitude), 3000f, GeocodeSearch.AMAP)
        geocodeSearch.getFromLocationAsyn(query)
        geocodeSearch.setOnGeocodeSearchListener(object : GeocodeSearch.OnGeocodeSearchListener {
            override fun onRegeocodeSearched(regeocodeResult: RegeocodeResult?, i: Int) {
                if (i == 1000) {
                    if (regeocodeResult != null) {
                        mSelectAddress = regeocodeResult.regeocodeAddress
                        mPoiItemList.add(0, MapUtils.changeToPoiItem(regeocodeResult))
                        doSearchQuery(
                            mSearchNowPageIndex,
                            "",
                            mSelectAddress?.city ?: "",
                            LatLonPoint(mSelectLatLng?.latitude ?: 0.0, mSelectLatLng?.longitude ?: 0.0)
                        )
                    }
                }
            }

            override fun onGeocodeSearched(geocodeResult: GeocodeResult, i: Int) {

            }
        })
    }


    /**
     * 地图中心的选点图片，从天而降的动画
     */
    private fun startTransAnimator() {
        if (null != mTransAnimator && mTransAnimator?.isRunning != true) {
            mTransAnimator?.start()
        }
    }

    private var mPoiMarker: Marker? = null


    /**
     * 刷新地图标志物选中列表的位置
     *
     * @param latitude
     * @param longitude
     */
    private fun refreshMarkByPoi(latitude: Double, longitude: Double) {
        if (mPoiMarker == null) {
            mPoiMarker = mAMap?.addMarker(
                MarkerOptions()
                    .anchor(0.5f, 0.5f)
                    .position(LatLng(latitude, longitude))
                    .icon(
                        BitmapDescriptorFactory.fromBitmap(
                            BitmapFactory.decodeResource(
                                resources,
                                R.drawable.map_location_direction
                            )
                        )
                    )
                    .draggable(true)
            )
        }
        mPoiMarker?.position = LatLng(latitude, longitude)
        if (mPoiMarker?.isVisible == true) {
            mPoiMarker?.isVisible = true
        }
    }


    /**
     * 把地图画面移动到定位地点(使用moveCamera方法没有动画效果)
     *
     * @param latitude
     * @param longitude
     */
    private fun moveMapCamera(latitude: Double, longitude: Double) {
        moveMapCamera(LatLng(latitude, longitude))
    }

    private fun moveMapCamera(latLng: LatLng?) {
        if (latLng != null) {
            mAMap?.animateCamera(CameraUpdateFactory.newLatLngZoom(latLng, ZOOM))
        }
    }


    /**
     * 开始进行poi搜索
     *
     * @param isReflsh 是否为刷新数据
     * @param keyWord
     * @param city
     * @param lpTemp
     */
    private fun doSearchQuery(pageId: Int, keyWord: String, city: String, lpTemp: LatLonPoint?) {
        mQuery = PoiSearch.Query(keyWord, "", city)//第一个参数表示搜索字符串，第二个参数表示poi搜索类型，第三个参数表示poi搜索区域（空字符串代表全国）
        mQuery?.pageSize = 30// 设置每页最多返回多少条poiitem
        mQuery?.pageNum = pageId// 设置查询的页码

        val mPoiSearch = PoiSearch(_mActivity, mQuery)
        mPoiSearch.setOnPoiSearchListener(mOnPoiSearchListener)
        if (lpTemp != null) {
            mPoiSearch.bound = PoiSearch.SearchBound(lpTemp, 10000, true)//该范围的中心点-----半径，单位：米-----是否按照距离排序
        }
        mPoiSearch.searchPOIAsyn()// 异步搜索
    }


    private fun getMoreData(pageId: Int) {

        mSearchNowPageIndex = pageId
        if (pageId == 1) {
            mListAdapter.clearData()
            mPoiItemList.clear()
            getAddressInfoByLatLong(mSelectLatLng?.latitude ?: 0.0, mSelectLatLng?.longitude ?: 0.0)
        } else {
            doSearchQuery(
                mSearchNowPageIndex,
                "",
                mSelectAddress?.city ?: "",
                LatLonPoint(mSelectLatLng?.latitude ?: 0.0, mSelectLatLng?.longitude ?: 0.0)
            )
        }
    }

    //通过rxbus，发送选中的item的位置信息
    public fun sendSelectedLocationInfo() {

        val position = mListAdapter.getSelectPositon()
        if (position == -1 || position >= mPoiItemList.size) {
            showToast("地址选择错误")
            return
        }
        val poiItem = mPoiItemList[position]
        if (poiItem != null) {
            val location = arrayListOf(poiItem.provinceName, poiItem.cityName, poiItem.adName)
            if (position == 0) {
                location.add(poiItem.snippet)
            } else {
                location.add(poiItem.snippet + poiItem.title)
            }

            //发送的顺序是省市区，详细地址
            BusProvider.getBus()?.post(EventMessage<List<String>>(EventKey.SELECTED_LOCATION, location))
            close()
        } else {
            showToast("已选地址为空，请重新选择")
        }
    }


    override fun getListSuccess(data: OrderData, viewPageId: Int) {
        //根据分页的数量和总数据是否为0 ，显示不同的界面
//        mListLayout.setTotal(data.pageId, data.pageCount, data.totalCount)
//        mListLayout.mAdapter.addData(data.rows)

    }

    override fun getListFail(msg: String?) {
        showToast(msg)
    }


    override fun handleError(throwable: Throwable) {

    }

    companion object {
        fun newInstance() = MapFragment()
        const val START_PAGE_ID = 1
        const val ZOOM: Float = 16f

    }
}