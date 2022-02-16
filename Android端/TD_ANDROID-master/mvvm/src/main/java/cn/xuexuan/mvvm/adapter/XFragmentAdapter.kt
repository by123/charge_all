package cn.xuexuan.mvvm.adapter


import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.FragmentPagerAdapter
import java.util.*

/**
 * Created by xuexuan on 2016/12/10.
 */

class XFragmentAdapter(fm: FragmentManager, fragmentList: List<Fragment>, private val titles: Array<String>?) :
    FragmentPagerAdapter(fm) {

    override fun getCount(): Int {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
        return fragmentList.size
    }

    private val fragmentList = ArrayList<Fragment>()



    init {
        this.fragmentList.clear()
        this.fragmentList.addAll(fragmentList)
    }

    override fun getPageTitle(position: Int): CharSequence {
        return if (titles != null && titles.size > position) {
            titles[position]
        } else ""
    }

    override fun getItem(position: Int): Fragment {
        return fragmentList[position]
    }
}
