package com.xhd.td.adapter.order

import android.view.View
import android.view.ViewGroup

class OrderPagerAdapter(itemList: ArrayList<View>,val titles:Array<String>) : androidx.viewpager.widget.PagerAdapter() {
    override fun isViewFromObject(p0: View, p1: Any): Boolean {
        return p0 == p1
    }

    private val mItemList: ArrayList<View> = arrayListOf()

    init {
        mItemList.clear()
        mItemList.addAll(itemList)
    }

    override fun destroyItem(container: ViewGroup, position: Int, `object`: Any) {
        container.removeView(mItemList[position])
    }

    override fun instantiateItem(container: ViewGroup, position: Int): Any {
        container.addView(mItemList[position])
        return mItemList[position]
    }

    override fun getCount(): Int {
        return mItemList.size
    }

    override fun getPageTitle(position: Int): CharSequence? {
        return titles[position]

    }

    override fun destroyItem(container: View, position: Int, `object`: Any) {
        //如果注释这行，那么不管怎么切换，page都不会被销毁
//        super.destroyItem(container, position, `object`)
    }

}