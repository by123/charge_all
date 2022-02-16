package com.xhd.td.adapter.home

import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.FragmentPagerAdapter
import androidx.viewpager.widget.PagerAdapter
import me.yokeyword.fragmentation.SupportFragment


/**
 * Created by Jant on 2017/1/7.
 */


class FragmentTitleAdapter(fm: FragmentManager, private val fragments: Array<SupportFragment>,val titles:Array<String>) : FragmentPagerAdapter(fm) {


    override fun getItem(position: Int): Fragment {
        return fragments[position]
    }

    override fun getCount(): Int {
        return fragments.size
    }

    override fun getItemPosition(`object`: Any): Int {
        return PagerAdapter.POSITION_NONE
    }

    override fun getPageTitle(position: Int): CharSequence? {
        return titles[position]

    }
    override fun destroyItem(container: ViewGroup, position: Int, `object`: Any) {
        //如果注释这行，那么不管怎么切换，page都不会被销毁
        //super.destroyItem(container, position, object);
    }
}


