package cn.droidlover.xrecyclerview

import android.content.Context
import android.util.AttributeSet
import android.view.View
import androidx.annotation.ColorRes
import androidx.annotation.DimenRes
import androidx.recyclerview.widget.*
import cn.droidlover.xrecyclerview.divider.HorizontalDividerItemDecoration
import cn.droidlover.xrecyclerview.divider.VerticalDividerItemDecoration

/**
 * Created by wanglei on 2016/10/30.
 */

class XRecyclerView @JvmOverloads constructor(context: Context, attrs: AttributeSet? = null, defStyle: Int = 0) :
    RecyclerView(context, attrs, defStyle) {

    private var xFactor = 1.0f
    private var yFactor = 1.0f

    internal var layoutManagerType: LayoutManagerType? = null        //LayoutManager类型
    private var lastScrollPositions: IntArray? = null      //瀑布流位置存储
    private val firstScrollPositions: IntArray? = null

    internal var loadMoreUIHandler: LoadMoreUIHandler? = null
    internal var loadMoreView: View? = null      //加载更多控件

    private var loadMore = false
    private var totalPage = 1
    private var currentPage = 1
    private var isRefresh = false
    /**
     * 设置是否可下拉刷新
     *
     * @param refreshEnabled
     */
    var isRefreshEnabled = true  //是否可刷新
    private var lastVelocityY = 0

    internal var adapter: XRecyclerAdapter? = null

    var stateCallback: StateCallback? = null
        internal set
    var onRefreshAndLoadMoreListener: OnRefreshAndLoadMoreListener? = null

    val lastVisibleItemPosition: Int
        get() = getLastVisibleItemPosition(layoutManager)

    val headerCount: Int
        get() {
            var count = 0
            if (adapter != null) {
                count = adapter!!.headerSize
            }
            return count
        }

    val headerViewList: List<View>
        get() = if (adapter != null) {
            adapter!!.headerViewList
        } else listOf<View>()

    val footerCount: Int
        get() {
            val count = 0
            return if (adapter != null) {
                adapter!!.footerSize
            } else count
        }

    val footerViewList: List<View>
        get() = if (adapter != null) {
            adapter!!.footerViewList
        } else listOf<View>()

    internal var processMoreListener: RecyclerView.OnScrollListener = object : RecyclerView.OnScrollListener() {

        override fun onScrollStateChanged(recyclerView: RecyclerView, newState: Int) {
            super.onScrollStateChanged(recyclerView, newState)

            if (adapter == null
                || recyclerView.layoutManager == null
                || isRefresh
            )
                return

            val totalCount = adapter!!.itemCount

            if (newState == RecyclerView.SCROLL_STATE_IDLE
                && !loadMore
                && lastVelocityY > 0
                && getLastVisibleItemPosition(recyclerView.layoutManager) + LOAD_MORE_ITEM_SLOP > totalCount
            ) {

                if (totalPage > currentPage) {
                    loadMore = true

                    if (onRefreshAndLoadMoreListener != null) {
                        onRefreshAndLoadMoreListener!!.onLoadMore(++currentPage)

                        changeRefreshEnableState(false)

                        if (loadMoreUIHandler != null) {
                            loadMoreUIHandler!!.onLoading()
                        }
                    }
                } else {
                    if (adapter!!.dataCount > 0) {
                        //等于0 会显示空界面，所以不用显示 footer
                        loadMoreCompleted()
                    }
                }

            } else {
                changeRefreshEnableState(true)
            }

        }

        override fun onScrolled(recyclerView: RecyclerView, dx: Int, dy: Int) {
            super.onScrolled(recyclerView, dx, dy)
        }
    }

    init {
        setUpView()
    }

    private fun setUpView() {
        addOnScrollListener(processMoreListener)
    }

    override fun setAdapter(adapter: RecyclerView.Adapter<*>?) {
        var adapter: Adapter<*>? = adapter ?: return

        if (adapter !is XRecyclerAdapter) {
            adapter = XRecyclerAdapter(adapter)
        }

        super.setAdapter(adapter)

        if (adapter.itemCount > 0) {
            if (stateCallback != null) stateCallback!!.notifyContent()
        }

        val finalAdapter = adapter as XRecyclerAdapter?
        this.adapter = adapter
        useDefLoadMoreView()
        adapter.registerAdapterDataObserver(object : RecyclerView.AdapterDataObserver() {
            override fun onChanged() {
                super.onChanged()
                update()
            }

            override fun onItemRangeMoved(fromPosition: Int, toPosition: Int, itemCount: Int) {
                super.onItemRangeMoved(fromPosition, toPosition, itemCount)
                update()
            }

            override fun onItemRangeRemoved(positionStart: Int, itemCount: Int) {
                super.onItemRangeRemoved(positionStart, itemCount)
                update()
            }

            override fun onItemRangeInserted(positionStart: Int, itemCount: Int) {
                super.onItemRangeInserted(positionStart, itemCount)
                update()
            }

            override fun onItemRangeChanged(positionStart: Int, itemCount: Int) {
                super.onItemRangeChanged(positionStart, itemCount)
                update()
            }

            private fun update() {
                val dataCount = finalAdapter!!.dataCount
                if (dataCount > 0) {
                    if (isRefresh) {
                        isRefresh = false
                    }
                    if (loadMore) {
                        loadMoreCompleted()
                    }
                    if (stateCallback != null) stateCallback!!.notifyContent()
                } else {
                    if (finalAdapter.headerSize > 0 || finalAdapter.footerSize > 0) {
                        if (loadMoreView != null) loadMoreView!!.visibility = View.GONE
                    }
                    if (stateCallback != null) stateCallback!!.notifyEmpty()


                }

                if (stateCallback != null) stateCallback!!.refreshState(false)
            }
        })



    }

    fun stateCallback(stateCallback: StateCallback): XRecyclerView {
        this.stateCallback = stateCallback
        return this
    }

    override fun getAdapter(): XRecyclerAdapter? {
        return adapter
    }

    fun onRefresh() {
        currentPage = 1
        isRefresh = true
        if (onRefreshAndLoadMoreListener != null) {
            onRefreshAndLoadMoreListener!!.onRefresh()
        }
    }

    override fun setLayoutManager(layout: RecyclerView.LayoutManager?) {
        if (layout == null) {
            throw IllegalArgumentException("LayoutManager can not be null.")
        }
        super.setLayoutManager(layout)

        if (layout is GridLayoutManager) {
            val spanCount = layout.spanCount
            setSpanLookUp(layout, spanCount)
        }

        if (layout is StaggeredGridLayoutManager) {
            val spanCount = layout.spanCount
            setSpanLookUp(layout, spanCount)
        }
    }

    override fun fling(velocityX: Int, velocityY: Int): Boolean {
        lastVelocityY = velocityY
        return super.fling((velocityX * xFactor).toInt(), (velocityY * yFactor).toInt())
    }

    fun xFactor(xFactor: Float): XRecyclerView {
        this.xFactor = xFactor
        return this
    }

    fun yFactor(yFactor: Float): XRecyclerView {
        this.yFactor = yFactor
        return this
    }


    fun verticalLayoutManager(context: Context?): XRecyclerView {
        val manager = LinearLayoutManager(context)
        manager.orientation = RecyclerView.VERTICAL
        layoutManager = manager
        return this
    }

    fun horizontalLayoutManager(context: Context?): XRecyclerView {
        val manager = LinearLayoutManager(context)
        manager.orientation = LinearLayoutManager.HORIZONTAL
        layoutManager = manager
        return this
    }

    fun gridLayoutManager(context: Context?, spanCount: Int): XRecyclerView {
        val manager = GridLayoutManager(context, spanCount)
        layoutManager = manager
        return this
    }

    fun verticalStaggeredLayoutManager(spanCount: Int): XRecyclerView {
        val manager = StaggeredGridLayoutManager(spanCount, StaggeredGridLayoutManager.VERTICAL)
        layoutManager = manager
        return this
    }

    fun horizontalStaggeredLayoutManager(spanCount: Int): XRecyclerView {
        val manager = StaggeredGridLayoutManager(spanCount, StaggeredGridLayoutManager.VERTICAL)
        layoutManager = manager
        return this
    }

    private fun getLastVisibleItemPosition(layoutManager: RecyclerView.LayoutManager?): Int {
        var lastVisibleItemPosition = -1
        if (layoutManagerType == null) {
            if (layoutManager is LinearLayoutManager) {
                layoutManagerType = LayoutManagerType.LINEAR
            } else if (layoutManager is GridLayoutManager) {
                layoutManagerType = LayoutManagerType.GRID
            } else if (layoutManager is StaggeredGridLayoutManager) {
                layoutManagerType = LayoutManagerType.STAGGERED_GRID
            } else {
                throw RuntimeException("Unsupported LayoutManager used. Valid ones are LinearLayoutManager, GridLayoutManager and StaggeredGridLayoutManager")
            }
        }

        when (layoutManagerType) {
            XRecyclerView.LayoutManagerType.LINEAR -> lastVisibleItemPosition =
                (layoutManager as LinearLayoutManager).findLastVisibleItemPosition()
            XRecyclerView.LayoutManagerType.GRID -> lastVisibleItemPosition =
                (layoutManager as GridLayoutManager).findLastVisibleItemPosition()
            XRecyclerView.LayoutManagerType.STAGGERED_GRID -> {
                val staggeredGridLayoutManager = layoutManager as StaggeredGridLayoutManager?
                if (lastScrollPositions == null)
                    lastScrollPositions = IntArray(staggeredGridLayoutManager!!.spanCount)

                staggeredGridLayoutManager!!.findLastVisibleItemPositions(lastScrollPositions)
                lastVisibleItemPosition = findMax(lastScrollPositions!!)
            }
        }
        return lastVisibleItemPosition
    }


    private fun getFirstVisibleItemPosition(layoutManager: RecyclerView.LayoutManager): Int {
        var firstVisibleItemPosition = -1
        if (layoutManagerType == null) {
            if (layoutManager is LinearLayoutManager) {
                layoutManagerType = LayoutManagerType.LINEAR
            } else if (layoutManager is GridLayoutManager) {
                layoutManagerType = LayoutManagerType.GRID
            } else if (layoutManager is StaggeredGridLayoutManager) {
                layoutManagerType = LayoutManagerType.STAGGERED_GRID
            } else {
                throw RuntimeException("Unsupported LayoutManager used. Valid ones are LinearLayoutManager, GridLayoutManager and StaggeredGridLayoutManager")
            }
        }

        when (layoutManagerType) {
            XRecyclerView.LayoutManagerType.LINEAR -> firstVisibleItemPosition =
                (layoutManager as LinearLayoutManager).findFirstVisibleItemPosition()
            XRecyclerView.LayoutManagerType.GRID -> firstVisibleItemPosition =
                (layoutManager as GridLayoutManager).findFirstVisibleItemPosition()
            XRecyclerView.LayoutManagerType.STAGGERED_GRID -> {
                val staggeredGridLayoutManager = layoutManager as StaggeredGridLayoutManager
                if (lastScrollPositions == null)
                    lastScrollPositions = IntArray(staggeredGridLayoutManager.spanCount)

                staggeredGridLayoutManager.findLastVisibleItemPositions(firstScrollPositions)
                firstVisibleItemPosition = findMin(firstScrollPositions!!)
            }
        }
        return firstVisibleItemPosition
    }


    private fun findMax(lastPositions: IntArray): Int {
        var max = Integer.MIN_VALUE
        for (value in lastPositions) {
            if (value > max)
                max = value
        }
        return max
    }

    private fun findMin(positions: IntArray): Int {
        var min = Integer.MIN_VALUE
        for (value in positions) {
            if (value < min)
                min = value
        }
        return min
    }


    private fun setSpanLookUp(layoutManager: RecyclerView.LayoutManager, spanCount: Int) {
        if (layoutManager is GridLayoutManager) {
            layoutManager.spanSizeLookup = object : GridLayoutManager.SpanSizeLookup() {
                override fun getSpanSize(position: Int): Int {
                    return if (adapter != null) {
                        if (adapter!!.isHeaderOrFooter(position)) spanCount else 1
                    } else GridLayoutManager.DEFAULT_SPAN_COUNT
                }
            }
        } else if (layoutManager is StaggeredGridLayoutManager) {
            layoutManager.spanCount = spanCount
        }

    }

    /**
     * 设置SpanSizeLookup
     *
     * @param layoutManager
     * @param lookup
     */
    fun setGridSpanLookUp(layoutManager: GridLayoutManager, lookup: GridLayoutManager.SpanSizeLookup) {
        layoutManager.spanSizeLookup = object : GridLayoutManager.SpanSizeLookup() {
            override fun getSpanSize(position: Int): Int {
                return if (adapter != null) {
                    if (adapter!!.isHeaderOrFooter(position)) 1 else lookup.getSpanSize(position)

                } else GridLayoutManager.DEFAULT_SPAN_COUNT
            }
        }
    }

    fun addHeaderView(position: Int, view: View?): Boolean {
        var result = false
        if (view == null) {
            return result
        }
        if (adapter != null) {
            result = adapter!!.addHeadView(position, view)
        }
        return result
    }

    fun addHeaderView(view: View?): Boolean {
        var result = false
        if (view == null) {
            return result
        }
        if (adapter != null) {
            result = adapter!!.addHeadView(view)
        }
        return result
    }

    fun removeHeaderView(view: View?): Boolean {
        var result = false
        if (view == null) {
            return result
        }
        if (adapter != null) {
            result = adapter!!.removeHeadView(view)
        }
        return result
    }

    fun removeAllHeaderView(): Boolean {
        var result = false
        if (adapter != null) {
            result = adapter!!.removeAllHeadersView()
        }
        return result
    }

    fun addFooterView(view: View?): Boolean {
        var result = false
        if (view == null) {
            return result
        }
        if (adapter != null) {
            result = adapter!!.addFootView(view)
        }
        return result
    }

    fun addFooterView(position: Int, view: View?): Boolean {
        var result = false
        if (view == null) {
            return result
        }
        if (adapter != null) {
            result = adapter!!.addFootView(position, view)
        }
        return result
    }

    fun removeFooterView(view: View?): Boolean {
        var result = false
        if (view == null) {
            return result
        }
        if (adapter != null) {
            result = adapter!!.removeFootView(view)
        }
        return result
    }

    fun removeAllFootView(): Boolean {
        var result = false
        if (adapter != null) {
            result = adapter!!.removeAllFootView()
        }
        return result
    }

    /**
     * 使用默认的加载更多
     */
    fun useDefLoadMoreView() {
        val loadMoreFooter = SimpleLoadMoreFooter(context)
        setLoadMoreView(loadMoreFooter)
        setLoadMoreUIHandler(loadMoreFooter)
    }


    fun loadMoreFooterView(view: View) {
        setLoadMoreView(view)
        setLoadMoreUIHandler(view as LoadMoreUIHandler)
    }

    /**
     * 设置加载更多布局
     *
     * @param view
     */
    fun setLoadMoreView(view: View) {
        if (loadMoreView != null && loadMoreView !== view) {
            removeFooterView(view)
        }
        loadMoreView = view

        addFooterView(view)
    }

    fun setLoadMoreUIHandler(loadMoreUIHandler: LoadMoreUIHandler) {
        this.loadMoreUIHandler = loadMoreUIHandler
    }

    private fun loadMoreCompleted() {
        if (loadMoreUIHandler != null) {
            loadMoreUIHandler!!.onLoadFinish(totalPage > currentPage)
        }
        loadMore = false
        if (stateCallback != null) {
            changeRefreshEnableState(true)
            stateCallback!!.notifyContent()
        }
    }

    fun setPage(currentPage: Int, totalPage: Int) {
        this.currentPage = currentPage
        this.totalPage = totalPage
        if (loadMoreUIHandler != null && totalPage != 0) {
            loadMoreUIHandler!!.onLoadFinish(totalPage > currentPage)
        }
    }

    /**
     * 改变 刷新可用 的状态
     *
     * @param isEnabled
     */
    private fun changeRefreshEnableState(isEnabled: Boolean) {
        if (!isRefreshEnabled) return
        if (stateCallback != null) {
            stateCallback!!.refreshEnabled(isEnabled)
        }
    }

    /**
     * 刷新数据
     */
    fun refreshData() {
        if (stateCallback != null) stateCallback!!.refreshState(true)
        if (onRefreshAndLoadMoreListener != null) {
            onRefreshAndLoadMoreListener!!.onRefresh()
        }
    }

    fun setOnRefreshAndLoadMoreListener(onRefreshAndLoadMoreListener: OnRefreshAndLoadMoreListener): XRecyclerView {
        this.onRefreshAndLoadMoreListener = onRefreshAndLoadMoreListener
        //        changeRefreshEnableState(true);
        return this
    }

    fun noDivider(): XRecyclerView {
        itemAnimator = DefaultItemAnimator()
        setHasFixedSize(true)
        return this
    }

    fun horizontalDivider(@ColorRes colorRes: Int, @DimenRes dimenRes: Int): XRecyclerView {
        itemAnimator = DefaultItemAnimator()
        setHasFixedSize(true)
        addItemDecoration(
            HorizontalDividerItemDecoration.Builder(context)
                .colorResId(colorRes)
                .size(context.resources.getDimensionPixelSize(dimenRes))
                .build()
        )
        return this
    }

    fun verticalDivider(@ColorRes colorRes: Int, @DimenRes dimenRes: Int): XRecyclerView {
        itemAnimator = DefaultItemAnimator()
        setHasFixedSize(true)
        addItemDecoration(
            VerticalDividerItemDecoration.Builder(context)
                .colorResId(colorRes)
                .size(context.resources.getDimensionPixelSize(dimenRes))
                .build()
        )
        return this
    }



    internal enum class LayoutManagerType {
        LINEAR, GRID, STAGGERED_GRID
    }

    interface StateCallback {
        fun notifyEmpty()

        fun notifyContent()

        fun refreshState(isRefresh: Boolean)

        fun refreshEnabled(isEnabled: Boolean)
    }

    interface OnRefreshAndLoadMoreListener {
        fun onRefresh()

        fun onLoadMore(page: Int)
    }

    companion object {

        val LOAD_MORE_ITEM_SLOP = 2
    }
}