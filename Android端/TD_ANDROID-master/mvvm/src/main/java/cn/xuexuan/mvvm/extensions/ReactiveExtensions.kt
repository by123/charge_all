package cn.xuexuan.mvvm.extensions



import cn.xuexuan.mvvm.net.SchedulerProvider
import io.reactivex.Completable
import io.reactivex.Flowable
import io.reactivex.Observable
import io.reactivex.Single
import io.reactivex.disposables.CompositeDisposable
import io.reactivex.disposables.Disposable

/**
 * Extension function to subscribe on the background thread and observe on the main thread for a [Completable]
 * */
fun Completable.performOnBackOutOnMain(schedulerProvider: SchedulerProvider): Completable {
    return this.subscribeOn(schedulerProvider.io())
        .observeOn(schedulerProvider.ui())
}

/**
 * Extension function to subscribe on the background thread and observe on the main thread for a [Flowable]
 * */
fun <T> Flowable<T>.performOnBackOutOnMain(schedulerProvider: SchedulerProvider): Flowable<T> {
    return this.subscribeOn(schedulerProvider.io())
        .observeOn(schedulerProvider.ui())
}

/**
 * Extension function to subscribe on the background thread and observe on the main thread  for a [Single]
 * */
fun <T> Single<T>.performOnBackOutOnMain(schedulerProvider: SchedulerProvider): Single<T> {
    return this.subscribeOn(schedulerProvider.io())
        .observeOn(schedulerProvider.ui())
}

/**
 * Extension function to subscribe on the background thread and observe on the main thread for a [Observable]
 * */
fun <T> Observable<T>.performOnBackOutOnMain(schedulerProvider: SchedulerProvider): Observable<T> {
    return this.subscribeOn(schedulerProvider.io())
        .observeOn(schedulerProvider.ui())
}

/**
 * Extension function to add a Disposable to a CompositeDisposable
 */
fun Disposable.addTo(compositeDisposable: CompositeDisposable) {
    compositeDisposable.add(this)
}

/**
 * Extension function to subscribe on the background thread for a Flowable
 * */
fun <T> Flowable<T>.performOnBack(schedulerProvider: SchedulerProvider): Flowable<T> {
    return this.subscribeOn(schedulerProvider.io())
}

/**
 * Extension function to subscribe on the background thread for a Completable
 * */
fun Completable.performOnBack(schedulerProvider: SchedulerProvider): Completable {
    return this.subscribeOn(schedulerProvider.io())
}

/**
 * Extension function to subscribe on the background thread for a Observable
 * */
fun <T> Observable<T>.performOnBack(schedulerProvider: SchedulerProvider): Observable<T> {
    return this.subscribeOn(schedulerProvider.io())
}