package com.example.share.logic.wechat;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Build;
import android.util.Log;

import com.example.share.logic.util.ShareBitmapUtil;
import com.tencent.mm.opensdk.modelmsg.SendMessageToWX;
import com.tencent.mm.opensdk.modelmsg.WXImageObject;
import com.tencent.mm.opensdk.modelmsg.WXMediaMessage;
import com.tencent.mm.opensdk.modelmsg.WXMusicObject;
import com.tencent.mm.opensdk.modelmsg.WXTextObject;
import com.tencent.mm.opensdk.modelmsg.WXVideoObject;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

import java.io.ByteArrayOutputStream;

public class WechatShareTool {
    public static WechatShareTool instance;

    public static WechatShareTool getInstance(Context context) {
        if (instance == null) {
            instance = new WechatShareTool(context);
        }
        return instance;
    }

    public static String WX_APP_ID      = "your key";//WX_APP_ID自行修改为你的appkey
    private       IWXAPI api;
    private       int    toFriend       = SendMessageToWX.Req.WXSceneSession;//会话
    private       int    toFriendCircle = SendMessageToWX.Req.WXSceneTimeline;//朋友圈
    //SendMessageToWX.Req.WXSceneFavorite //分享到收藏

    public WechatShareTool(Context context) {

    }

    public WechatShareTool register(Context context, String appId) {
        if (appId != null) {
            WX_APP_ID = appId;
        }
        api = WXAPIFactory.createWXAPI(context, WX_APP_ID, false);
        // 将应用的appId注册到微信
        api.registerApp(WX_APP_ID);
        return this;

    }

    public IWXAPI getApi() {
        return api;
    }

    /*
     * 是否安装了微信
     */
    public boolean isWXAppInstalled() {
        return api.isWXAppInstalled();
    }

    /**
     * 微信文字分享
     *
     * @param text
     * @param isNotToFriend 是否分享到朋友圈
     */
    public void shareText(String text, boolean isNotToFriend) {
        //初始化一个 WXTextObject 对象，填写分享的文本内容
        WXTextObject textObj = new WXTextObject();
        textObj.text = text;

        //用 WXTextObject 对象初始化一个 WXMediaMessage 对象
        WXMediaMessage msg = new WXMediaMessage();
        msg.mediaObject = textObj;
        msg.description = text;

        shareToWX("text", msg, isNotToFriend);
    }

    /*
     * 保证字符串唯一
     */
    private String buildTransaction(final String type) {
        return (type == null) ? String.valueOf(System.currentTimeMillis()) : type + System.currentTimeMillis();
    }

    /**
     * 分享本地图片图片
     */
    public void shareImage(String picturePath, String providerPath,boolean isNotToFriend) {
        Bitmap bmp =ShareBitmapUtil.compressBitmapForQuality(BitmapFactory.decodeFile(picturePath)) ;
        Log.e("alex","得到的bitmap大小是:"+ShareBitmapUtil.getBitmapSize(bmp));
        //初始化 WXImageObject 和 WXMediaMessage 对象
        WXImageObject imgObj = new WXImageObject();
        imgObj.imagePath=providerPath;
        WXMediaMessage msg = new WXMediaMessage();
        msg.mediaObject = imgObj;

        //设置缩略图
        Bitmap thumbBmp = Bitmap.createScaledBitmap(bmp, 720, 1080, true);
        Log.e("alex","thumbBmp  :"+ShareBitmapUtil.getBitmapSize(thumbBmp));

        bmp.recycle();
        msg.thumbData = ShareBitmapUtil.bmpToByteArray(thumbBmp,32);
        shareToWX("img", msg, isNotToFriend);
    }




    /**
     * 分享音乐
     *
     * @param title
     * @param description
     * @param musicUrl
     */
    public void shareMusic(String title, String description, String musicUrl, String picturePath, boolean isNotToFriend) {
        //初始化一个WXMusicObject，填写url
        WXMusicObject music = new WXMusicObject();
        music.musicUrl = musicUrl;

        Bitmap bmp = BitmapFactory.decodeFile(picturePath);
        WXMediaMessage msg = getWXMediaMessage(title, description, music, bmp);

        shareToWX("music", msg, isNotToFriend);
    }

    /**
     * 分享视频
     *
     * @param title
     * @param description
     * @param viedoUrl
     */
    public void shareVideo(String title, String description, String viedoUrl, String picturePath, boolean isNotToFriend) {
        //初始化一个WXVideoObject，填写url
        WXVideoObject video = new WXVideoObject();
        video.videoUrl = viedoUrl;

        Bitmap bmp = BitmapFactory.decodeFile(picturePath);
        WXMediaMessage msg = getWXMediaMessage(title, description, video, bmp);

        shareToWX("video", msg, isNotToFriend);
    }

    /*
     * 设置mediaMessage和图片缩略图
     */
    private WXMediaMessage getWXMediaMessage(String title, String description, WXMediaMessage.IMediaObject media, Bitmap bmp) {
        WXMediaMessage msg = new WXMediaMessage();
        msg.mediaObject = media;
        msg.title = title;
        msg.description = description;

        //设置缩略图
        Bitmap thumbBmp = Bitmap.createScaledBitmap(bmp, 100, 100, true);
        bmp.recycle();
        msg.thumbData = bmpToByteArray(thumbBmp, true);//方法在最后面
        return msg;
    }

    /*
     * 分享
     */
    private void shareToWX(String type, WXMediaMessage msg, boolean isNotToFriend) {
        //构造一个Req
        SendMessageToWX.Req req = new SendMessageToWX.Req();
        req.transaction = buildTransaction(type);
        req.message = msg;
        if (isNotToFriend)
            req.scene = toFriendCircle;
        else
            req.scene = toFriend;
        req.userOpenId = WX_APP_ID;

        Log.e("alex"," req.userOpenId   :"+ req.userOpenId);
        //调用api接口，发送数据到微信
       boolean result= api.sendReq(req);
        Log.e("alex"," req.shareToWX    result=== :"+ result);
    }

    /*
     * 图片转换
     */
    private byte[] bmpToByteArray(final Bitmap bmp, final boolean needRecycle) {
        ByteArrayOutputStream output = new ByteArrayOutputStream();
        bmp.compress(Bitmap.CompressFormat.PNG, 100, output);
        if (needRecycle) {
            bmp.recycle();
        }

        byte[] result = output.toByteArray();
        try {
            output.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }


}
