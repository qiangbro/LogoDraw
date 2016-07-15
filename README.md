# LogoDraw

LogoDraw 1.0

在给定的影片上覆盖指定的logo。

支持设置覆盖的锚点坐标、锚点定位方式、开始帧、结束帧、渐进渐出、透明度、放缩比例 等。

本函数是对QiuSJ:JXlogoAdd.avsi的代码重构功能增强版本，兼容原版参数。

示例、详细说明见LogoDraw.avsi注释。


Author : Mikey

E-mail : qiangbro@qq.com

所在团队 : 有村花纯字幕组

项目网址 : https://github.com/qiangbro/LogoDraw



示例:

        #在1000帧时开始显示logo，显示120帧之后隐藏
        logoDraw("H:\fansub-work\rina_bar\images\rinabar-watermark-v1.1.png", x=1300, y=730, start=1000, end=-120)
