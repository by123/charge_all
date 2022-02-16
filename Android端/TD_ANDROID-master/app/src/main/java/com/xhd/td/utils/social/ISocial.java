package com.xhd.td.utils.social;


import com.xhd.td.utils.social.callback.SocialLoginCallback;
import com.xhd.td.utils.social.callback.SocialShareCallback;
import com.xhd.td.utils.social.entities.ShareEntity;
import com.xhd.td.utils.social.entities.ThirdInfoEntity;

/**
 * Created by arvinljw on 17/11/24 16:06
 * Function：
 * Desc：
 */
public interface ISocial {
    void login(SocialLoginCallback callback);

    ThirdInfoEntity createThirdInfo();

    void share(SocialShareCallback callback, ShareEntity shareInfo);

    void onDestroy();
}
