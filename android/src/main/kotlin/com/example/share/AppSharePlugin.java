package com.example.share;

import android.app.Application;
import android.content.Context;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.android.dingtalk.share.ddsharemodule.DDShareApiV2;
import com.example.share.logic.Constants;
import com.example.share.logic.ShareLogic;
import com.example.share.logic.ShareUtil;
import com.example.share.logic.dingding.DdShareLogic;
import com.example.share.logic.wechat.WechatShareLogic;
import com.example.share.logic.wechat.WechatShareTool;

import org.jetbrains.annotations.NotNull;

import java.util.Objects;

import io.flutter.Log;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import kotlin.jvm.internal.Intrinsics;

public class AppSharePlugin implements FlutterPlugin, AppShare.ShareHostApi {

    Context                  mContext;
    AppShare.ShareFlutterApi mShareFlutterApi;

   public AppSharePlugin(Context context, AppShare.ShareFlutterApi flutterApi) {
        mContext = context;
        mShareFlutterApi = flutterApi;

    }


    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        mContext = binding.getApplicationContext();
        Log.e("alex", "开始执行  onAttachedToEngine!!1`~~");
        Intrinsics.checkNotNullParameter(binding, "flutterPluginBinding");
        AppShare.ShareHostApi.setup(binding.getBinaryMessenger(), this);

    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        Intrinsics.checkNotNullParameter(binding, "binding");
        AppShare.ShareHostApi.setup(binding.getBinaryMessenger(), null);

    }

    @NonNull
    @Override
    public Boolean registerDD(@NonNull String appId) {

        DdShareLogic.init(mContext,appId);
       return true;
    }

    @NonNull
    @Override
    public Boolean isDingTalkInstalled() {

        ShareLogic shareLogic = new DdShareLogic(mContext,mShareFlutterApi,null,null);
        return  shareLogic.isInstall();
    }

    @NonNull
    @Override
    public Boolean registerWx(@NonNull String appId, @Nullable String universalLink) {
        WechatShareTool.getInstance(mContext).register(mContext,appId);

        Log.e("alex", "注册后得到的APPID:  " +WechatShareTool.WX_APP_ID );
        return true;
    }


    @NonNull
    @Override
    public Boolean startShare(@NonNull AppShare.ShareEnumContainer enumContainer, @NonNull AppShare.ShareBody shareBody) {
        ShareLogic shareLogic = null;
        Log.e("alex", "得到的本地图片是:  " + shareBody.getMLocalPath());
        Long aLong = Objects.requireNonNull(enumContainer.getSharePlatform());
        if (aLong == Constants
                .SharePlatform_QQ) {
        } else if (aLong == Constants
                .SharePlatform_WX) {
            shareLogic=new WechatShareLogic(mContext,mShareFlutterApi,enumContainer,shareBody);
        } else if (aLong == Constants
                .SharePlatform_DD) {
            shareLogic = new DdShareLogic(mContext,mShareFlutterApi,enumContainer,shareBody);
        }
        if (shareLogic != null)
            shareLogic.startShare();

        return false;
    }

    @NonNull
    @Override
    public Boolean isWechatInstalled() {
        ShareLogic shareLogic = new WechatShareLogic(mContext,mShareFlutterApi,null,null);
        shareLogic.isInstall();

        return shareLogic.isInstall();
    }

    @Override
    public void configAndroidPackage(@NonNull String packageName) {
       if(packageName.isEmpty())return;
        ShareUtil.ANDROID_PACKAGE=packageName;

    }


    @Override
    public void isDingTalkSupportOpenAPI(AppShare.Result<Boolean> result) {

    }


}
