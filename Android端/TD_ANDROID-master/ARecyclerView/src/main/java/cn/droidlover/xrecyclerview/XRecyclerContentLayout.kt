package cn.droidlover.xrecyclerview

import android.content.Context
import android.graphics.Color
import android.util.AttributeSet
import android.view.View
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout
import cn.droidlover.xstatecontroller.XStateController

/**
 * Created by xuexuan on 2016/10/30.
 */

class XRecyclerContentLayout  : XStateController, XRecyclerView.StateCallback, SwipeRefreshLayout.OnRefreshListener {

    private var padding: Int = 0
    @get:JvmName("paddingLeft_")
    private var paddingLeft : Int = 0
    @get:JvmName("paddingRight_")
    private var paddingRight: Int = 0
    @get:JvmName("paddingTop_")
    private var paddingTop: Int = 0
    @get:JvmName("paddingTop_")
    private var paddingBottom: Int = 0
    private var scrollbarStyle: Int = 0

    @set:JvmName("backgroundColor_")
    private var backgroundColor: Int = 0

    @set:JvmName("clipToPadding_")
    @get:JvmName("clipToPadding_")
    private var clipToPadding: Boolean = false

    private var scrollbarNone = false

    lateinit var swipeRefreshLayout: SwipeRefreshLayout
    lateinit var recyclerView: XRecyclerView


    constructor(context: Context) : this(context,null)

    constructor(context: Context, attrs: AttributeSet?) : this(context, attrs,0)

    constructor(context: Context, attrs: AttributeSet?, defStyleAttr: Int) : super(context, attrs, defStyleAttr) {
        setupAttrs(context, attrs)
        inflateView(context)
    }


    fun init(context: Context, attrs: AttributeSet) {
        setupAttrs(context, attrs)
        inflateView(context)
    }

    private fun setupAttrs(context: Context, attrs: AttributeSet?) {
        val typedArray = context.obtainStyledAttributes(attrs, R.styleable.XRecyclerContentLayout)

        backgroundColor = typedArray.getColor(R.styleable.XRecyclerContentLayout_recyclerBackgroundColor, Color.WHITE)
        padding = typedArray.getDimension(R.styleable.XRecyclerContentLayout_recyclerPadding, -1.0f).toInt()
        paddingLeft = typedArray.getDimension(R.styleable.XRecyclerContentLayout_recyclerPaddingLeft, 0.0f).toInt()
        paddingRight = typedArray.getDimension(R.styleable.XRecyclerContentLayout_recyclerPaddingRight, 0.0f).toInt()
        paddingTop = typedArray.getDimension(R.styleable.XRecyclerContentLayout_recyclerPaddingTop, 0.0f).toInt()
        paddingBottom = typedArray.getDimension(R.styleable.XRecyclerContentLayout_recyclerPaddingBottom, 0.0f).toInt()
        scrollbarStyle = typedArray.getInt(R.styleable.XRecyclerContentLayout_recyclerScrollbarStyle, 2)
        clipToPadding = typedArray.getBoolean(R.styleable.XRecyclerContentLayout_recyclerClipToPadding, false)
        scrollbarNone = typedArray.getBoolean(R.styleable.XRecyclerContentLayout_recyclerScrollbarNone, false)

        typedArray.recycle()
    }

    private fun inflateView(context: Context) {
        View.inflate(context, R.layout.x_view_recycler_content_layout, this)
    }

    override fun onFinishInflate() {
        swipeRefreshLayout = findViewById(R.id.swipeRefreshLayout)
        recyclerView = findViewById(R.id.recyclerView)

        swipeRefreshLayout.isEnabled = false
        swipeRefreshLayout.setColorSchemeResources(
            R.color.x_red,
            R.color.x_blue,
            R.color.x_yellow,
            R.color.x_green
        )
        swipeRefreshLayout.setOnRefreshListener(this)
        if (padding != -1) {
            recyclerView.setPadding(padding, padding, padding, padding)
        } else {
            recyclerView.setPadding(paddingLeft, paddingTop, paddingRight, paddingBottom)
        }
        recyclerView.clipToPadding = clipToPadding

        if (scrollbarNone) {
            recyclerView.isVerticalScrollBarEnabled = false
            recyclerView.isHorizontalScrollBarEnabled = false
        } else {
            recyclerView.scrollBarStyle = scrollbarStyle
        }

        recyclerView.setBackgroundColor(backgroundColor)

        recyclerView.stateCallback(this)

        super.onFinishInflate()
    }

    override fun setDisplayState(displayState: Int) {
        val adapter = recyclerView.getAdapter()
        if (adapter != null && adapter.itemCount > 0) {
            super.setDisplayState(XStateController.Companion.STATE_CONTENT)
            return
        }
        super.setDisplayState(displayState)
    }

    override fun setDisplayState(state: Int, isForce: Boolean) {
        if (isForce) {
            super.setDisplayState(state)
            return
        }
        setDisplayState(state)
    }

    override fun showEmpty() {
        setDisplayState(XStateController.Companion.STATE_EMPTY, true)
    }

    override fun showError() {
        setDisplayState(XStateController.Companion.STATE_ERROR, true)
    }

    override fun showLoading() {
        setDisplayState(XStateController.Companion.STATE_LOADING, true)
    }

    override fun notifyEmpty() {
        showEmpty()
    }

    override fun notifyContent() {
        showContent()
    }

    override fun refreshState(isRefresh: Boolean) {
        swipeRefreshLayout.isRefreshing = isRefresh
    }

    override fun refreshEnabled(isEnabled: Boolean) {
        swipeRefreshLayout.isEnabled = isEnabled
    }

    override fun onRefresh() {
        recyclerView?.onRefresh()
    }
}
