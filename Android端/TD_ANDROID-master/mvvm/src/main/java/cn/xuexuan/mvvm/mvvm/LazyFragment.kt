package cn.xuexuan.mvvm.mvvm

import android.app.Activity
import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.fragment.app.Fragment

/**
 * Created by xuexuan on 2017/1/28.
 */

open class LazyFragment : Fragment() {
//    protected var layoutInflater: LayoutInflater? = null
    protected var context: Activity? = null

    protected var rootView: View? = null
        private set
    private var container: ViewGroup? = null

    private var isInitReady = false
    private var isVisibleToUserState = STATE_NO_SET
    private var saveInstanceState: Bundle? = null
    private val isLazyEnable = true
    private var isStart = false
    private var layout: FrameLayout? = null

    protected val realRootView: View?
        get() {
            if (rootView != null) {
                if (rootView is FrameLayout && TAG_ROOT_FRAMELAYOUT == rootView!!.tag) {
                    return (rootView as FrameLayout).getChildAt(0)
                }
            }

            return rootView
        }


    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
//        this.layoutInflater = inflater
        this.container = container
        onCreateView(savedInstanceState)
        return if (rootView == null) super.onCreateView(inflater, container, savedInstanceState) else rootView

    }

    private fun onCreateView(savedInstanceState: Bundle?) {
        this.saveInstanceState = savedInstanceState
        val isVisible: Boolean
        if (isVisibleToUserState == STATE_NO_SET) {
            isVisible = userVisibleHint
        } else {
            isVisible = isVisibleToUserState == STATE_VISIBLE
        }
        if (isLazyEnable) {
            if (isVisible && !isInitReady) {
                onCreateViewLazy(savedInstanceState)
                isInitReady = true
            } else {
                var mInflater = layoutInflater
                if (mInflater == null && context != null) {
                    mInflater = LayoutInflater.from(context)
                }
                layout = FrameLayout(context!!)
                layout!!.tag = TAG_ROOT_FRAMELAYOUT

                val view = getPreviewLayout(mInflater, layout!!)
                if (view != null) {
                    layout!!.addView(view)
                }
                layout!!.layoutParams = FrameLayout.LayoutParams(
                        ViewGroup.LayoutParams.MATCH_PARENT,
                        ViewGroup.LayoutParams.MATCH_PARENT)
                setContentView(layout!!)
            }
        } else {
            onCreateViewLazy(savedInstanceState)
            isInitReady = true
        }
    }

    protected fun `$`(id: Int): View? {
        return if (rootView != null) {
            rootView!!.findViewById(id)
        } else null
    }

    protected fun setContentView(layoutResID: Int) {
        if (isLazyEnable && rootView != null && rootView!!.parent != null) {
            layout!!.removeAllViews()
            val view = layoutInflater!!.inflate(layoutResID, layout, false)
            layout!!.addView(view)
        } else {
            rootView = layoutInflater!!.inflate(layoutResID, container, false)
        }
    }

    protected fun setContentView(view: View) {
        if (isLazyEnable && rootView != null && rootView!!.parent != null) {
            layout!!.removeAllViews()
            layout!!.addView(view)
        } else {
            rootView = view
        }
    }

    override fun setUserVisibleHint(isVisibleToUser: Boolean) {
        super.setUserVisibleHint(isVisibleToUser)
        isVisibleToUserState = if (isVisibleToUser) STATE_VISIBLE else STATE_NO_VISIBLE
        if (isVisibleToUser
                && !isInitReady
                && rootView != null) {
            isInitReady = true
            onCreateViewLazy(saveInstanceState)
            onResumeLazy()
        }
        if (isInitReady && rootView != null) {
            if (isVisibleToUser) {
                isStart = true
                onStartLazy()
            } else {
                isStart = false
                onStopLazy()
            }
        }
    }

    override fun onResume() {
        super.onResume()
        if (isInitReady) {
            onResumeLazy()
        }
    }

    override fun onPause() {
        super.onPause()
        if (isInitReady) {
            onPauseLazy()
        }
    }

    override fun onStart() {
        super.onStart()
        if (isInitReady
                && !isStart
                && userVisibleHint) {
            isStart = true
            onStartLazy()
        }
    }

    override fun onStop() {
        super.onStop()
        if (isInitReady
                && isStart
                && userVisibleHint) {
            isStart = false
            onStopLazy()
        }
    }

    override fun onAttach(context: Context?) {
        super.onAttach(context)
        if (context is Activity) {
            this.context = context
        }
    }


    override fun onDetach() {
        super.onDetach()
        context = null

        try {
            val childFragmentManager = Fragment::class.java.getDeclaredField("mChildFragmentManager")
            childFragmentManager.isAccessible = true
            childFragmentManager.set(this, null)
        } catch (e: NoSuchFieldException) {
            throw RuntimeException(e)
        } catch (e: IllegalAccessException) {
            throw RuntimeException(e)
        }

    }


    override fun onDestroyView() {
        super.onDestroyView()
        rootView = null
        container = null
//        layoutInflater = null
        if (isInitReady) {
            onDestoryLazy()
        }
        isInitReady = false
    }

    protected fun getPreviewLayout(mInflater: LayoutInflater?, layout: FrameLayout): View? {
        return null
    }

    protected open fun onCreateViewLazy(savedInstanceState: Bundle?) {

    }

    protected fun onStartLazy() {

    }

    protected fun onStopLazy() {

    }

    protected fun onResumeLazy() {

    }

    protected fun onPauseLazy() {

    }

    protected open fun onDestoryLazy() {

    }

    companion object {

        private val STATE_VISIBLE = 1 //用户可见
        private val STATE_NO_SET = -1 //未设置值
        private val STATE_NO_VISIBLE = 0  //用户不可见

        private val TAG_ROOT_FRAMELAYOUT = "tag_root_framelayout"
    }


}
