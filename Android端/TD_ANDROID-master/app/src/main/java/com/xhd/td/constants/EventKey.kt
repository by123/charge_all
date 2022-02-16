package com.xhd.td.constants

/**
 * 关于RxBus的静态标记
 * Created by Administrator on 2017/2/13.
 */

object EventKey {

    //更新设备名
    val UPDATE_USER_NICKNAME_INFO = "update_user_nickname_info"
    val UPDATE_DEVICE_NICKNAME_INFO = "update_device_nickname_info"

    //更新头像
    val UPDATE_USER_HEADER_INFO = "update_user_header_info"
    val UPDATE_DEVICE_HEADER_INFO = "update_device_header_info"


    /**
     * 其他用户登录，需要弹窗提示，退出当前的用户
     */
    val OTHER_USER_LOGIN = 1
    val SELECT_CALENDAR_REQUEST = 2
    val TIME_CHANGE = 3

    val INCOME_TIME_CHANGE = 4
    val INCOME_DETAIL_TIME_CHANGE = 5

    val WHITELIST_SELECT = 6
    val WHITELIST_RECORD = 7
    val WHITELIST_COPY = 8
    val WHITELIST_TIME_LEVEL = 9
    val WHITELIST_EDIT_RANGE = 10
    val WHITELIST_EDIT_TIME_LEVEL = 11
    val WHITELIST_REFRESH = 12


    val TAXI_LIST_REFRESH = 13
    val REFRESH_ORDER_LIST = 14
    val REFRESH_INCOME = 15
    val REFRESH_CARD_LIST = 16


    val WITHDRAW_SELECT_CARD = 17

    //位置：地图选点，发送选中的地址
    val SELECTED_LOCATION = 18

    //有消息或者消息被查看，通知是否显示消息红电
    val MESSAGE_RED_ICON = 19

    //查看消息详情的事件key
    val MESSAGE_DETAIL = 20
}
