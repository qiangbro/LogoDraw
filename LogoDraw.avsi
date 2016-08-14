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
#   LogoDraw 1.3
#
#   在给定的影片上覆盖png格式的logo。
#   支持设置覆盖的锚点坐标、定位方式、开始/结束帧、渐进渐出、透明度、放缩比例 等。
#
#   兼容QiuSJ:JXlogoAdd.avsi的参数。
#
#
#   Author : Mikey
#   E-mail : qiangbro@qq.com
#   所在团队 : 有村花纯字幕组
#   项目网址 : https://github.com/qiangbro/LogoDraw
#


###---CODE EXAMPLES---
#
#
# 一般示例
#   Import("H:\fansub-work\[fansub-dev\LogoDraw\LogoDraw.avsi")
#   DGSource("H:\fansub-work\[任务\2016.05.29 セノビタビ\02-悉尼\src\2016060100350105-フジテレビ-セノビタビ。.dgi")
#   #右下角添加水印
#   LogoDraw("H:\fansub-work\rina_bar\images\rinabar-watermark-v1.1.png", x=0.92, y=0.92, align=5)
#
#
# 水平居中，在垂直的90%位置处覆盖logo
#   LogoDraw("H:\fansub-work\rina_bar\images\rinabar-watermark-v1.1.png", x=0.5, y=0.9, align=5)
#
# 影片开始后延迟60帧显示logo，影片结束前提前60帧隐藏logo
#   LogoDraw("H:\fansub-work\rina_bar\images\rinabar-watermark-v1.1.png", x=1300, y=730, start=60, end_margin=60)
#
# 在1000帧时开始显示logo，显示120帧之后隐藏
#   LogoDraw("H:\fansub-work\rina_bar\images\rinabar-watermark-v1.1.png", x=1300, y=730, start=1000, end=-120)
#
# 渐进渐出40帧，logo透明度60%
#   LogoDraw("H:\fansub-work\rina_bar\images\rinabar-watermark-v1.1.png", x=1300, y=730, fadein=40, fadeout=40, opacity=0.6)
#
# 将logo尺寸缩小到50%
#   LogoDraw("H:\fansub-work\rina_bar\images\rinabar-watermark-v1.1.png", x=1300, y=730, zoom=0.5)
#
# 综合例子：右下角添加一个logo
#   LogoDraw("H:\fansub-work\rina_bar\images\rinabar-watermark-v1.1.png", \
#          x=0.91, y=0.91, align=5, opacity=0.43, start=50, end_margin=50, fadein=20, fadeout=20)
#


###---参数说明---
# 
# src               原影片
#
# overlay           logo文件路径，建议用PNG图片。例如：H:\fansub-work\rina_bar\images\rinabar-watermark-v1.1.png
#
# start             logo的开始帧，0表示一开始就出现。默认0
#
# end,end_margin    end与end_margin用于确定logo的结束帧。
#                   end与end_margin不支持同时使用，最多只能写其中一个。
#
#                   当end为正数、负数、0时，有不同的意义：
#                   end>0：表示logo的结束帧帧号。
#                   end<0：绝对值表示logo持续显示的帧数。
#                   end=0：表示logo一直持续到最后。
#                   （如果你知道Trim的用法的话，你应该理解我为什么要这么设计）
#
#                   end_margin表示logo结束帧距离影片结束相距的帧数。要求end_margin>=0
#                   例如，如果end_margin=0，表示logo一直持续到影片结束。
#
# fadein, fadeout  logo渐进渐出动画帧数
#
# align            logo的锚点定位方式，支持9种，分别是1~9，参考你的小键盘（例如：7表示以logo左上角为锚点）
#
# x, y             锚点坐标，以影片左上角为原点，可以为负值。可以为浮点数，表示百分比。默认使用align表示的位置进行定位
#
# zoom             logo放缩比例，1表示不改变大小，0.0~1.0表示缩小，大于1.0表示放大
#
# dar_fit          改变logo纵横比例，以适应成品影片的显示比例，使logo在成品中按原比例显示。
#                  只拉伸logo宽度以适应，不改变logo高度。若不填dar_fit，则不改变logo纵横比例。
#


###---REQUIREMENTS---
#
#   avisynth 2.58 或更高
#


###---已知问题---
#
# 如果start、end、end_margin值超出了影片长度，则本函数会主动报错，而不是让logo不显示。
#



###---测试---
#
# 通过运行以下avs文件检验是否能够正常工作
#   test\test_logodraw.avs
#
# 已在以下版本的avisynth测试，可以正常工作
#   avisynth 2.58
#   avisynth 2.60
#   avisynth+ 0.1 r1858 MT-pfmod
#
#
# 在多线程环境下，可能需要改一下各个系统滤镜的模式：
# avisynth+ MT pfmod代码：
#~ SetFilterMTMode("ImageSource", 3) 
#~ SetFilterMTMode("Overlay", 3) 
#~ SetFilterMTMode("FadeIn0", 3) 
#~ SetFilterMTMode("FadeOut0", 3) 
#~ SetFilterMTMode("Spline64Resize", 3)
#



###---CHANGELOG---
#
#
#   2016.8.14 v1.3 by Mikey
#       砍掉par_fit，改为dar_fit，使logo在成品中按原比例显示。
#
#   2016.8.13 v1.2 by Mikey
#       支持par_fit，使logo在成品中按原比例显示。
#
#   2016.8.10 v1.1 by Mikey
#       更换锚点定位策略，取消原anchor，改为align，不填x、y时，默认使用align表示的位置进行定位
#
#   2016.7.15 v1.0 by Mikey
#       初版功能实现。
#



function LogoDraw (clip src, string overlay,\
    int "align", val "x", val "y", \
    int "start", int "end", int "end_margin", \
    int "fadein", int "fadeout", float "opacity", \
    float "zoom", float "dar_fit") {
    
    align  = Default(align,              7)

    x       = Default(x,    (align==1 || align==4 || align==7) ? 0 : 
\                           (align==2 || align==5 || align==8) ? src.Width / 2 : 
\                           (align==3 || align==6 || align==9) ? src.Width : Assert(false, "invald align: "+string(align)))

    y       = Default(y,    (align==7 || align==8 || align==9) ? 0 : 
\                           (align==4 || align==5 || align==6) ? src.Height / 2 : 
\                           (align==1 || align==2 || align==3) ? src.Height : Assert(false, "invald align: "+string(align)))

    start   = Default(start,                0)
    fadein  = Default(fadein,               0)
    fadeout = Default(fadeout,              0)
    opacity = Default(opacity,              1.00)
    zoom    = Default(zoom,                 1.00)
    
    Assert(start   >= 0,  "start below 0")
    Assert((Defined(end) && Defined(end_margin))==false,  "暂不支持同时定义end、end_margin")
    Assert((Defined(end_margin)==false) || end_margin >= 0,  "end_margin below 0")
    Assert((Defined(end_margin)==false) || start + end_margin < src.FrameCount(), "start与end_margin之和超出了影片帧数，无法进行logo的覆盖")
    Assert(fadein  >= 0,  "fadein below 0")
    Assert(fadeout >= 0,  "fadeout below 0")
    Assert(zoom    > 0,    "zoom must greater than zero")
    Assert(Defined(overlay), "a png file is required")

    #根据end、end_margin计算last_frame。
    #last_frame 正数表示logo结束帧号，0表示logo持续到最后，负数表示logo持续帧数。
    #（如果你知道Trim的用法的话，你应该理解我为什么要这么设计）
    #如果定义了end，则last_frame直接取end。
    #如果未定义end与end_margin，则last_frame取0。
    #如果未定义end但定义了end_margin，则last_frame取-(src.FrameCount()-start-end_margin)
    last_frame = Default(end, Defined(end_margin) ? -(src.FrameCount()-start-end_margin) : 0)
    
    #将需要添加logo的片段截取出来
    video_source = src.KillAudio()
    target_clip = video_source.Trim(start, last_frame)
    
    #获得logo显示的帧数
    logo_frame_count = target_clip.FrameCount()
    
    #读取logo图像，创建logo_clip。得到的影片应该有logo_frame_count帧。
    logo_clip = ImageSource(overlay, end=logo_frame_count-1, pixel_type="RGB32")
    Assert(logo_clip.FrameCount() == logo_frame_count, "LogoDraw内部错误：logo_clip帧数与给定值不等")
    
    #应用zoom、par_fit
    sar_fit = 1.0 * src.Width / src.Height
    par_fit = Defined(dar_fit) ? (dar_fit / sar_fit) : 1.0
    
    logo_clip = zoom==1.0 && par_fit==1.0 ? logo_clip : \
        logo_clip.Spline64Resize(Round(logo_clip.Width*zoom/par_fit), Round(logo_clip.Height*zoom))
    
    #对mask应用fadein、fadeout
    logo_clip_mask = logo_clip
    logo_clip_mask = fadein>0  ? logo_clip_mask.FadeIn0(fadein)   : logo_clip_mask
    logo_clip_mask = fadeout>0 ? logo_clip_mask.FadeOut0(fadeout) : logo_clip_mask
    
    
    
    #百分比转为像素坐标
    int_x = isInt(x)? x : isFloat(x) ? Round(src.Width  * x) : Assert(false, "invalid x type. only int or float is supported.")
    int_y = isInt(y)? y : isFloat(y) ? Round(src.Height * y) : Assert(false, "invalid y type. only int or float is supported.")
    
    
    #根据锚点换算pos_x pos_y
    
    logo_width = logo_clip.Width
    logo_height = logo_clip.Height
    
    pos_x = (align==1 || align==4 || align==7) ? int_x : 
\           (align==2 || align==5 || align==8) ? int_x - logo_width/2 : 
\           (align==3 || align==6 || align==9) ? int_x - logo_width : Assert(false, "invald align: "+string(align))

    pos_y = (align==7 || align==8 || align==9) ? int_y : 
\           (align==4 || align==5 || align==6) ? int_y - logo_height/2 : 
\           (align==1 || align==2 || align==3) ? int_y - logo_height : Assert(false, "invald align: "+string(align))
    
    
    #向target_clip覆盖logo
    logod_clip = target_clip.Overlay(logo_clip, mask=logo_clip_mask.ShowAlpha(), x=pos_x, y=pos_y, opacity=opacity)
    
    #整合无logo的前后片段
    new_clip = logod_clip
    new_clip = start>0 ? video_source.Trim(0, -start) + new_clip : new_clip
    new_clip = start+logo_frame_count != src.FrameCount() ? new_clip + video_source.Trim(start+logo_frame_count, 0) : new_clip

    #验证叠加logo后全片帧数与叠加前一致
    Assert(new_clip.FrameCount() == src.FrameCount(), "LogoDraw内部错误：添加logo后帧数与原帧数不一致")
    
    new_clip = src.HasAudio() ? new_clip.AudioDub(src.KillVideo()) : new_clip
    
    return new_clip
}

