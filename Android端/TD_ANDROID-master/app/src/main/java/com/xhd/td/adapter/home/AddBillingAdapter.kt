package com.xhd.td.adapter.home

//XLog
import android.content.Context
import android.text.TextWatcher
import android.view.View
import android.widget.AdapterView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import cn.xuexuan.mvvm.adapter.SimpleRecAdapter
import cn.xuexuan.mvvm.utils.ToastUtil
import com.elvishew.xlog.XLog
import com.google.gson.Gson
import com.xhd.td.R
import com.xhd.td.model.bean.GradeBean
import com.xhd.td.model.bean.PriceBean
import com.xhd.td.utils.CashierInputFilter
import kotlinx.android.synthetic.main.item_add_billing_adapter.view.*

/**
 * create by xuexuan
 * 还是来自薛瑄独创的自定义模板
 */
class AddBillingAdapter(context: Context, var mTextWatcher: TextWatcher) :
    SimpleRecAdapter<PriceBean, AddBillingAdapter.ViewHolder>(context) {

    override val layoutId: Int get() = R.layout.item_add_billing_adapter
    //是为了某个viewHolder数据发生变化时，更新其他viewHolder用的
    var mAllViewHolder: MutableList<ViewHolder> = arrayListOf()
    //等级数据
    private var mShowGradeArray: MutableList<String> =
        context.resources.getStringArray(R.array.grade_array).toMutableList()

    override fun newViewHolder(itemView: View): ViewHolder {
        return ViewHolder(itemView)
    }

    //是否是删除元素，需要调用onBindViewHolder更新UI，
    var mIsDelete = false

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {

        holder.bind(data[position], position)

        //XLog.d("$position 的数据是 ${holder.spinnerGrade.text.toString()}")
        //这里的要小心处理，防止加入重复的holder,
        // position小于总元素个数，防止越界。!=0 ，在第一次添加的时候不需要进行移除
        if (mAllViewHolder.size > position && mAllViewHolder.size !=0) {
            mAllViewHolder.removeAt(position)
        }
        mAllViewHolder.add(position, holder)

        if (position == data.size - 1) {
            //全部显示完后，去更新所有已经显示出来的item的可选档位
            changeAlreadyShownItemGrade()
        }

    }


    inner class ViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        var minus = itemView.minus
        var spinnerGrade = itemView.spinner_grade
        var editPrice = itemView.edit_price
        var tvGrade = itemView.tv_grade


        //如果服务器没有PriceBean数据的时候，则在本地构造一个数据，用于默认显示
        fun bind(info: PriceBean, position: Int) {

            tvGrade.text = "第${when (position) {
                0 -> "一"
                1 -> "二"
                2 -> "三"
                3 -> "四"
                else -> "五"
            }}档"
            var thisViewHolder = this
            //这个背景要在这里设置，在xml中设置无效
            spinnerGrade.setBackgroundResource(R.drawable.shape_agent_normal)
            spinnerGrade.text = (info.time.toInt() / 60).toString() + " 小时"
            spinnerGrade.setOnItemSelectedListener(object : AdapterView.OnItemSelectedListener {
                override fun onNothingSelected(parent: AdapterView<*>?) {}

                override fun onItemSelected(parent: AdapterView<*>?, view: View?, p: Int, id: Long) {

                    //更改该holder 在mAllViewHolder中的数据
                    //XLog.d("位置$p 的数据更新为 ${spinnerGrade.text.toString()}")
                    if (view is TextView) {
                        mAllViewHolder[position].spinnerGrade.text = view.text
                    }
                    //注意：这里切换线程，是因为如果直接使用changeAlreadyShownItemGrade()，更新了position位置的spinnerGrade中的数据为A，还是会默认选中新的A中的第p个item
                    //所以这里就切换现场，相当于onItemSelected返回后，再进行每个spinnerGrade中的数据的更新
                    spinnerGrade.postDelayed({
                        changeAlreadyShownItemGrade()
                    }, 500)
                }
            })
            editPrice.setOnFocusChangeListener { _, hasFocus ->
                if (hasFocus) itemView.edit_price.setSelection(itemView.edit_price.text.length)
            }

            var price = (info.price.toFloat() / 100).toString()
            if (price.endsWith(".0")) price = price.split(".0")[0]
            //不能使用editPrice.text = price
            editPrice.setText(price)
            editPrice.addTextChangedListener(mTextWatcher)
            editPrice.filters = Array(1) {  CashierInputFilter() }

            minus.visibility = if (position == 0) View.INVISIBLE else View.VISIBLE
            minus.setOnClickListener {
                mAllViewHolder.removeAt(position)
                data.removeAt(position)
                notifyItemRemoved(position)
                //在上面的移除每一个item后，会点击事件的索引还是未删除之前的索引，需要重新排序下面所有的元素
                notifyItemRangeChanged(position, data.size)
            }

        }
    }


    override fun getItemCount(): Int {
        return if (data.size > 5) 5 else data.size
    }

    fun addCount() {
        addElement(itemCount, PriceBean("0", "0"))

    }

    //每次档位发生改变，都去更新其他的已经显示出来的item的档位选择范围
    //例如，新增档位，更改档位，删除档位
    fun changeAlreadyShownItemGrade() {
        //等级数据
        var showGradeArray: MutableList<String> = context.resources.getStringArray(R.array.grade_array).toMutableList()

        var emptyHolder: ViewHolder? = null
        //从总数中移除所有item的选值
        for (holder in mAllViewHolder) {
            //XLog.d("已选中的数据是 ${holder.spinnerGrade.text.toString()}")

            if (holder.spinnerGrade.text.toString().equals("0 小时")) {
                emptyHolder = holder

            } else {
                //这里需要toString，否则删除不成功
                showGradeArray.remove(holder.spinnerGrade.text.toString())
            }
        }

        if (emptyHolder != null) {
            //显示showGradeArray中的第一项
            var time = showGradeArray.removeAt(0)
            emptyHolder.spinnerGrade?.text = time
            data[itemCount - 1].time = (time.substring(0, time.length - 2).trim().toInt() * 60).toString()
        }

        for (holder in mAllViewHolder) {
            holder.spinnerGrade?.apply {
                attachDataSource(arrayListOf<String>().apply {
                    //XLog.d("添加在第一位的数据是 ${holder.spinnerGrade.text.toString()}")
                    add(holder.spinnerGrade.text.toString())
                    addAll(showGradeArray)
                })
                selectedIndex = 0
            }
        }
    }


    //判断每一个item输入的价格是否合法
    fun checkPrice(minMoney:Int): Boolean {

        for ((index, holder) in mAllViewHolder.withIndex()) {
            holder.editPrice.text.toString().apply {
                if (this.startsWith("."))
                    holder.editPrice?.setText("")
                if (this.isEmpty() || this == "" || this.endsWith("."))
                    return false
            }

            val price  = holder.editPrice.text.toString().toFloat()*100
            data[index].price = price.toString()
            if (price < minMoney){
                ToastUtil.showLong(context,"计费规则金额不得低于${minMoney/100}元")
                return false
            }

        }
        return true
    }


    fun getBillingList(): String {
        val list = ArrayList<GradeBean>(mAllViewHolder.size)
        for (holder in mAllViewHolder) {

            val timeGrade = holder.spinnerGrade?.text?.toString()
            list.add(
                GradeBean(
                    when (mShowGradeArray.indexOf(timeGrade) + 2) {
                        2 -> 60
                        3 -> 60 * 2
                        4 -> 60 * 3
                        5 -> 60 * 4
                        6 -> 60 * 6
                        7 -> 60 * 8
                        8 -> 60 * 12
                        9 -> 60 * 24
                        else -> 0
                    }.toString(),
                    mShowGradeArray.indexOf(timeGrade) + 2,
                    ((holder.editPrice?.text?.toString()?.toFloatOrNull() ?: 0F) * 100)
                )
            )
        }
//
//        for ((index,data) in data.withIndex()){
//            list.add(GradeBean(data.time, index, data.price.toFloat()))
//        }


//        [{"time":"60","scale":2,"price":100},{"time":"180","scale":3,"price":200},{"time":"1440","scale":9,"price":300}]
        var json = Gson().toJson(list).apply { XLog.d(this) }
        return json
    }

    override fun clearData() {
        super.clearData()
        mAllViewHolder.clear()
    }

}

