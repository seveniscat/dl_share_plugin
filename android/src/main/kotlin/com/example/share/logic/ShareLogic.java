package com.example.share.logic;

import android.content.Context;

import com.example.share.AppShare;

public interface ShareLogic {

    //网页分享
    void webPageShare();

    //网络图片图片信息
    void onlineImageShare();

    void sendByteImage();


    //本地文件分享
    void localImageShare();

    void  startShare();

    boolean isInstall();



}
