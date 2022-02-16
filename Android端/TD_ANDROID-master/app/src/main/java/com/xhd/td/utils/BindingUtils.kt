package com.xhd.td.utils

import android.widget.ImageView
import androidx.databinding.BindingAdapter
import androidx.databinding.InverseMethod
import androidx.recyclerview.widget.RecyclerView
import cn.droidlover.xrecyclerview.XRecyclerView
import com.bumptech.glide.Glide
import com.xhd.td.adapter.home.AddBillingAdapter
import com.xhd.td.adapter.home.PerformanceAdapter
import com.xhd.td.adapter.home.TotalMerchantAdapter
import com.xhd.td.model.bean.DevMchListBean
import com.xhd.td.model.bean.PriceBean


/**
 * Created by amitshekhar on 11/07/17.
 */

//object BindingUtils {

@BindingAdapter("adapter")
fun addBlogItems(recyclerView: RecyclerView, blogs: List<String>?) {
    val adapter = recyclerView.adapter as PerformanceAdapter?
    if (adapter != null) {
        adapter.clearData()
        adapter.addData(blogs)
    }
}


@BindingAdapter("billingAdapter")
fun addBillingItems(recyclerView: RecyclerView, billing: List<PriceBean>?) {
    val adapter = recyclerView.adapter as AddBillingAdapter?
    if (adapter != null) {
        adapter.clearData()
        adapter.addData(billing)
    }
}


@BindingAdapter("merchantTotalAdapter")
fun addMerchantTotalItems(recyclerView: XRecyclerView, totalMerchant: List<DevMchListBean>?) {
    var xAdapter = recyclerView.adapter
    if (xAdapter != null) {
        val adapter = xAdapter.adapter as TotalMerchantAdapter
        if (adapter != null) {
//            adapter.clearData()
            adapter.addData(totalMerchant)
        }
    }
}


@BindingAdapter("imageUrl")
fun setImageUrl(imageView: ImageView, url: String?) {
    val context = imageView.context
    Glide.with(context).load(url).into(imageView)
}
//}// This class is not publicly instantiable


@InverseMethod("toInputObservableDouble")
fun toInputString(num: Double): String {
    return num.toString()
}

fun toInputObservableDouble(n: String): Double {

    var num = n
    if (num.startsWith(".")) {
        num = "0$num"
    }

    return if (!num.isEmpty()) {
        num.toDouble()
    } else {
        0.0
    }

}


//@BindingAdapter("salesman")
//fun setImageUrl(textView: TextView, salesmaneId: String,) {
//    val context = imageView.context
//    Glide.with(context).load(url).into(imageView)
//}