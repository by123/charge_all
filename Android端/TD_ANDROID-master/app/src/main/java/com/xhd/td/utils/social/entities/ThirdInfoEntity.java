package com.xhd.td.utils.social.entities;


/**
 * Created by arvinljw on 17/11/24 15:52
 * Function：
 * Desc：常用的第三方信息
 */
public final class ThirdInfoEntity {
    /*微信*/
    public static final String PLATFORM_WX = "WECHAT";
    /*QQ*/
    public static final String PLATFORM_QQ = "QQ";
    /*微博*/
    public static final String PLATFORM_WB = "WEIBO";

    /**
     * 用户统一标识。
     * 针对一个微信开放平台帐号下的应用，同一用户的unionid是唯一的。
     */
    private String unionId;
    /**
     * 用户唯一标识
     */
    private String openId;

    private String nickname;
    private String sex;
    private String avatar;

    /**
     * 平台信息：{@link #PLATFORM_WX}、{@link #PLATFORM_WX}、{@link #PLATFORM_WX}
     */
    private String platform;

    private WXInfoEntity wxInfo;

    private ThirdInfoEntity(String unionId, String openId, String nickname, String sex, String avatar) {
        this.unionId = unionId;
        this.openId = openId;
        this.nickname = nickname;
        this.sex = sex;
        this.avatar = avatar;
    }



    public static ThirdInfoEntity createWxThirdInfo(String unionId, String openId, String nickname, String sex, String avatar, WXInfoEntity wxInfo) {
        ThirdInfoEntity thirdInfoEntity = new ThirdInfoEntity(unionId, openId, nickname, sex, avatar);
        thirdInfoEntity.setPlatform(PLATFORM_WX);
        thirdInfoEntity.setWxInfo(wxInfo);
        return thirdInfoEntity;
    }


    public String getUnionId() {
        return unionId;
    }

    public void setUnionId(String unionId) {
        this.unionId = unionId;
    }

    public String getOpenId() {
        return openId;
    }

    public void setOpenId(String openId) {
        this.openId = openId;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getSex() {
        return sex;
    }

    public void setSex(String sex) {
        this.sex = sex;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public String getPlatform() {
        return platform;
    }

    public void setPlatform(String platform) {
        this.platform = platform;
    }



    public WXInfoEntity getWxInfo() {
        return wxInfo;
    }

    public void setWxInfo(WXInfoEntity wxInfo) {
        this.wxInfo = wxInfo;
    }



    @Override
    public String toString() {
        return "ThirdInfoEntity{" +
                "unionId='" + unionId + '\'' +
                ", openId='" + openId + '\'' +
                ", nickname='" + nickname + '\'' +
                ", sex='" + sex + '\'' +
                ", avatar='" + avatar + '\'' +
                ", platform='" + platform + '\'' +

                ", wxInfo=" + wxInfo +
                '}';
    }
}
