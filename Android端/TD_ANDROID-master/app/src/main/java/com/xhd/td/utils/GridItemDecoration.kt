package com.xhd.td.utils

import android.content.Context
import android.content.res.Resources
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Rect
import android.graphics.drawable.ColorDrawable
import android.graphics.drawable.Drawable
import android.util.TypedValue
import android.view.View
import androidx.annotation.ColorInt
import androidx.annotation.ColorRes
import androidx.annotation.DimenRes
import androidx.core.content.ContextCompat
import androidx.recyclerview.widget.GridLayoutManager
import androidx.recyclerview.widget.RecyclerView
import androidx.recyclerview.widget.StaggeredGridLayoutManager


/**
 * create by xuexuan
 * time 2019/4/13 15:36
 */

class GridItemDecoration private constructor(
    private val mHorizonSpan: Int,
    private val mVerticalSpan: Int,
    color: Int,
    private val mShowLastLine: Boolean
) : RecyclerView.ItemDecoration() {

    private val mDivider: Drawable

    init {
        mDivider = ColorDrawable(color)
    }

    override fun onDrawOver(c: Canvas, parent: RecyclerView, state: RecyclerView.State) {
        drawHorizontal(c, parent)
        drawVertical(c, parent)
    }

    private fun drawHorizontal(c: Canvas, parent: RecyclerView) {
        val childCount = parent.childCount

        for (i in 0 until childCount) {
            val child = parent.getChildAt(i)

            //最后一行底部横线不绘制
            if (isLastRaw(parent, i, getSpanCount(parent), childCount) && !mShowLastLine) {
                continue
            }
            val params = child.layoutParams as RecyclerView.LayoutParams
            val left = child.left - params.leftMargin
            val right = child.right + params.rightMargin
            val top = child.bottom + params.bottomMargin
            val bottom = top + mHorizonSpan

            mDivider.setBounds(left, top, right, bottom)
            mDivider.draw(c)
        }
    }

    private fun drawVertical(c: Canvas, parent: RecyclerView) {
        val childCount = parent.childCount
        for (i in 0 until childCount) {
            val child = parent.getChildAt(i)
            if ((parent.getChildViewHolder(child).adapterPosition + 1) % getSpanCount(parent) == 0) {
                continue
            }
            val params = child.layoutParams as RecyclerView.LayoutParams
            val top = child.top - params.topMargin
            val bottom = child.bottom + params.bottomMargin + mHorizonSpan
            val left = child.right + params.rightMargin
            var right = left + mVerticalSpan
            //            //满足条件( 最后一行 && 不绘制 ) 将vertical多出的一部分去掉;
//            if (i == childCount - 1) {
//                right -= mVerticalSpan
//            }
            mDivider.setBounds(left, top, right, bottom)
            mDivider.draw(c)
        }
    }

    /**
     * 计算偏移量
     */
    override fun getItemOffsets(outRect: Rect, view: View, parent: RecyclerView, state: RecyclerView.State) {
        val spanCount = getSpanCount(parent)
        val childCount = parent.adapter!!.itemCount
        val itemPosition = (view.getLayoutParams() as RecyclerView.LayoutParams).viewLayoutPosition

        if (itemPosition < 0) {
            return
        }

        val column = itemPosition % spanCount
        val bottom: Int

        val left = column * mVerticalSpan / spanCount
        val right = mVerticalSpan - (column + 1) * mVerticalSpan / spanCount

        if (isLastRaw(parent, itemPosition, spanCount, childCount)) {
            if (mShowLastLine) {
                bottom = mHorizonSpan
            } else {
                bottom = 0
            }
        } else {
            bottom = mHorizonSpan
        }
        outRect.set(left, 0, right, bottom)
    }

    /**
     * 获取列数
     */
    private fun getSpanCount(parent: RecyclerView): Int {
        // 列数
        var mSpanCount = -1
        val layoutManager = parent.layoutManager
        if (layoutManager is GridLayoutManager) {
            mSpanCount = layoutManager.spanCount
        } else if (layoutManager is StaggeredGridLayoutManager) {
            mSpanCount = layoutManager.spanCount
        }
        return mSpanCount
    }

    /**
     * 是否最后一行
     * @param parent     RecyclerView
     * @param pos        当前item的位置
     * @param spanCount  每行显示的item个数
     * @param childCount child个数
     */
    private fun isLastRaw(parent: RecyclerView, pos: Int, spanCount: Int, childCount: Int): Boolean {
        val layoutManager = parent.layoutManager

        if (layoutManager is GridLayoutManager) {
            return getResult(pos, spanCount, childCount)
        } else if (layoutManager is StaggeredGridLayoutManager) {
            val orientation = layoutManager.orientation
            if (orientation == StaggeredGridLayoutManager.VERTICAL) {
                // StaggeredGridLayoutManager 且纵向滚动
                return getResult(pos, spanCount, childCount)
            } else {
                // StaggeredGridLayoutManager 且横向滚动
                if ((pos + 1) % spanCount == 0) {
                    return true
                }
            }
        }
        return false
    }

    private fun getResult(pos: Int, spanCount: Int, childCount: Int): Boolean {
        val remainCount = childCount % spanCount//获取余数
        //如果正好最后一行完整;
        if (remainCount == 0) {
            if (pos >= childCount - spanCount) {
                return true //最后一行全部不绘制;
            }
        } else {
            if (pos >= childCount - childCount % spanCount) {
                return true
            }
        }
        return false
    }

    /**
     * 使用Builder构造
     */
    class Builder(private val mContext: Context) {
        private val mResources: Resources
        private var mShowLastLine: Boolean = false
        private var mHorizonSpan: Int = 0
        private var mVerticalSpan: Int = 0
        private var mColor: Int = 0

        init {
            mResources = mContext.getResources()
            mShowLastLine = true
            mHorizonSpan = 0
            mVerticalSpan = 0
            mColor = Color.WHITE
        }

        /**
         * 通过资源文件设置分隔线颜色
         */
        fun setColorResource(@ColorRes resource: Int): Builder {
            setColor(ContextCompat.getColor(mContext, resource))
            return this
        }

        /**
         * 设置颜色
         */
        fun setColor(@ColorInt color: Int): Builder {
            mColor = color
            return this
        }

        /**
         * 通过dp设置垂直间距
         */
        fun setVerticalSpan(@DimenRes vertical: Int): Builder {
            this.mVerticalSpan = mResources.getDimensionPixelSize(vertical)
            return this
        }

        /**
         * 通过px设置垂直间距
         */
        fun setVerticalSpan(mVertical: Float): Builder {
            this.mVerticalSpan =
                TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_PX, mVertical, mResources.getDisplayMetrics()).toInt()
            return this
        }

        /**
         * 通过dp设置水平间距
         */
        fun setHorizontalSpan(@DimenRes horizontal: Int): Builder {
            this.mHorizonSpan = mResources.getDimensionPixelSize(horizontal)
            return this
        }

        /**
         * 通过px设置水平间距
         */
        fun setHorizontalSpan(horizontal: Float): Builder {
            this.mHorizonSpan =
                TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_PX, horizontal, mResources.getDisplayMetrics())
                    .toInt()
            return this
        }

        /**
         * 是否最后一条显示分割线
         */
        fun setShowLastLine(show: Boolean): GridItemDecoration.Builder {
            mShowLastLine = show
            return this
        }

        fun build(): GridItemDecoration {
            return GridItemDecoration(mHorizonSpan, mVerticalSpan, mColor, mShowLastLine)
        }
    }
}