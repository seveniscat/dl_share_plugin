package com.example.share.logic;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;

import androidx.core.content.FileProvider;

import java.io.File;

public class ShareUtil {
    public static String DD_PACKAGENAME = "com.alibaba.android.rimet";
    public static String WX_PACKAGENAME = "com.tencent.mm";

    public  static  String ANDROID_PACKAGE="com.yimei.information";


    public static String getFileUri(Context context, File file, String urlPackageName) {
        if (file == null || !file.exists()) {
            return null;
        }
        Uri contentUri = FileProvider.getUriForFile(context,
                ANDROID_PACKAGE+".fileprovider",  // 要与`AndroidManifest.xml`里配置的`authorities`一致，假设你的应用包名为com.example.app
                file);
        // 授权给钉钉访问路径
        context.grantUriPermission(urlPackageName,  // 这里填微信包名
                contentUri, Intent.FLAG_GRANT_READ_URI_PERMISSION);
        return contentUri.toString();   // contentUri.toString() 即是以"content://"开头的用于共享的路径
    }
}
