package cn.xuexuan.mvvm.log

import cn.xuexuan.mvvm.utils.JsonUtil
import com.elvishew.xlog.formatter.message.`object`.ObjectFormatter
import com.elvishew.xlog.internal.SystemCompat
import okhttp3.MediaType
import okhttp3.Request
import okhttp3.Response
import okio.Buffer
import java.io.IOException

/**
 * create by xuexuan
 * time 2019/3/27 11:09
 */

class HTTPBorderFormatter<T> : ObjectFormatter<T> {

    private val VERTICAL_BORDER_CHAR = "║"

    // Length: 100.
    private val TOP_HORIZONTAL_BORDER =
        "╔═════════════════════════════════════════════════" + "══════════════════════════════════════════════════"

    // Length: 99.
    private val DIVIDER_HORIZONTAL_BORDER =
        "╟─────────────────────────────────────────────────" + "──────────────────────────────────────────────────"

    // Length: 100.
    private val BOTTOM_HORIZONTAL_BORDER =
        "╚═════════════════════════════════════════════════" + "══════════════════════════════════════════════════"


    override fun format(data: T): String {

        var segments = arrayListOf<String>()

        when (data) {
            is Request -> {
                segments.add("TYPE:Request")
                val url = data.url().toString()
                val headers = data.headers()
                val method = data.method()
                segments.add("url:$url")
                segments.add("method:$method")

                if (headers != null && headers.size() > 0) {
                    segments.add("headers:$headers")
                }
                val requestBody = data.body()
                if (requestBody != null) {
                    val mediaType = requestBody.contentType()
                    if (mediaType != null) {
                        if (isText(mediaType)) {
                            segments.add("params:" + JsonUtil.format(bodyToString(data)))
                        } else {
                            segments.add("params: maybe [file part] , too large too print , ignored!")
                        }
                    }
                }
            }
            is Response -> {
                segments.add("TYPE:Response")

                val url = data.request().url().toString()
                segments.add("url:$url")

                val status = data.code()
                segments.add("status:$status")

                val body = data.body()

                if (body != null) {
                    val contentType = body.contentType()
                    if (isText(contentType)) {

//                        //注意下面不能直接body.string()来获取数据，否则会出现异常 java.lang.IllegalStateException: closed，详见string()源码
//                        val source = body.source()
//                        var buffer:Buffer = Buffer()
//                        //下面这条语句会造成source里的数据被读取后，没有数据
                          //之前直接获取source里的buffer，如果数据过大，会获取不全，所以改为下面，但是还是不行
//                        buffer.writeAll(source)
//
//                        val charset = Util.bomAwareCharset(source, if (contentType != null) contentType.charset(UTF_8) else UTF_8)
//                        //注意这里需要buffer clone 对新的buffer进行操作，否则会报错java.io.EOFException: End of input at line 1 column 1 path
////                        var bufferClone = buffer.readString(charset)
//                        val resp = JsonUtil.format(buffer.readString(charset).toString())

                        //这里直接使用string，是因为这是创新创建的一个Response
                        val resp = JsonUtil.format(body.string())

                        segments.add("data:$resp")
                    } else {
                        segments.add("data : " + " maybe [file part] , too large too print , ignored!")
                    }

                }

            }
        }

        if (segments == null || segments.size == 0) {
            return ""
        }

        val nonNullSegments = arrayOfNulls<String>(segments.size)
        var nonNullCount = 0
        for (segment in segments) {
            if (segment != null) {
                nonNullSegments[nonNullCount++] = segment
            }
        }
        if (nonNullCount == 0) {
            return ""
        }

        val msgBuilder = StringBuilder()
        msgBuilder.append("  " + SystemCompat.lineSeparator).append(TOP_HORIZONTAL_BORDER)
            .append(SystemCompat.lineSeparator)
        for (i in 0 until nonNullCount) {
            msgBuilder.append(appendVerticalBorder(nonNullSegments[i]!!))
            if (i != nonNullCount - 1) {
                msgBuilder.append(SystemCompat.lineSeparator).append(DIVIDER_HORIZONTAL_BORDER)
                    .append(SystemCompat.lineSeparator)
            } else {
                msgBuilder.append(SystemCompat.lineSeparator).append(BOTTOM_HORIZONTAL_BORDER)
                //        msgBuilder.append(BOTTOM_HORIZONTAL_BORDER);
            }
        }
        return msgBuilder.toString()
    }

    /**
     * Add {@value #VERTICAL_BORDER_CHAR} to each line of msg.
     *
     * @param msg the message to add border
     * @return the message with {@value #VERTICAL_BORDER_CHAR} in the start of each line
     */
    private fun appendVerticalBorder(msg: String): String {
        val borderedMsgBuilder = StringBuilder(msg.length + 10)
        val lines = msg.split(SystemCompat.lineSeparator.toRegex()).dropLastWhile { it.isEmpty() }.toTypedArray()
        var i = 0
        val N = lines.size
        while (i < N) {
            if (i != 0) {
                borderedMsgBuilder.append(SystemCompat.lineSeparator)
            }
            val line = lines[i]
            borderedMsgBuilder.append(VERTICAL_BORDER_CHAR).append(line)
            i++
        }
        return borderedMsgBuilder.toString()
    }

    private fun isText(mediaType: MediaType?): Boolean {
        return if (mediaType == null) false else "text" == mediaType.subtype()
                || "json" == mediaType.subtype()
                || "xml" == mediaType.subtype()
                || "html" == mediaType.subtype()
                || "webviewhtml" == mediaType.subtype()
                || "plain" == mediaType.subtype()
                || "x-www-form-urlencoded" == mediaType.subtype()

    }

    private fun bodyToString(request: Request): String {
        try {
            val copy = request.newBuilder().build()
            val buffer = Buffer()
            copy.body()!!.writeTo(buffer)
            return buffer.readUtf8()
        } catch (e: IOException) {
            return "something error when show requestBody."
        }

    }

}