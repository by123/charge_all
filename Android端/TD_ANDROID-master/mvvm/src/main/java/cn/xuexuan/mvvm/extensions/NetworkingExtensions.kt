package cn.xuexuan.mvvm.extensions


import cn.xuexuan.mvvm.utils.synk.Synk
import io.reactivex.Single

/**
 * Extension function to update [Synk] about a remote call's status
 **/
fun <T> Single<T>.updateSynkStatus(key: String): Single<T> {
    return this.doOnSuccess { Synk.syncSuccess(key = key) }
        .doOnError { Synk.syncFailure(key = key) }
}