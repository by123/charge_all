package com.xhd.td.utils.calendar

import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.RectF
import android.util.AttributeSet
import android.view.MotionEvent
import android.view.View
import com.xhd.td.R
import java.util.*

/**
 * Created by cracker on 2017/8/3.
 */

class CalendarView : View {
    private var beam: CustomBeam? = null
    private var itemHeight: Float = 0F
    private var itemSelectedColor: Int = 0
    private var itemSelectedTextColor: Int = 0
    private val defaultItemSize = 30
    private var itemWidth: Int = 0
    private var listener: CalendarSelectListener? = null
    private var curYear: Int = 0
    private var curMonth: Int = 0
    private var year: Int = 0
    private var month: Int = 0
    private var startI = -1
    private var endI = -1

    internal lateinit var adapter: CalendarRvAdapter

    constructor(context: Context) : super(context)

    constructor(context: Context, attrs: AttributeSet) : super(context, attrs) {
        val ta = context.obtainStyledAttributes(attrs, R.styleable.customGridViewAttrs)
        itemHeight = ta.getDimension(R.styleable.customGridViewAttrs_itemHeight, 154f)
        itemSelectedColor = ta.getColor(R.styleable.customGridViewAttrs_itemSelectedColor, Color.parseColor("#feba48"))
        itemSelectedTextColor = ta.getColor(R.styleable.customGridViewAttrs_itemSelectedTextColor, Color.WHITE)
        ta.recycle()
    }


    override fun onDraw(canvas: Canvas) {
        super.onDraw(canvas)
        itemWidth = width / 7
        val paint = Paint(Paint.ANTI_ALIAS_FLAG or Paint.DITHER_FLAG)
        paint.textSize = defaultItemSize.toFloat()
        startI = -1
        endI = -1
        val itemMetrics = paint.fontMetricsInt
        //绘制点击按钮
        for (i in clickedList.indices) {
            if (year == clickedList[i].year && month == clickedList[i].month) {
                paint.color = itemSelectedColor
                val xPos = clickedList[i].x
                val yPos = clickedList[i].y
                val iValue = (yPos - 1) * 7 + xPos - beam!!.spaceCount
                if (i == 0) {
                    startI = iValue
                } else {
                    endI = iValue
                }
                val rectF = RectF(
                    (xPos * itemWidth - itemWidth).toFloat(),
                    yPos * itemHeight - itemHeight,
                    (xPos * itemWidth).toFloat(),
                    yPos * itemHeight
                )
                canvas.drawRoundRect(rectF, 10f, 10f, paint)
            }
        }

        //绘制月份
        var offsetY = itemHeight.toInt()
        var offsetX = itemWidth / 2 + beam!!.spaceCount * itemWidth
        for (i in 1..beam!!.monthCount) {
            paint.color = itemSelectedTextColor
            if (endI == i) {
                paint.textSize = 30f
                val textWidth = getTextWidth(paint, "结束")
                canvas.drawText(
                    "结束",
                    (offsetX - textWidth / 2).toFloat(),
                    (offsetY - 22 - (-itemMetrics.top + itemMetrics.bottom) / 2).toFloat(),
                    paint
                )
                val textWidth1 = getTextWidth(paint, i.toString() + "")
                canvas.drawText(
                    "" + i,
                    (offsetX - textWidth1 / 2).toFloat(),
                    (offsetY - 22 - (-itemMetrics.top + itemMetrics.bottom) - 36).toFloat(),
                    paint
                )
            } else if (startI == i) {
                paint.textSize = 30f
                val textWidth = getTextWidth(paint, "开始")
                canvas.drawText(
                    "开始",
                    (offsetX - textWidth / 2).toFloat(),
                    (offsetY - 22 - (-itemMetrics.top + itemMetrics.bottom) / 2).toFloat(),
                    paint
                )
                val textWidth1 = getTextWidth(paint, i.toString() + "")
                canvas.drawText(
                    "" + i,
                    (offsetX - textWidth1 / 2).toFloat(),
                    (offsetY - 22 - (-itemMetrics.top + itemMetrics.bottom) - 36).toFloat(),
                    paint
                )
            } else {
                paint.textSize = 42f
                val textWidth = getTextWidth(paint, i.toString() + "")
                if (beam!!.nextCount < i) {
                    paint.color = resources.getColor(R.color.txtv_item_next)
                } else {
                    //                    txtv_item_black
                    paint.color = resources.getColor(R.color.txtv_item_next)
                }
                canvas.drawText(
                    "" + i,
                    (offsetX - textWidth / 2).toFloat(),
                    offsetY - itemHeight / 2 + (-itemMetrics.top + itemMetrics.bottom) / 2,
                    paint
                )
            }
            offsetX += itemWidth
            //换行
            if ((beam!!.spaceCount + i) % 7 == 0) {
                offsetY += itemHeight.toInt()
                offsetX = itemWidth / 2
            }
        }
    }

    override fun onMeasure(widthMeasureSpec: Int, heightMeasureSpec: Int) {
        val width = View.MeasureSpec.getSize(widthMeasureSpec)
        val d = (beam!!.spaceCount + beam!!.monthCount) / 7.0
        val itemCount = Math.ceil(d)
        setMeasuredDimension(width, (itemHeight * itemCount).toInt())
    }

    override fun onTouchEvent(event: MotionEvent): Boolean {
        if (event.action == MotionEvent.ACTION_UP) {
            val x = event.x
            val y = event.y
            if (!isSelectBefore) {
                if (year == curYear && month >= curMonth || year > curYear) {
                    drawBG(x, y)
                }
            } else {
                drawBG(x, y)
            }
        }
        return true
    }

    /**
     * 绘制点击时间
     */
    private fun drawBG(x: Float, y: Float) {
        val xF = x / itemWidth
        val yF = y / itemHeight
        val xPos = Math.ceil(xF.toDouble()).toInt()
        val yPos = Math.ceil(yF.toDouble()).toInt()
        val iValue = (yPos - 1) * 7 + xPos - beam!!.spaceCount
        if (iValue <= 0 || iValue > beam!!.monthCount) {
            return
        }
        if (!isSelectBefore) {
            if (beam!!.nextCount >= iValue) {
                return
            }
        }
        val calendar = Calendar.getInstance()
        calendar.set(year, month, iValue)
        clickedList.add(SelectedDate(year, month, iValue, xPos, yPos, calendar))
        if (clickedList.size > 2) {
            clickedList.clear()
            clickedList.add(SelectedDate(year, month, iValue, xPos, yPos, calendar))
            if (null != listener) {
                val result = arrayOfNulls<String>(1)
                val startDate = clickedList[0]
                result[0] = startDate.year.toString() + "年" + (startDate.month + 1) + "月" + startDate.day + "日"
                listener!!.onSelected(TYPE_START, result)
            }
        } else if (clickedList.size == 2) {
            Collections.sort(clickedList)
            if (null != listener) {
                val result = arrayOfNulls<String>(2)
                val startDate = clickedList[0]
                result[0] = startDate.year.toString() + "年" + (startDate.month + 1) + "月" + startDate.day + "日"
                val endDate = clickedList[1]
                result[1] = endDate.year.toString() + "年" + (endDate.month + 1) + "月" + endDate.day + "日"
                listener!!.onSelected(TYPE_STARTEND, result)
            }
        } else {
            if (null != listener) {
                val result = arrayOfNulls<String>(1)
                val startDate = clickedList[0]
                result[0] = startDate.year.toString() + "年" + (startDate.month + 1) + "月" + startDate.day + "日"
                listener!!.onSelected(TYPE_START, result)
            }
        }
        adapter.notifyDataSetChanged()
    }

    /**
     * 设置选择监听
     *
     * @param listenner 监听回调
     */
    fun setSelectListenner(listenner: CalendarSelectListener) {
        this.listener = listenner
    }

    fun setData(beam: CustomBeam, adapter: CalendarRvAdapter) {
        this.beam = beam
        this.adapter = adapter
        val curYearMonth = beam.curYearMonth?.split(",".toRegex())?.dropLastWhile { it.isEmpty() }?.toTypedArray()
        curYear = Integer.parseInt(curYearMonth?.get(0))
        curMonth = Integer.parseInt(curYearMonth?.get(1))
        val yearMonth = beam.yearMonth?.split(",".toRegex())?.dropLastWhile { it.isEmpty() }?.toTypedArray()
        year = Integer.parseInt(yearMonth?.get(0))
        month = Integer.parseInt(yearMonth?.get(1))
        invalidate()
        forceLayout()
    }

    /**
     * 设置是否能点击之前的日期
     */
    fun setSelectBefore(isSelectBefore: Boolean) {
        CalendarView.isSelectBefore = isSelectBefore
    }

    companion object {
        val TYPE_START = 1 //选择开始日期
        val TYPE_STARTEND = 2//开始结束日期都选择好
        private val clickedList = ArrayList<SelectedDate>()
        private var isSelectBefore = false

        fun getTextWidth(paint: Paint, str: String?): Int {
            var w = 0
            if (str != null && str.length > 0) {
                val len = str.length
                val widths = FloatArray(len)
                paint.getTextWidths(str, widths)
                for (j in 0 until len) {
                    w += Math.ceil(widths[j].toDouble()).toInt()
                }
            }
            return w
        }
    }
}
