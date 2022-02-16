package cn.xuexuan.mvvm.net

/**
 * Created by xuexuan on 2016/12/24.
 */

class NetError : Exception {
    lateinit  var exception: Throwable
    var type = OtherError

    constructor(exception: Throwable, type: Int) {
        this.exception = exception
        this.type = type
    }

    constructor(detailMessage: String, type: Int) : super(detailMessage) {
        this.type = type
    }

//     override fun getMessage(): String {
//        return if (exception != null) exception.message else super.message
//    }

    companion object {

        val ParseError = 0   //数据解析异常
        val UnknownHostError = 1   //未知的主机地址
        val SocketTimeoutError = 2   //连接超时
        val ConnectErroe = 3   //没有网络


        val AuthError = 4   //用户验证异常
        val NoDataError = 5   //无数据返回异常
        val BusinessError = 6   //业务异常
        val OtherError = 7   //其他异常

        //运行上的错误
        val IndexOutOfBoundsException = 8 //数组访问超界
        val NullPointerException = 9 //空指针异常
        val ArithmeticException = 10 //算术运算错误
        val IllegalAccessException = 13 //没有访问权限
        val StackOverflowError = 14 ///栈溢出
        val EOFException = 15 //文件已结束异常
        val FileNotFoundException = 16 //文件未找到异常
        val NumberFormatException = 17 //数字转换错误



    }
}
