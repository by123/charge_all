package cn.xuexuan.mvvm.event

/**
 * Created by xuexuan on 2016/12/22.
 */

object BusProvider {

    private var bus: RxBusImpl? = null

    fun getBus(): RxBusImpl? {
        if (bus == null) {
            synchronized(BusProvider::class.java) {
                if (bus == null) {
                    bus = RxBusImpl.get()
                }
            }
        }
        return bus
    }

}
