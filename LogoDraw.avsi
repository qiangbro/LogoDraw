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
#   �ڸ�����ӰƬ�ϸ���ָ����logo��
#   ֧�����ø��ǵ�ê�����ꡢê�㶨λ��ʽ����ʼ֡������֡������������͸���ȡ��������� �ȡ�
#   �������Ƕ�QiuSJ:JXlogoAdd.avsi�Ĵ����ع�������ǿ�汾������ԭ�������
#
#   Author : Mikey
#   E-mail : qiangbro@qq.com
#   �����Ŷ� : �д廨����Ļ��
#   ��Ŀ��ַ : https://github.com/qiangbro/LogoDraw
#


###---����˵��---
# 
# src              ԭӰƬ
#
# overlay          logo�ļ�·����������PNGͼƬ�����磺H:\fansub-work\rina_bar\images\rinabar-watermark-v1.1.png
#
# start            logo�Ŀ�ʼ֡��0��ʾһ��ʼ�ͳ��֡�Ĭ��0
#
# end              ��������ʾlogo�Ľ���֡��
#                  ��������ʾlogo������֡����
#                  0����ʾlogoһֱ���������
#
# end_margin       logo����֡����Ƭβ����֡����0��ʾlogoһֱ���������
#                  ������������logo�Ľ���֡�������ָ����ֵ��
#
# (����end��end_margin��ʹ��)
#                  end������end_marginͬʱʹ�ã����ֻ֧����һ����
#                  end��end_margin���Զ������ʾlogoһֱ���������
#
# fadein, fadeout  logo������������֡��
#
# anchor           logo��ê�㶨λ��ʽ��֧��9�֣��ֱ���1~9���ο����С���̣����磺7��ʾ��logo���Ͻ�Ϊê�㣩
#
# x, y             ê�����꣬��ӰƬ���Ͻ�Ϊԭ�㣬����Ϊ��ֵ������Ϊ����������ʾ�ٷֱȡ�
#
# zoom             logo����������1��ʾ���ı��С��0.0~1.0��ʾ��С������1.0��ʾ�Ŵ�
#
#


###---CODE EXAMPLES---
#
#
# һ��ʾ��
#   Import("H:\fansub-work\[fansub-dev\LogoDraw\LogoDraw.avsi")
#   DGSource("H:\fansub-work\[����\2016.05.29 ���Υӥ���\02-Ϥ��\src\2016060100350105-�ե��ƥ��-���Υӥ��ӡ�.dgi")
#   logoDraw("H:\fansub-work\rina_bar\images\rinabar-watermark-v1.1.png")
#
#
# ˮƽ�����ڴ�ֱ��90%λ�ô�����logo
#   logoDraw("H:\fansub-work\rina_bar\images\rinabar-watermark-v1.1.png", x=0.5, y=0.9, anchor=5)
#
# ӰƬ��ʼ���ӳ�60֡��ʾlogo��ӰƬ����ǰ��ǰ60֡����logo
#   logoDraw("H:\fansub-work\rina_bar\images\rinabar-watermark-v1.1.png", x=1300, y=730, start=60, end_margin=60)
#
# ��1000֡ʱ��ʼ��ʾlogo����ʾ120֮֡������
#   logoDraw("H:\fansub-work\rina_bar\images\rinabar-watermark-v1.1.png", x=1300, y=730, start=1000, end=-120)
#
# ��������40֡��logo͸����60%
#   logoDraw("H:\fansub-work\rina_bar\images\rinabar-watermark-v1.1.png", x=1300, y=730, fadein=40, fadeout=40, opacity=0.6)
#
# ��logo�ߴ���С��50%
#   logoDraw("H:\fansub-work\rina_bar\images\rinabar-watermark-v1.1.png", x=1300, y=730, zoom=0.5)
#
# �ۺ�����
#   logoDraw("H:\fansub-work\rina_bar\images\rinabar-watermark-v1.1.png", \
#          x=0.91, y=0.91, anchor=5, opacity=0.43, start=50, end_margin=50, fadein=20, fadeout=20)
#

###---��֪����---
#
# ���̻߳���������Ҫ��һ�¸���ϵͳ�˾���ģʽ��
#~ SetFilterMTMode("ImageSource", 3) 
#~ SetFilterMTMode("Overlay", 3) 
#~ SetFilterMTMode("FadeIn0", 3) 
#~ SetFilterMTMode("FadeOut0", 3) 
#~ SetFilterMTMode("Spline64Resize", 3)
#
# ���start��end��end_marginֵ������ӰƬ���ȣ��򱾺�����������������������logo����ʾ��
#


###---CHANGELOG---
#
#   2016.7.15 v1.0 by Mikey
#       ���湦��ʵ�֡�
#



function LogoDraw(clip src, string overlay, int "anchor", val "x", val "y", int "start", int "end", int "end_margin", int "fadein", int "fadeout", float "opacity", float "zoom")
{
    anchor  = Default(anchor,              7)
    x       = Default(x,                   0)
    y       = Default(y,                   0)
    start   = Default(start,               0)
    fadein  = Default(fadein,              0)
    fadeout = Default(fadeout,             0)
    opacity = Default(opacity,             1.00)
    zoom    = Default(zoom,                1.00)
    
    Assert(start   >= 0,  "start below 0")
    Assert((Defined(end) && Defined(end_margin))==false,  "�ݲ�֧��ͬʱ����end��end_padding")
    Assert((Defined(end_margin)==false) || end_margin >= 0,  "end_margin below 0")
    Assert((Defined(end_margin)==false) || start + end_margin < src.FrameCount(), "start��end_margin֮�ͳ�����ӰƬ֡�����޷�����logo�ĸ���")
    Assert(fadein  >= 0,  "fadein below 0")
    Assert(fadeout >= 0,  "fadeout below 0")
    Assert(zoom    > 0,    "zoom must greater than zero")
    Assert(Defined(overlay), "a png file is required")

    #����end��end_margin����last_frame
    #���������end����last_frameȡend�����δ����end��end_margin��last_frameȡ0�����δ����end��������end_margin��last_frameȡsrc.FrameCount()-1-end_margin
    last_frame = Default(end, Defined(end_margin) ? -(src.FrameCount()-start-end_margin) : 0)
    
    #����Ҫ����logo��Ƭ�ν�ȡ����
    video_source = src.KillAudio()
    target_clip = video_source.Trim(start, last_frame)
    
    #���logo��ʾ��֡��
    logo_frame_count = target_clip.FrameCount()
    
    #��ȡlogoͼ�񣬴���logo_clip���õ���ӰƬӦ����logo_frame_count֡��
    logo_clip = ImageSource(overlay, end=logo_frame_count-1, pixel_type="RGB32")
    Assert(logo_clip.FrameCount() == logo_frame_count, "LogoDraw�ڲ�����logo_clip֡�������ֵ����")
    
    #��logo_clipӦ��zoom
    logo_clip = zoom!=1.0 ? logo_clip.Spline64Resize(Round(logo_clip.Width*zoom/4)*4, Round(logo_clip.Height*zoom/4)*4) : logo_clip
    
    #��maskӦ��fadein��fadeout
    logo_clip_mask = logo_clip
    logo_clip_mask = fadein>0  ? logo_clip_mask.FadeIn0(fadein)   : logo_clip_mask
    logo_clip_mask = fadeout>0 ? logo_clip_mask.FadeOut0(fadeout) : logo_clip_mask
    
    
    #����ê�㻻��pos_x pos_y
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
    
    
    #��target_clip����logo
    logod_clip = target_clip.Overlay(logo_clip, mask=logo_clip_mask.ShowAlpha(), x=pos_x, y=pos_y, opacity=opacity)
    
    #������logo��ǰ��Ƭ��
    new_clip = logod_clip
    new_clip = start>0 ? video_source.Trim(0, -start) + new_clip : new_clip
    new_clip = start+logo_frame_count != src.FrameCount() ? new_clip + video_source.Trim(start+logo_frame_count, 0) : new_clip

    #��֤����logo��ȫƬ֡�������ǰһ��
    Assert(new_clip.FrameCount() == src.FrameCount(), "LogoDraw�ڲ���������logo��֡����ԭ֡����һ��")
    
    audio_source = src.KillVideo()
    return AudioDub(new_clip, audio_source)
}
