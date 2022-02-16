package com.xhd.td.model

import cn.xuexuan.mvvm.event.IBus


/**
 * 关于RxBus的对象类
 * Created by Administrator on 2017/2/13.
 */

class EventMessage<T> : IBus.IEvent {

    override var tag: Int = 0
    var eventContent: T? = null

    constructor()

    constructor(eventKey: Int, eventContent: T) {
        this.eventContent = eventContent
        this.tag = eventKey
    }
}
