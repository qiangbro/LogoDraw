#             DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                     Version 2, December 2004
# 
#  Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>
# 
#  Everyone is permitted to copy and distribute verbatim or modified
#  copies of this license document, and changing it is allowed as long
#  as the name is changed.
# 
#             DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
# 
#   0. You just DO WHAT THE FUCK YOU WANT TO.


#
#   LogoDraw 1.0
#
#   在给定的影片上覆盖指定的logo。
#   支持设置覆盖的锚点坐标、锚点定位方式、开始帧、结束帧、渐进渐出、透明度、放缩比例 等。
#   本函数是对QiuSJ:JXlogoAdd.avsi的代码重构功能增强版本，兼容原版参数。再次感谢原版作者QiuSJ的idea。
#
#   Author : Mikey
#   E-mail : qiangbro@qq.com
#   所在团队 : 有村花纯字幕组
#   项目网址 : https://github.com/qiangbro/LogoDraw
#


###---参数说明---
# 
# src              原影片
#
# overlay          logo文件路径，建议用PNG图片。例如：H:\fansub-work\rina_bar\images\rinabar-watermark-v1.1.png
#
# start            logo的开始帧，0表示一开始就出现。默认0
#
# end              正数：表示logo的结束帧，
#                  负数：表示logo持续的帧数，
#                  0：表示logo一直持续到最后
#
# end_margin       logo结束帧距离片尾相距的帧数，0表示logo一直持续到最后。
#                  如果不方便给出logo的结束帧号则可以指定该值。
#
# (关于end与end_margin的使用)
#                  end不能与end_margin同时使用，最多只支持填一个。
#                  end与end_margin可以都不填，表示logo一直持续到最后。
#
# fadein, fadeout  logo渐进渐出动画帧数
#
# anchor           logo的锚点定位方式，支持9种，分别是1~9，参考你的小键盘（例如：7表示以logo左上角为锚点）
#
# x, y             锚点坐标，以影片左上角为原点，可以为负值。可以为浮点数，表示百分比。
#
# zoom             logo放缩比例，1表示不改变大小，0.0~1.0表示缩小，大于1.0表示放大
#
#


###---CODE EXAMPLES---
#
#
# 一般示例
#   Import("H:\fansub-work\[fansub-dev\LogoDraw\LogoDraw.avsi")
#   DGSource("H:\fansub-work\[任务\2016.05.29 セノビタビ\02-悉尼\src\2016060100350105-フジテレビ-セノビタビ。.dgi")
#   logoDraw("H:\fansub-work\rina_bar\images\rinabar-watermark-v1.1.png")
#
#
# 水平居中在垂直的90%位置处覆盖logo
#   logoDraw("H:\fansub-work\rina_bar\images\rinabar-watermark-v1.1.png", x=0.5, y=0.9, anchor=5)
#
# 影片开始后延迟60帧显示logo，影片结束前提前60帧隐藏logo
#   logoDraw("H:\fansub-work\rina_bar\images\rinabar-watermark-v1.1.png", x=1300, y=730, start=60, end_margin=60)
#
# 在1000帧时开始显示logo，显示120帧之后隐藏
#   logoDraw("H:\fansub-work\rina_bar\images\rinabar-watermark-v1.1.png", x=1300, y=730, start=1000, end=-120)
#
# 渐进渐出40帧，logo透明度60%
#   logoDraw("H:\fansub-work\rina_bar\images\rinabar-watermark-v1.1.png", x=1300, y=730, fadein=40, fadeout=40, opacity=0.6)
#
# 将logo尺寸缩小到50%
#   logoDraw("H:\fansub-work\rina_bar\images\rinabar-watermark-v1.1.png", x=1300, y=730, zoom=0.5)
#
# 综合例子
#   logoDraw("H:\fansub-work\rina_bar\images\rinabar-watermark-v1.1.png", \
#          x=0.91, y=0.91, anchor=5, opacity=0.43, start=50, end_margin=50, fadein=20, fadeout=20)
#

###---已知问题---
#
# 多线程环境可能需要改一下各个系统滤镜的模式：
#~ SetFilterMTMode("ImageSource", 3) 
#~ SetFilterMTMode("Overlay", 3) 
#~ SetFilterMTMode("FadeIn0", 3) 
#~ SetFilterMTMode("FadeOut0", 3) 
#~ SetFilterMTMode("Spline64Resize", 3)
#
# 如果start、end、end_margin值超出了影片长度，则本函数会主动报错，而不是让logo不显示。
#


###---CHANGELOG---
#
#   2016.7.15 v1.0 by Mikey
#       初版功能实现。
#



function LogoDraw (clip src, string overlay,\
    int "anchor", val "x", val "y", \
    int "start", int "end", int "end_margin", \
    int "fadein", int "fadeout", float "opacity", float "zoom") {
    
    
    anchor  = Default(anchor,              7)
    x       = Default(x,                   0)
    y       = Default(y,                   0)
    start   = Default(start,               0)
    fadein  = Default(fadein,              0)
    fadeout = Default(fadeout,             0)
    opacity = Default(opacity,             1.00)
    zoom    = Default(zoom,                1.00)
    
    Assert(start   >= 0,  "start below 0")
    Assert((Defined(end) && Defined(end_margin))==false,  "暂不支持同时定义end、end_padding")
    Assert((Defined(end_margin)==false) || end_margin >= 0,  "end_margin below 0")
    Assert((Defined(end_margin)==false) || start + end_margin < src.FrameCount(), "start与end_margin之和超出了影片帧数，无法进行logo的覆盖")
    Assert(fadein  >= 0,  "fadein below 0")
    Assert(fadeout >= 0,  "fadeout below 0")
    Assert(zoom    > 0,    "zoom must greater than zero")
    Assert(Defined(overlay), "a png file is required")

    #根据end、end_margin计算last_frame
    #如果定义了end，则last_frame取end。如果未定义end或end_margin，last_frame取0。如果未定义end但定义了end_margin，last_frame取src.FrameCount()-1-end_margin
    last_frame = Default(end, Defined(end_margin) ? -(src.FrameCount()-start-end_margin) : 0)
    
    #将需要添加logo的片段截取出来
    video_source = src.KillAudio()
    target_clip = video_source.Trim(start, last_frame)
    
    #获得logo显示的帧数
    logo_frame_count = target_clip.FrameCount()
    
    #读取logo图像，创建logo_clip。得到的影片应该有logo_frame_count帧。
    logo_clip = ImageSource(overlay, end=logo_frame_count-1, pixel_type="RGB32")
    Assert(logo_clip.FrameCount() == logo_frame_count, "LogoDraw内部错误：logo_clip帧数与给定值不等")
    
    #向logo_clip应用zoom
    logo_clip = zoom!=1.0 ? logo_clip.Spline64Resize(Round(logo_clip.Width*zoom/4)*4, Round(logo_clip.Height*zoom/4)*4) : logo_clip
    
    #对mask应用fadein、fadeout
    logo_clip_mask = logo_clip
    logo_clip_mask = fadein>0  ? logo_clip_mask.FadeIn0(fadein)   : logo_clip_mask
    logo_clip_mask = fadeout>0 ? logo_clip_mask.FadeOut0(fadeout) : logo_clip_mask
    
    
    #根据锚点换算pos_x pos_y
    logo_width = logo_clip.Width
    logo_height = logo_clip.Height
    
    int_x = isInt(x)? x : isFloat(x) ? Round(src.Width  * x) : Assert(false, "invalid x type. only int or float is supported.")
    int_y = isInt(y)? y : isFloat(y) ? Round(src.Height * y) : Assert(false, "invalid y type. only int or float is supported.")
    
    pos_x = (anchor==1 || anchor==4 || anchor==7) ? int_x : 
\           (anchor==2 || anchor==5 || anchor==8) ? int_x - logo_width/2 : 
\           (anchor==3 || anchor==6 || anchor==9) ? int_x - logo_width : Assert(false, "invald anchor: "+string(anchor))

    pos_y = (anchor==7 || anchor==8 || anchor==9) ? int_y : 
\           (anchor==4 || anchor==5 || anchor==6) ? int_y - logo_height/2 : 
\           (anchor==1 || anchor==2 || anchor==3) ? int_y - logo_height : Assert(false, "invald anchor: "+string(anchor))
    
    
    #向target_clip覆盖logo
    logod_clip = target_clip.Overlay(logo_clip, mask=logo_clip_mask.ShowAlpha(), x=pos_x, y=pos_y, opacity=opacity)
    
    #整合无logo的前后片段
    new_clip = logod_clip
    new_clip = start>0 ? video_source.Trim(0, -start) + new_clip : new_clip
    new_clip = start+logo_frame_count != src.FrameCount() ? new_clip + video_source.Trim(start+logo_frame_count, 0) : new_clip

    #验证叠加logo后全片帧数与叠加前一致
    Assert(new_clip.FrameCount() == src.FrameCount(), "LogoDraw内部错误：添加logo后帧数与原帧数不一致")
    
    audio_source = src.KillVideo()
    return AudioDub(new_clip, audio_source)
}

