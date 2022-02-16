package com.xhd.td.ui.home

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.media.MediaPlayer
import android.os.Bundle
import android.os.Vibrator
import android.view.View
import androidx.databinding.ObservableInt
import cn.bingoogolapple.qrcode.core.QRCodeView
import com.bigkoo.svprogresshud.SVProgressHUD
import com.elvishew.xlog.XLog
import com.luck.picture.lib.PictureSelector
import com.luck.picture.lib.config.PictureConfig
import com.luck.picture.lib.config.PictureMimeType
import com.xhd.td.BR
import com.xhd.td.R
import com.xhd.td.base.BaseFragment
import com.xhd.td.databinding.FragmentAbstractScanQrBinding
import com.xhd.td.utils.qmui.QMUIStatusBarHelper
import com.xhd.td.vm.ViewModelProviderFactory
import com.xhd.td.vm.cb.home.AbstractScanQrCB
import com.xhd.td.vm.home.AbstractScanQrVM
import kotlinx.android.synthetic.main.fragment_abstract_scan_qr.*
import javax.inject.Inject


/**
 * create by xuexuan
 * 来自薛瑄的自定义模板
 */

abstract class AbstractScanQRFragment<F : AbstractScanQrVM> :
    BaseFragment<FragmentAbstractScanQrBinding, F, AbstractScanQrCB>(),
    AbstractScanQrCB, QRCodeView.Delegate {


    @Inject
    lateinit var factory: ViewModelProviderFactory
    override val bindingViewModel: Int get() = BR.viewModel
    override val bindingFragment: Int get() = BR.fragment
    override val layoutId: Int get() = R.layout.fragment_abstract_scan_qr

    protected val mScanResultList = arrayListOf<String>()
    protected val dialog: SVProgressHUD by lazy { SVProgressHUD(context) }
    override var mHasToolbar = false

    var flashingType = ObservableInt()
    override fun lazyInitView(view: View) {
        super.lazyInitView(view)
        viewModel?.mCallback = this
        zxing_view.setDelegate(this)
        tv_select_pic.setOnClickListener { selectPic() }
    }

    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        mScanResultList.clear()
        flashingType.set(1)
        tv_flashing.setOnClickListener {
            flashingType.set(if (flashingType.get() == 1) {
                2.apply { zxing_view.openFlashlight() }
            } else {
                1.apply { zxing_view.closeFlashlight() }
            })
        }

    }

    override fun onStart() {
        super.onStart()
        zxing_view.startSpotAndShowRect() // 显示扫描框，并且延迟0.5秒后开始识别
        zxing_view.scanBoxView.isOnlyDecodeScanBoxArea = true
    }

    override fun onStop() {
        zxing_view.stopCamera() // 关闭摄像头预览，并且隐藏扫描框
        super.onStop()
    }


    override fun onDestroyView() {
        zxing_view.onDestroy() // 销毁二维码扫描控件
        super.onDestroyView()
    }


    private fun selectPic() {
        // 进入相册 以下是例子：不需要的api可以不写
        PictureSelector.create(this)
            .openGallery(PictureMimeType.ofImage())// 全部.PictureMimeType.ofAll()、图片.ofImage()、视频.ofVideo()、音频.ofAudio()
            .theme(R.style.picture_default_style)// 主题样式设置 具体参考 values/styles   用法：R.style.picture.white.style
            .maxSelectNum(1)// 最大图片选择数量
            .minSelectNum(1)// 最小选择数量
            .imageSpanCount(4)// 每行显示个数
            .selectionMode(PictureConfig.SINGLE)// 多选 or 单选 PictureConfig.SINGLE
            .previewImage(false)// 是否可预览图片
            .previewVideo(false)// 是否可预览视频
            .enablePreviewAudio(false) // 是否可播放音频
            .isCamera(false)// 是否显示拍照按钮
            .isZoomAnim(true)// 图片列表点击 缩放效果 默认true
            //.imageFormat(PictureMimeType.PNG)// 拍照保存图片格式后缀,默认jpeg
            //.setOutputCameraPath("/CustomPath")// 自定义拍照保存路径
            .compress(true)// 是否压缩
            .synOrAsy(true)//同步true或异步false 压缩 默认同步
            //.compressSavePath(getPath())//压缩图片保存地址
            //.sizeMultiplier(0.5f)// glide 加载图片大小 0~1之间 如设置 .glideOverride()无效
            .glideOverride(160, 160)// glide 加载宽高，越小图片列表越流畅，但会影响列表图片浏览的清晰度
            .withAspectRatio(1, 1)// 裁剪比例 如16:9 3:2 3:4 1:1 可自定义
            .hideBottomControls(false)// 是否显示uCrop工具栏，默认不显示
            .isGif(false)// 是否显示gif图片
            .enableCrop(false)// 是否裁剪
            .freeStyleCropEnabled(true)// 裁剪框是否可拖拽
            .circleDimmedLayer(false)// 是否圆形裁剪
            .showCropFrame(false)// 是否显示裁剪矩形边框 圆形裁剪时建议设为false
            .showCropGrid(false)// 是否显示裁剪矩形网格 圆形裁剪时建议设为false
            .openClickSound(false)// 是否开启点击声音
//            .selectionMedia(false)// 是否传入已选图片
            //.isDragFrame(false)// 是否可拖动裁剪框(固定)
            //                        .videoMaxSecond(15)
            //                        .videoMinSecond(10)
            //.previewEggs(false)// 预览图片时 是否增强左右滑动图片体验(图片滑动一半即可看到上一张是否选中)
            //.cropCompressQuality(90)// 裁剪压缩质量 默认100
            .minimumCompressSize(100)// 小于100kb的图片不压缩
            //.cropWH()// 裁剪宽高比，设置如果大于图片本身宽高则无效
            //.rotateEnabled(true) // 裁剪是否可旋转图片
            //.scaleEnabled(true)// 裁剪是否可放大缩小图片
            //.videoQuality()// 视频录制质量 0 or 1
            //.videoSecond()//显示多少秒以内的视频or音频也可适用
            //.recordVideoSecond()//录制视频秒数 默认60s
            .forResult(PictureConfig.CHOOSE_REQUEST)//结果回调onActivityResult code
    }


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (resultCode == Activity.RESULT_OK && data != null) {
            when (requestCode) {
                PictureConfig.CHOOSE_REQUEST -> {
                    // 本来就用到 QRCodeView 时可直接调 QRCodeView 的方法，走通用的回调
                    // 图片选择结果回调
                    var media = PictureSelector.obtainMultipleResult(data)[0]
                    // 例如 LocalMedia 里面返回三种path
                    // 1.media.getPath(); 为原图path
                    // 2.media.getCutPath();为裁剪后path，需判断media.isCut();是否为true
                    // 3.media.getCompressPath();为压缩后path，需判断media.isCompressed();是否为true
                    // 如果裁剪并压缩了，已取压缩路径为准，因为是先裁剪后压缩的

                    zxing_view.decodeQRCode(media.path)
                }
            }

            /*
            没有用到 QRCodeView 时可以调用 QRCodeDecoder 的 syncDecodeQRCode 方法

            这里为了偷懒，就没有处理匿名 AsyncTask 内部类导致 Activity 泄漏的问题
            请开发在使用时自行处理匿名内部类导致Activity内存泄漏的问题，处理方式可参考 https://github
            .com/GeniusVJR/LearningNotes/blob/master/Part1/Android/Android%E5%86%85%E5%AD%98%E6%B3%84%E6%BC%8F%E6%80%BB%E7%BB%93.md
             */
            //            new AsyncTask<Void, Void, String>() {
            //                @Override
            //                protected String doInBackground(Void... params) {
            //                    return QRCodeDecoder.syncDecodeQRCode(picturePath);
            //                }
            //
            //                @Override
            //                protected void onPostExecute(String result) {
            //                    if (TextUtils.isEmpty(result)) {
            //                        Toast.makeText(TestScanActivity.this, "未发现二维码", Toast.LENGTH_SHORT).show();
            //                    } else {
            //                        Toast.makeText(TestScanActivity.this, result, Toast.LENGTH_SHORT).show();
            //                    }
            //                }
            //            }.execute();
        }
    }

    private fun playNoti() {
        MediaPlayer.create(activity, R.raw.scan_ok).apply {
            setOnCompletionListener {
                if (isPlaying) {
                    stop()
                }
                release()
            }
        }.start()
    }

    private fun vibrate() {
        val vibrator = activity?.getSystemService(Context.VIBRATOR_SERVICE) as? Vibrator
        vibrator?.vibrate(200)
    }

    override fun onScanQRCodeSuccess(result: String?) {
        zxing_view.startSpot() // 延迟0.5秒后开始识别
        playNoti()
        vibrate()
        //绑定商户二维码{"unionid":"oj7Jj0XWA9P6wRvLXyEF99snOLIk","openid":"oOH9Z5OQk8lpHKAMINPQg9o275fA","type":"1"}
        //扫描设备二维码的结果 https://www.xhdian.com/interface/qr/?sn=9901300000145753
        XLog.i("result:$result")
        if (result == null) {
            showToast("未检测到二维码")
        } else {
            try {
                scanSuccess(result)
            } catch (e: Exception) {
                showToast("二维码类型错误")
            }
        }

//        val sn = when {
//            result.contains("sn") -> result.split("sn=")[1]
//            result.contains("santaihulian") -> result.substring(result.lastIndexOf("/") + 1, result.length)
//            result.contains("xhdian") -> result.substring(result.lastIndexOf("=") + 1, result.length)
//            result.contains("unionid") -> result
//            else -> {
//                showToast("未检测到炭电二维码")
//                return
//            }
//        }
    }

    abstract fun scanSuccess(result: String)


    override fun onScanQRCodeOpenCameraError() {
        showToast("打开相机出错")
    }


    override fun handleError(throwable: Throwable?) {
        dialog.dismiss()
    }


    override fun onSupportVisible() {
        super.onSupportVisible()
        QMUIStatusBarHelper.setStatusBarDarkMode(_mActivity)

    }

    override fun onSupportInvisible() {
        super.onSupportInvisible()
        QMUIStatusBarHelper.setStatusBarLightMode(_mActivity)
    }
}