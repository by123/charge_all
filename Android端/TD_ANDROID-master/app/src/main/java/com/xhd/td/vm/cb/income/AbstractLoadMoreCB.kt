package com.xhd.td.vm.cb.income

/**
 * create by xuexuan
 * time 2019/4/3 17:43
 */

interface AbstractLoadMoreCB{


    fun getDataFail(msg: String? = null){}


    /**
     * 这个是用于分页显示的，是否有更多数据
     * currentPage 当前页面
     * totalPage  总页数
     * totalCount 总数量  用于显示界面为空的图标
    */
    fun getDataSuccess(currentPage:Int, totalPage:Int, totalCount:Int){}



    /**
     * 这个是用于把数据显示到界面上
     */
    fun <T> returnDataToView(datas:List<T>)

}