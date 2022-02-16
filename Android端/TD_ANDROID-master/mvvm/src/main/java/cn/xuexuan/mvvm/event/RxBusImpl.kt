package cn.xuexuan.mvvm.event


import io.reactivex.Flowable
import io.reactivex.processors.FlowableProcessor
import io.reactivex.processors.PublishProcessor

/**
 * Created by xuexuan on 2016/12/22.
 */

class RxBusImpl private constructor() : IBus {

    private var bus: FlowableProcessor<Any>? = null

    init {
        bus = PublishProcessor.create<Any>().toSerialized()
    }

    override fun register(`object`: Any) {

    }

    override fun unregister(`object`: Any) {

    }

    override fun post(event: IBus.IEvent) {
        bus!!.onNext(event)
    }

    override fun postSticky(event: IBus.IEvent) {

    }

    fun <T : IBus.IEvent> toFlowable(eventType: Class<T>): Flowable<T> {
        return bus!!.ofType(eventType).onBackpressureBuffer()
    }

    private object Holder {
         val instance = RxBusImpl()
    }

    companion object {

        fun get(): RxBusImpl {
            return Holder.instance
        }
    }
}
