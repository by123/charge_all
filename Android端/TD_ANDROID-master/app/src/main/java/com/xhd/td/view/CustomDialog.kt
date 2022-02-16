package com.xhd.td.view

import android.app.Dialog
import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.Window
import android.widget.Button
import android.widget.TextView
import com.xhd.td.R


/**
 * Created by Administrator on 2017/2/21.
 */

class CustomDialog : Dialog, View.OnClickListener {
    private var rightBntText: String? = null  //右边按钮文本
    private var leftBntText: String? = null   //左边按钮文本
    private var titleText: String? = null     //标题文本
    private var contentText: String? = null   //内容文本

    private var mTvTitle: TextView? = null   //标题
    var mTvContent: TextView? = null   //内容
    private var mBtnCancel: Button? = null   //取消
    private var mBtnConfirm: Button? = null   //确定

    var back: ClickBack? = null        //点击事件回调
    private val ctx: Context
    private val isDelete = false  //是否是删除设备  默认不是

    constructor(context: Context) : super(context, R.style.alert_dialog) {
        this.ctx = context
    }

    constructor(context: Context, type: Int) : super(context, R.style.alert_dialog) {
        this.ctx = context
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val inflater = LayoutInflater.from(ctx)
        val view: View

        view = inflater.inflate(R.layout.dialog_custom, null)

        mBtnCancel = view.findViewById<View>(R.id.btn_left) as Button
        mBtnCancel!!.text = "取消"
        mBtnConfirm = view.findViewById<View>(R.id.btn_right) as Button
        mBtnConfirm!!.text = "确定"

        requestWindowFeature(Window.FEATURE_NO_TITLE)
        setContentView(view)
        init(view)
    }

    private fun init(v: View) {
        mTvTitle = v.findViewById<View>(R.id.tv_title) as TextView
        mTvContent = v.findViewById<View>(R.id.tv_content) as TextView
        mBtnCancel = v.findViewById<View>(R.id.btn_left) as Button
        mBtnConfirm = v.findViewById<View>(R.id.btn_right) as Button

        mBtnCancel!!.setOnClickListener(this)
        mBtnConfirm!!.setOnClickListener(this)
        mTvContent!!.text = contentText
        mTvTitle?.text = titleText

        val dialogWindow = window
        val lp = dialogWindow!!.attributes
        // 获取屏幕宽、高用
        val d = ctx.resources.displayMetrics
        // 宽度设置为屏幕的0.8
        lp.width = (d.widthPixels * 0.9).toInt()
        //  lp.height = (int) (d.heightPixels * 0.4);
        lp.height = ViewGroup.LayoutParams.WRAP_CONTENT
        dialogWindow.attributes = lp
    }

    /**
     * @param left  左边按钮文字
     * 如果只要一个按钮则填其中一个参数为null
     * @param right 右边按钮文字
     */
    fun setBtnText(left: String, right: String) {
        rightBntText = right
        leftBntText = left

    }

    fun setVisibleTitle(b: Boolean) {
        if (b) {
            mTvTitle!!.visibility = View.VISIBLE
        } else {
            mTvTitle!!.visibility = View.GONE
        }
    }

    /**
     * @param title 设置标题文本，如果不需要则设置为null则自动隐藏标题
     */
    fun setTitleText(title: String) {
        titleText = title
    }

    fun setContentText(content: String) {
        this.contentText = content
    }

    override fun onClick(v: View) {
        if (v.id == R.id.btn_right) {
            if (back != null) {
                dismiss()
                back!!.determine()
            }
        } else if (v.id == R.id.btn_left){
            if (back != null) {
                dismiss()
                //back.cancel();
            }
        }
    }

    interface ClickBack {
        //        void cancel();

        fun determine()
    }
}
