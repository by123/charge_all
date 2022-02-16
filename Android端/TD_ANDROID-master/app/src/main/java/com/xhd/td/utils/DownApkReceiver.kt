package com.xhd.td.utils

import android.app.DownloadManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Environment
import androidx.core.content.FileProvider
import cn.xuexuan.mvvm.utils.ToastUtil
import com.xhd.td.BuildConfig

import java.io.File


class DownApkReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == DownloadManager.ACTION_DOWNLOAD_COMPLETE) {
//            val id = intent.getLongExtra(DownloadManager.EXTRA_DOWNLOAD_ID, -1)
//            installApk(context, id)


            val intent = Intent(Intent.ACTION_VIEW)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) { /* Android N 写法*/
                intent.flags = Intent.FLAG_GRANT_READ_URI_PERMISSION
                val contentUri = FileProvider.getUriForFile(context, BuildConfig.APPLICATION_ID + ".fileprovider",
                        File("${context.getExternalFilesDir(Environment.DIRECTORY_DOWNLOADS)}/aaa.apk"))
                intent.setDataAndType(contentUri, "application/vnd.android.package-archive")
            } else { /* Android N之前的老版本写法*/
                intent.setDataAndType(Uri.fromFile(File("${context.getExternalFilesDir(Environment.DIRECTORY_DOWNLOADS)}/aaa.apk")), "application/vnd.android.package-archive")
                intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
//                val id = intent.getLongExtra(DownloadManager.EXTRA_DOWNLOAD_ID, -1)
//                installApk(context, id)
            }
            context.startActivity(intent)


        } else if (intent.action == DownloadManager.ACTION_NOTIFICATION_CLICKED) {
            //处理 如果还未完成下载，用户点击Notification ，跳转到下载中心
            val viewDownloadIntent = Intent(DownloadManager.ACTION_VIEW_DOWNLOADS)
            viewDownloadIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
            context.startActivity(viewDownloadIntent)
        }

    }

    private fun installApk(context: Context, downloadApkId: Long) {
        val dManager = context.getSystemService(Context.DOWNLOAD_SERVICE) as DownloadManager
        val install = Intent(Intent.ACTION_VIEW)
        val downloadFileUri = dManager.getUriForDownloadedFile(downloadApkId)
        if (downloadFileUri != null) {
            install.setDataAndType(downloadFileUri, "application/vnd.android.package-archive")
            install.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(install)
        } else {
            ToastUtil.showLong( context,"download error")
        }
    }
}
