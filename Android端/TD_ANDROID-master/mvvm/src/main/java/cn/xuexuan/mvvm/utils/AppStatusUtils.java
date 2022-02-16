package cn.xuexuan.mvvm.utils;

/**
 * Created by Administrator on 2017/2/6.
 */

public class AppStatusUtils {

    private static final String TAG = AppStatusUtils.class.getSimpleName();

    public static final int STATUS_FORCE_KILLED = -1;//应用放在后台被强杀了
    public static final int STATUS_NORMAL = 2; //APP正常退出//
    public static final String START_LAUNCH_ACTION = "start_launch_action"; //用于传递状态值的键


    /**
     * APP状态初始值为没启动不在前台状态
     */
    private int appStatus = AppStatusUtils.STATUS_FORCE_KILLED;
    private static AppStatusUtils appStatusManager;

    public static AppStatusUtils getInstance() {
        if (appStatusManager == null) {
            appStatusManager = new AppStatusUtils();
        }
        return appStatusManager;
    }

    public int getAppStatus() {
        return appStatus;
    }

    public void setAppStatus(int appStatus) {
        this.appStatus = appStatus;
    }



}
