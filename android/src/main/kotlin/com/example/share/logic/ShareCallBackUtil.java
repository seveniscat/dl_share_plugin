package com.example.share.logic;

import com.example.share.AppShare;

public class ShareCallBackUtil {

    static  AppShare.ShareFlutterApi mShareFlutterApi;
    static  AppShare.ShareEnumContainer mShareEnumContainer;
    public  static void   init(AppShare.ShareFlutterApi shareFlutterApi,AppShare.ShareEnumContainer enumContainer){
        mShareFlutterApi=shareFlutterApi;
        mShareEnumContainer=enumContainer;
    }

    public   static void ddShareCallBack(long status){
        if(mShareEnumContainer==null);
        assert mShareEnumContainer != null;
        mShareEnumContainer.setShareStatus( status);
        if(mShareFlutterApi!=null)mShareFlutterApi.shareCallBack(mShareEnumContainer, "", reply -> {
        });

    }
    public  static  void clear(){
        mShareFlutterApi=null;
        mShareEnumContainer=null;
    }


}
