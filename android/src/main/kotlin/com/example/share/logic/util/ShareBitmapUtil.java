package com.example.share.logic.util;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.os.Build;
import android.util.Log;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

public class ShareBitmapUtil {
    /**
     * 缩放图片的宽高
     * 也可以达到压缩的目的，
     * 和修改inSampleSize的方式有异曲同工之妙
     *
     * @param bitmap
     * @param sx
     * @param sy
     * @return
     */
    public static Bitmap CompressBitmapForScale(Bitmap bitmap, float sx, float sy) {
        Matrix matrix = new Matrix();
        matrix.setScale(sx, sy);
        Bitmap newBmp = Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(), matrix, true);
        return newBmp;
    }

    /**
     * 压缩成指定宽高
     * 其实和CompressBitmapForScale原理是一样的
     * 也是改变宽高，只不过这里我们只需要传入原来的bitmap
     * 内部自动帮我们算好了缩放比例而已
     *
     * @param bitmap
     * @param width
     * @param height
     * @return
     */
    public static Bitmap CompressBitmapForWH(Bitmap bitmap, int width, int height) {
        return Bitmap.createScaledBitmap(bitmap, width, height, true);
    }

    /**
     * 通过修改inSampleSize采样率达到压缩目的
     * 2代表宽高都除于2，这样图片就变成原来的四分之一
     *
     * @param sourceBitmap
     * @return
     */
    public static Bitmap CompressBitmapForSampleSize(String sourceBitmap) {
        BitmapFactory.Options bitmapFactoryOptions = new BitmapFactory.Options();
        bitmapFactoryOptions.inJustDecodeBounds = true;
        bitmapFactoryOptions.inSampleSize = 2;
        // 这里一定要将其设置回false，因为之前我们将其设置成了true
        // 设置inJustDecodeBounds为true后，decodeFile并不分配空间，即，BitmapFactory解码出来的Bitmap为Null,但可计算出原始图片的长度和宽度
        bitmapFactoryOptions.inJustDecodeBounds = false;
        Bitmap bmp = BitmapFactory.decodeFile(sourceBitmap, bitmapFactoryOptions);
        return bmp;
    }

    /**
     * 忽略透明度达到压缩目的
     * 经过测试，压缩后大小为原来的二分之一
     *
     * @param sourceBitmap
     * @return
     */
    public static Bitmap CompressBitmapForRGB(String sourceBitmap) {
        BitmapFactory.Options opt = new BitmapFactory.Options();
        opt.inPreferredConfig = Bitmap.Config.RGB_565;
        opt.inPurgeable = true;
        opt.inInputShareable = true;
        //获取资源图片
        return BitmapFactory.decodeFile(sourceBitmap, opt);
    }

    public static int getBitmapSize(Bitmap bitmap){
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT){		//API 19
            return bitmap.getAllocationByteCount();
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB_MR1){//API 12
            return bitmap.getByteCount();
        }
        return bitmap.getRowBytes() * bitmap.getHeight();				//earlier version
    }

    /**
     * 压缩的是只是存储大小，而不是图片在内存的大小
     * 具体看：https://www.cnblogs.com/shoneworn/p/6932638.html
     * quality:压缩为原来的百分之多少，这里就是10%
     *
     * @param bitmap
     * @return
     */
    public static Bitmap compressBitmapForQuality(Bitmap bitmap) {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        //质量压缩方法，这里100表示不压缩，把压缩后的数据存放到baos中
        bitmap.compress(Bitmap.CompressFormat.JPEG, 50, baos);
        //把压缩后的数据baos存放到ByteArrayInputStream中
        ByteArrayInputStream isBm = new ByteArrayInputStream(baos.toByteArray());
        //把ByteArrayInputStream数据生成图片
        Bitmap newBitmap = BitmapFactory.decodeStream(isBm, null, null);
        return newBitmap;
    }


    /**
     * 根据url转为bitmap
     */
    public static Bitmap getBitmap(String url) {
        URL imageURL = null;
        Bitmap bitmap = null;
        try {
            imageURL = new URL(url);
        } catch (MalformedURLException e) {
            e.printStackTrace();
        }
        try {
            HttpURLConnection conn = (HttpURLConnection) imageURL
                    .openConnection();
            conn.setDoInput(true);
            conn.connect();
            InputStream is = conn.getInputStream();
            bitmap = BitmapFactory.decodeStream(is);
            is.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return bitmap;
    }

    /**
     * 高级图片质量压缩
     *
     * @param bitmap  位图
     * @param maxSize 压缩后的大小，单位kb
     */
    public static Bitmap imageZoom(Bitmap bitmap, double maxSize) {
        // 将bitmap放至数组中，意在获得bitmap的大小（与实际读取的原文件要大）
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        // 格式、质量、输出流
        bitmap.compress(Bitmap.CompressFormat.PNG, 70, baos);
        byte[] b = baos.toByteArray();
        // 将字节换成KB
        double mid = b.length / 1024;
        // 获取bitmap大小 是允许最大大小的多少倍
        double i = mid / maxSize;
        // 判断bitmap占用空间是否大于允许最大空间 如果大于则压缩 小于则不压缩
        doRecycledIfNot(bitmap);
        if (i > 1) {
            // 缩放图片 此处用到平方根 将宽带和高度压缩掉对应的平方根倍
            // （保持宽高不变，缩放后也达到了最大占用空间的大小）
            return scaleWithWH(bitmap, bitmap.getWidth() / Math.sqrt(i),
                    bitmap.getHeight() / Math.sqrt(i));
        }
        return null;
    }

    /***
     * 图片缩放
     *@param bitmap 位图
     * @param w 新的宽度
     * @param h 新的高度
     * @return Bitmap
     */
    public static Bitmap scaleWithWH(Bitmap bitmap, double w, double h) {
        if (w == 0 || h == 0 || bitmap == null) {
            return bitmap;
        } else {
            int width = bitmap.getWidth();
            int height = bitmap.getHeight();

            Matrix matrix = new Matrix();
            float scaleWidth = (float) (w / width);
            float scaleHeight = (float) (h / height);

            matrix.postScale(scaleWidth, scaleHeight);
            return Bitmap.createBitmap(bitmap, 0, 0, width, height,
                    matrix, true);
        }
    }

    /**
     * 回收一个未被回收的Bitmap
     *
     * @param bitmap
     */
    public static void doRecycledIfNot(Bitmap bitmap) {
        if (!bitmap.isRecycled()) {
            bitmap.recycle();
        }
    }

    /**
     * 70      * 把Bitmap转Byte
     */
    public static byte[] bmpToByteArray(Bitmap bitmap,int maxkb) {
        ByteArrayOutputStream output = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, output);
        int options = 100;
        while (output.toByteArray().length > maxkb * 1024 && options != 10) {
            output.reset(); //清空output
            bitmap.compress(Bitmap.CompressFormat.JPEG, options, output);//这里压缩options%，把压缩后的数据存放到output中
            options -= 10;
        }

        // 传值 byte 大于200*1024就会报错
        if (options == 10 && output.toByteArray().length > 200000) {
            while (output.toByteArray().length > 200000&& options != 1) {
                output.reset(); //清空output
                bitmap.compress(Bitmap.CompressFormat.JPEG, options, output);//这里压缩options%，把压缩后的数据存放到output中
                options -= 1;
            }
        }
        return output.toByteArray();
    }
}
