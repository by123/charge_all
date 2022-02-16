package cn.droidlover.xstatecontroller

import android.content.Context
import android.os.Parcel
import android.os.Parcelable
import android.util.AttributeSet
import android.view.View
import android.view.ViewStub
import android.widget.FrameLayout
import cn.droidlover.xrecyclerview.R

/**
 * Created by wanglei on 2016/1/21.
 */


open class XStateController constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = 0
) : FrameLayout(context, attrs, defStyleAttr) {

    var loadingView: View? = null
        internal set
    var errorView: View? = null
        internal set
    var emptyView: View? = null
        internal set
    var contentView: View? = null
        internal set
    var state = -1
        internal set

    private var loadingLayoutId: Int = 0
    private var errorLayoutId: Int = 0
    private var emptyLayoutId: Int = 0
    private var contentLayoutId: Int = 0

    private var stateChangeListener: OnStateChangeListener? = null

    private var mFinishInflate = false


    public var loadingVisibility: Int = View.GONE
        set(value) {
            if (mFinishInflate) {
                loadingView?.visibility = value
            }
            field = value
        }


    init {
        setupAttrs(context, attrs)
    }

    private fun setupAttrs(context: Context, attrs: AttributeSet?) {
        val typedArray = context.obtainStyledAttributes(attrs, R.styleable.XStateController)
        loadingLayoutId = typedArray.getResourceId(R.styleable.XStateController_x_loadingLayoutId, RES_NONE)
        errorLayoutId = typedArray.getResourceId(R.styleable.XStateController_x_errorLayoutId, RES_NONE)
        emptyLayoutId = typedArray.getResourceId(R.styleable.XStateController_x_emptyLayoutId, RES_NONE)
        contentLayoutId = typedArray.getResourceId(R.styleable.XStateController_x_contentLayoutId, RES_NONE)
        contentLayoutId = typedArray.getResourceId(R.styleable.XStateController_x_contentLayoutId, RES_NONE)
        loadingVisibility = typedArray.getInt(R.styleable.XStateController_loadingVisibility, View.GONE)
        typedArray.recycle()
    }

    override fun onFinishInflate() {
        super.onFinishInflate()

        val childCount = childCount
        if (childCount > 1) {
            throw IllegalStateException("XStateController can only host 1 elements")
        } else {

            if (loadingLayoutId != RES_NONE) {
                loadingView = View.inflate(context, loadingLayoutId, null)
                addView(loadingView)
            }
            if (contentLayoutId != RES_NONE) {
                contentView = View.inflate(context, contentLayoutId, null)
                addView(contentView)
            }

            if (contentView == null) {
                if (childCount == 1) {
                    contentView = getChildAt(0)
                }
            }
            if (contentView == null) {
                throw IllegalStateException("contentView can not be null")
            }

        }
        mFinishInflate = true

    }


    open fun setDisplayState(newState: Int) {
        val oldState = state

        if (newState != oldState) {
            state = newState
            val exitView = getDisplayView(oldState)
            val enterView = getDisplayView(newState)

            if (oldState != -1) {
                getStateChangeListener()?.onStateChange(oldState, newState, exitView, enterView)
            } else {
                enterView?.visibility = View.VISIBLE
                enterView?.alpha = 1f
            }
        }
    }


    open fun setDisplayState(state: Int, isForce: Boolean) {

    }


    private fun getDisplayView(oldState: Int): View? {

        return when (oldState) {
            STATE_LOADING -> {


                loadingView
            }
            STATE_ERROR -> {
                if (errorView == null && errorLayoutId != RES_NONE) {
                    errorView = ViewStub.inflate(context, errorLayoutId, null)
                    addView(errorView)
                }

                errorView
            }
            STATE_EMPTY -> {
                if (emptyView == null && emptyLayoutId != RES_NONE) {
                    emptyView = ViewStub.inflate(context, emptyLayoutId, null)
                    addView(emptyView)
                }

                emptyView
            }
            STATE_CONTENT -> {
                contentView
            }

            else -> {
                contentView
            }
        }
    }

    fun showContent() {
        setDisplayState(STATE_CONTENT)
    }

    open fun showEmpty() {
        setDisplayState(STATE_EMPTY)
    }

    open fun showError() {
        setDisplayState(STATE_ERROR)
    }

    open fun showLoading() {
        setDisplayState(STATE_LOADING)
    }

    fun loadingView(loadingView: View): XStateController {
        if (this.loadingView != null) {
            removeView(this.loadingView)
        }
        this.loadingView = loadingView
        addView(this.loadingView)
        this.loadingView!!.visibility = View.GONE
        return this
    }

    fun errorView(errorView: View): XStateController {
        if (this.errorView != null) {
            removeView(this.errorView)
        }
        this.errorView = errorView
        addView(this.errorView)
        this.errorView!!.visibility = View.GONE
        return this
    }

    fun emptyView(emptyView: View): XStateController {
        if (this.emptyView != null) {
            removeView(this.emptyView)
        }
        this.emptyView = emptyView
        addView(this.emptyView)
        this.emptyView!!.visibility = View.GONE
        return this
    }

    fun contentView(contentView: View): XStateController {
        if (this.contentView != null) {
            removeView(this.contentView)
        }
        this.contentView = contentView
        addView(this.contentView)
        this.contentView!!.visibility = View.GONE
        return this
    }

    override fun onSaveInstanceState(): Parcelable? {
        val parcelable = super.onSaveInstanceState()
        val savedState = SavedState(parcelable)
        savedState.state = this.state
        return savedState
    }

    override fun onRestoreInstanceState(state: Parcelable) {
        val savedState = state as SavedState
        super.onRestoreInstanceState(savedState.superState)
        this.state = savedState.state
        setDisplayState(this.state)
    }


    internal class SavedState : View.BaseSavedState {
        var state: Int = 0

        constructor(superState: Parcelable) : super(superState) {}

        constructor(source: Parcel) : super(source) {
            try {
                state = source.readInt()
            } catch (e: IllegalArgumentException) {
                state = STATE_LOADING
            }

        }

        override fun writeToParcel(out: Parcel, flags: Int) {
            super.writeToParcel(out, flags)
            out.writeInt(state)
        }

        override fun describeContents(): Int {
            return 0
        }


        companion object {

            @JvmField
            var CREATOR: Parcelable.Creator<SavedState> = object : Parcelable.Creator<SavedState> {
                override fun createFromParcel(`in`: Parcel): SavedState {
                    return SavedState(`in`)
                }

                override fun newArray(size: Int): Array<SavedState?> {
                    return arrayOfNulls(size)
                }
            }
        }
    }


    fun registerStateChangeListener(stateChangeListener: OnStateChangeListener) {
        this.stateChangeListener = stateChangeListener
    }

    fun getStateChangeListener(): OnStateChangeListener? {
        if (stateChangeListener == null) {
            stateChangeListener = SimpleStateChangeListener()
        }
        return stateChangeListener
    }


    interface OnStateChangeListener {
        fun onStateChange(oldState: Int, newState: Int, exitView: View?, enterView: View?)
    }

    class SimpleStateChangeListener : OnStateChangeListener {

        override fun onStateChange(oldState: Int, newState: Int, exitView: View?, enterView: View?) {

            if (enterView != null) {
                enterView.visibility = View.VISIBLE
            }

            //如果新的状态是空，那么就显示空布局，不隐藏内容布局
            if (exitView != null) {

                if (!(oldState == STATE_CONTENT && newState == STATE_EMPTY)) {
                    exitView.visibility = View.GONE
                }
//                    checkView(enterView)
            }


//            val set = AnimatorSet()
//            val enter = ObjectAnimator.ofFloat(enterView, View.ALPHA, 1f)
//            val exit = ObjectAnimator.ofFloat(exitView, View.ALPHA, 0f)
//            set.playTogether(enter, exit)
//            set.duration = 0
//            set.addListener(object : Animator.AnimatorListener {
//                override fun onAnimationStart(animation: Animator) {
//
//
//                }
//
//                override fun onAnimationEnd(animation: Animator) {
//
//                }
//
//                override fun onAnimationCancel(animation: Animator) {}
//
//                override fun onAnimationRepeat(animation: Animator) {}
//            })
//            set.start()
        }

        private fun checkView(enterView: View) {
            var visibleChild = 0
            val parent = enterView.parent as FrameLayout
            val childCount = parent.childCount
            for (index in 0 until childCount) {
                if (parent.getChildAt(index).visibility == View.VISIBLE) {
                    visibleChild++
                }
            }
            if (visibleChild < 1) {
                enterView.visibility = View.VISIBLE
                enterView.alpha = 1f
            }
        }
    }

    companion object {

        val STATE_LOADING = 0x1
        val STATE_ERROR = 0x2
        val STATE_EMPTY = 0x3
        val STATE_CONTENT = 0x4

        internal val RES_NONE = -1
    }
}
