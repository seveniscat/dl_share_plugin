package com.example.share.logic.wechat;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;

import androidx.core.content.FileProvider;

import com.android.dingtalk.share.ddsharemodule.DDShareApiFactory;
import com.example.share.AppShare;
import com.example.share.logic.Constants;
import com.example.share.logic.ShareCallBackUtil;
import com.example.share.logic.ShareLogic;
import com.example.share.logic.ShareUtil;

import java.io.File;

public class WechatShareLogic implements ShareLogic {

    private static WechatShareTool             mWechatShareTool;
    private        AppShare.ShareEnumContainer mEnumContainer;
    private        AppShare.ShareBody          mShareBody;

    private AppShare.ShareFlutterApi mShareFlutterApi;

    private Context mContext;


    public WechatShareLogic(Context context, AppShare.ShareFlutterApi shareFlutterApi, AppShare.ShareEnumContainer enumContainer, AppShare.ShareBody shareBody) {
        this.mContext = context;
        mWechatShareTool = WechatShareTool.getInstance(context);
        ShareCallBackUtil.init(shareFlutterApi, enumContainer);
        this.mContext = context;
        mShareFlutterApi = shareFlutterApi;
        this.mEnumContainer = enumContainer;
        this.mShareBody = shareBody;


    }

    @Override
    public void webPageShare() {
        mWechatShareTool.shareText("这是测试！！！",false);

    }

    @Override
    public void onlineImageShare() {
        if (mShareBody.getMLocalPath() == null)
            return;
        mWechatShareTool.shareImage(mShareBody.getMLocalPath(), null,false);
    }

    @Override
    public void sendByteImage() {
        if (mShareBody.getMLocalPath() == null)
            return;
        mWechatShareTool.shareImage(mShareBody.getMLocalPath(),null, false);
    }

    @Override
    public void localImageShare() {
        if (mShareBody.getMLocalPath() == null)
            return;
        File file = new File(mShareBody.getMLocalPath());
        Log.e("alex",">>>>>这个文件是否存在  "+file.exists());

        String providerUrl= ShareUtil.getFileUri(mContext,file,ShareUtil.WX_PACKAGENAME);
        mWechatShareTool.shareImage(mShareBody.getMLocalPath(),providerUrl, false);

    }

    public String getFileUri(Context context, File file) {
        if (file == null || !file.exists()) {
            return null;
        }

        Uri contentUri = FileProvider.getUriForFile(context,
                "com.yimei.information.fileprovider",  // 要与`AndroidManifest.xml`里配置的`authorities`一致，假设你的应用包名为com.example.app
                file);

        // 授权给微信访问路径
        context.grantUriPermission("com.tencent.mm",  // 这里填微信包名
                contentUri, Intent.FLAG_GRANT_READ_URI_PERMISSION);

        return contentUri.toString();   // contentUri.toString() 即是以"content://"开头的用于共享的路径
    }

    @Override
    public void startShare() {
        assert mShareBody.getShareType() != null;

        if (mShareBody.getShareType() == Constants
                .ShareType_IMG_LOCAL) {
            localImageShare();
        } else if (mShareBody.getShareType() == Constants
                .ShareType_URL) {
            localImageShare();
        }
    }

    @Override
    public boolean isInstall() {
        boolean isInstalled = mWechatShareTool.isWXAppInstalled();
        Log.e("alex",">>>>>>>.微信安装：  "+isInstalled);
  /*      mShareFlutterApi.isAppInstallCallBack(isInstalled, reply -> {

        });*/
        return  isInstalled;


    }

}
