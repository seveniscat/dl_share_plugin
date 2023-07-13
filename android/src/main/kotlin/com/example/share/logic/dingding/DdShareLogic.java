package com.example.share.logic.dingding;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;
import android.widget.Toast;

import com.android.dingtalk.share.ddsharemodule.DDShareApiFactory;
import com.android.dingtalk.share.ddsharemodule.IDDShareApi;
import com.android.dingtalk.share.ddsharemodule.message.DDImageMessage;
import com.android.dingtalk.share.ddsharemodule.message.DDMediaMessage;
import com.android.dingtalk.share.ddsharemodule.message.DDWebpageMessage;
import com.android.dingtalk.share.ddsharemodule.message.SendMessageToDD;
import com.example.share.AppShare;
import com.example.share.logic.Constants;
import com.example.share.logic.ShareCallBackUtil;
import com.example.share.logic.ShareLogic;

import java.io.File;

import android.text.TextUtils;

import androidx.core.content.FileProvider;

import com.android.dingtalk.share.ddsharemodule.plugin.SignatureCheck;
import com.example.share.logic.ShareUtil;

public class DdShareLogic implements ShareLogic {
    private static IDDShareApi                 iddShareApi;
    private        AppShare.ShareEnumContainer mEnumContainer;
    private        AppShare.ShareBody          mShareBody;

    private AppShare.ShareFlutterApi mShareFlutterApi;

    private              Context mContext;
    private static final String  ONLINE_PACKAGE_NAME  = "com.datalink.grainapp";//todo:将值替换为在钉钉开放平台上申请时的packageName
    public static  String  ONLINE_APP_ID        = "dingoa9fuhugrtb1fuwfns";//todo:将值替换为在钉钉开放平台上申请时平台生成的appId
    private static final String  ONLINE_SIGNATURE     = "0205e978cc8e13d5cae35e3dabd46305";//todo:将值替换为在钉钉开放平台上申请时的signature
    private static final String  CURRENT_USING_APP_ID = "dingoa9fuhugrtb1fuwfns";//todo:将值替换为你使用的APP_ID

    public static void init(Context context,String dingId) {
        iddShareApi = DDShareApiFactory.createDDShareApi(context, dingId, true);
        ONLINE_APP_ID=dingId;
    }

    public DdShareLogic(Context context, AppShare.ShareFlutterApi shareFlutterApi, AppShare.ShareEnumContainer enumContainer, AppShare.ShareBody shareBody) {
        if (iddShareApi == null)
            iddShareApi = DDShareApiFactory.createDDShareApi(context, "dingoa9fuhugrtb1fuwfns", true);
        ShareCallBackUtil.init(shareFlutterApi, enumContainer);
        this.mContext = context;
        mShareFlutterApi = shareFlutterApi;
        this.mEnumContainer = enumContainer;
        this.mShareBody = shareBody;


    }

    @Override
    public void webPageShare() {
        //初始化一个DDWebpageMessage并填充网页链接地址
        DDWebpageMessage webPageObject = new DDWebpageMessage();
        webPageObject.mUrl = mShareBody.getMUrl();

        //构造一个DDMediaMessage对象
        DDMediaMessage webMessage = new DDMediaMessage();
        webMessage.mMediaObject = webPageObject;

        //填充网页分享必需参数，开发者需按照自己的数据进行填充
        webMessage.mTitle = mShareBody.getMTitle();
        webMessage.mContent = mShareBody.getMContent();
        //        webMessage.mThumbUrl = "https://t.alipayobjects.com/images/rmsweb/T1vs0gXXhlXXXXXXXX.jpg";
        //        webMessage.mThumbUrl = "http://ww2.sinaimg.cn/large/85cccab3gw1etdkm64h7mg20dw07tb29.gif";
        webMessage.mThumbUrl = mShareBody.getMThumbUrl();
        // 网页分享的缩略图也可以使用bitmap形式传输
        //         webMessage.setThumbImage(BitmapFactory.decodeResource(getResources(), R.mipmap.ic_launcher));
        //构造一个Req
        SendMessageToDD.Req webReq = new SendMessageToDD.Req();
        webReq.mMediaMessage = webMessage;

        iddShareApi.sendReqToDing(webReq);

    }

    @Override
    public void onlineImageShare() {
        String picUrl = "https://img-download.pchome.net/download/1k1/ut/5a/ouzdgm-1dzc.jpg";
        //初始化一个DDImageMessage
        DDImageMessage imageObject = new DDImageMessage();
        imageObject.mImageUrl = picUrl;
        //构造一个mMediaObject对象
        DDMediaMessage mediaMessage = new DDMediaMessage();
        mediaMessage.mMediaObject = imageObject;

        //构造一个Req
        SendMessageToDD.Req req = new SendMessageToDD.Req();
        req.mMediaMessage = mediaMessage;
        //        req.transaction = buildTransaction("image");


        iddShareApi.sendReq(req);
    }

    @Override
    public void sendByteImage() {
    }


    @Override
    public void localImageShare() {
        //图片本地路径，开发者需要根据自身数据替换该数据
        //        String path =  Environment.getExternalStorageDirectory().getAbsolutePath() + "/test.png";
        File file = new File(mShareBody.getMLocalPath());
        if (!file.exists()) {
            String tip = "no pic";
            Toast.makeText(mContext, tip + " path = " + mShareBody.getMLocalPath(), Toast.LENGTH_LONG).show();
            return;
        }
        String provider = ShareUtil.getFileUri(mContext, file, ShareUtil.DD_PACKAGENAME);
        //初始化一个DDImageMessage
        DDImageMessage imageObject = new DDImageMessage();
        imageObject.mImageUrl = provider;
        //构造一个mMediaObject对象
        DDMediaMessage mediaMessage = new DDMediaMessage();
        mediaMessage.mMediaObject = imageObject;
        //构造一个Req
        SendMessageToDD.Req req = new SendMessageToDD.Req();
        req.mMediaMessage = mediaMessage;
        //调用api接口发送消息到支付宝
        iddShareApi.sendReq(req);
    }

    @Override
    public void startShare() {
        assert mShareBody.getShareType() != null;
        if (mShareBody.getShareType() == Constants
                .ShareType_IMG_LOCAL) {
            localImageShare();
        } else if (mShareBody.getShareType() == Constants
                .ShareType_IMG_URL) {
            onlineImageShare();
        }
    }


    /**
     * 校验分享到钉钉的参数是否有效
     *
     * @return
     */
    private boolean checkShareToDingDingValid(Context context) {
        if (!TextUtils.equals(ONLINE_PACKAGE_NAME, context.getPackageName())) {
            Toast.makeText(context, "包名与线上申请的不匹配", Toast.LENGTH_SHORT).show();
            return false;
        }
        if (!TextUtils.equals(ONLINE_APP_ID, CURRENT_USING_APP_ID)) {
            Toast.makeText(context, "APP_ID 与生成的不匹配", Toast.LENGTH_SHORT).show();
            return false;
        }
        if (!TextUtils.equals(ONLINE_SIGNATURE, SignatureCheck.getMD5Signature(context, context.getPackageName()))) {
            Toast.makeText(context, "签名与线上生成的不符", Toast.LENGTH_SHORT).show();
            return false;
        }
        return true;
    }

    @Override
    public boolean isInstall() {
        boolean isInstalled = iddShareApi.isDDAppInstalled(mContext);
        Log.e("alex", ">>>>>>>得到的isInstalled  " + isInstalled + "   packageName= " + mContext.getPackageName());
  /*      mShareFlutterApi.isAppInstallCallBack(isInstalled, reply -> {

        });*/
        return isInstalled;

    }


}
