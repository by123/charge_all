package cn.xuexuan.mvvm.log

import cn.xuexuan.mvvm.BuildConfig
import com.elvishew.xlog.LogConfiguration
import com.elvishew.xlog.LogLevel
import com.elvishew.xlog.XLog
import com.elvishew.xlog.interceptor.BlacklistTagsFilterInterceptor
import com.elvishew.xlog.printer.AndroidPrinter
import com.elvishew.xlog.printer.ConsolePrinter
import com.elvishew.xlog.printer.Printer
import com.elvishew.xlog.printer.file.FilePrinter
import com.elvishew.xlog.printer.file.backup.NeverBackupStrategy
import com.elvishew.xlog.printer.file.naming.DateFileNameGenerator
import okhttp3.Request
import okhttp3.Response


/**
 * Created by xuexuan on 2016/11/29.
 */

class XLogBuilder {

    var config = LogConfiguration.Builder()
        .logLevel(
            if (BuildConfig.DEBUG) {
                LogLevel.ALL
            }           // Specify log level, logs below this level won't be printed, default: LogLevel.ALL
            else {
                LogLevel.ALL
            }
        )
        .tag("MY_TAG")                                 // Specify TAG, default: "X-LOG"
//        .t()                                               // Enable thread info, disabled by default
//        .st(30)                                      // Enable stack trace info with depth 2, disabled by default
        .b()                                               // Enable border, disabled by default
        .addObjectFormatter(Request::class.java,HTTPBorderFormatter<Request>())
        .addObjectFormatter(Response::class.java,HTTPBorderFormatter<Response>())
//        .jsonFormatter(MyJsonFormatter())                  // Default: DefaultJsonFormatter
//        .xmlFormatter(MyXmlFormatter())                    // Default: DefaultXmlFormatter
//        .throwableFormatter(MyThrowableFormatter())        // Default: DefaultThrowableFormatter
//        .threadFormatter(MyThreadFormatter())              // Default: DefaultThreadFormatter
//        .stackTraceFormatter(MyStackTraceFormatter())      // Default: DefaultStackTraceFormatter
//        .borderFormatter(MyBoardFormatter())               // Default: DefaultBorderFormatter
//        .addObjectFormatter(
//            AnyClass::class.java, // Add formatter for specific class of object
//            AnyClassObjectFormatter()
//        )                     // Use Object.toString() by default
        .addInterceptor(
            BlacklistTagsFilterInterceptor(    // Add blacklist tags filter
                "blacklist1", "blacklist2", "blacklist3"
            )
        )
//        .addInterceptor(MyInterceptor())                   // Add a log interceptor
        .build()


    var androidPrinter: Printer = AndroidPrinter()             // Printer that print the log using android.util.Log
    var consolePrinter: Printer = ConsolePrinter()             // Printer that print the log to console using System.out
    var filePrinter: Printer = FilePrinter.Builder("/sdcard/xlog/")    // Printer that print the log to the file system
        // Specify the path to save log file
        .fileNameGenerator(DateFileNameGenerator())                // Default: ChangelessFileNameGenerator("log")
        .backupStrategy(NeverBackupStrategy())                      // Default: FileSizeBackupStrategy(1024 * 1024)
//        .cleanStrategy(FileLastModifiedCleanStrategy(MAX_TIME))     // Default: NeverCleanStrategy()
//        .flattener(MyFlattener())                                   // Default: DefaultFlattener
        .build()


    companion object {

        private var instance: XLogBuilder? = null
        fun getInstance(): XLogBuilder {
            if (XLogBuilder.instance == null) {
                synchronized(XLogBuilder::class.java) {
                    if (XLogBuilder.instance == null) {
                        XLogBuilder.instance = XLogBuilder()
                    }
                }
            }
            return XLogBuilder.instance!!
        }


        fun init() {
            XLog.init(                                                 // Initialize XLog
                getInstance().config,                                                // Specify the log configuration, if not specified, will use new LogConfiguration.Builder().build()
                getInstance().androidPrinter)                                      // Specify printers, if no printer is specified, AndroidPrinter(for Android)/ConsolePrinter(for java) will be used.);
        }
    }

}
