package com.datalink.grainapp.wxapi;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.Nullable;

import com.example.share.logic.Constants;
import com.example.share.logic.ShareCallBackUtil;
import com.example.share.logic.util.ShareBitmapUtil;
import com.example.share.logic.wechat.WechatShareTool;
import com.tencent.mm.opensdk.modelbase.BaseReq;
import com.tencent.mm.opensdk.modelbase.BaseResp;
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler;

public class WXEntryActivity extends Activity implements IWXAPIEventHandler {
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        new WechatShareTool(this).register(this, null).getApi().handleIntent(getIntent(), this);
    }

    @Override
    public void onReq(BaseReq baseReq) {
        finish();

    }

    @Override
    public void onResp(BaseResp baseResp) {
        switch (baseResp.errCode) { //根据需要的情况进行处理
            case BaseResp.ErrCode.ERR_OK:
                //正确返回
                //ActivityTool.showToast为Toast的简单封装，开发中自行修改
                ShareCallBackUtil.ddShareCallBack(Constants.Share_SUCCESS);
                break;
            case BaseResp.ErrCode.ERR_USER_CANCEL:
                //用户取消
                //  	ActivityTool.showToast(this, "取消分享");//取消也会返回ERR_OK
                ShareCallBackUtil.ddShareCallBack(Constants.Share_CANCEL);
                break;
            case BaseResp.ErrCode.ERR_COMM:
                //一般错误
                ShareCallBackUtil.ddShareCallBack(Constants.Share_FAIL);
                break;
            default:
                //其他不可名状的情况
                break;
        }
        finish();

    }
}
