package cn.xuexuan.mvvm.event

/**
 * Created by xuexuan on 2016/12/22.
 */

interface IBus {

    fun register(`object`: Any)
    fun unregister(`object`: Any)
    fun post(event: IEvent)
    fun postSticky(event: IEvent)


    interface IEvent {
        val tag: Int
    }

}
