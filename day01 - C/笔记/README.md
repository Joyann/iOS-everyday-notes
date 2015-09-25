# 1. 概述

今天主要学习了四个简单的iOS程序，iOS的历史，C语言的概述以及第一个hello world程序。

# 2. 四个iOS程序

- view controller之间的push
- 点击屏幕出现3D的cube转换效果
- 实现iOS中打电话和发短信功能
- 全景汽车的动画

##### tips(具体实现看代码)：

- 3D的cube转换效果利用CATransition类来实现，设置type,subtype,duration等属性，之后给view.layer加上这个动画即可。
  
- 打电话和发短信功能利用__openURL__来实现。其中打电话为"tel://电话号码"，发短信为"sms://电话号码"。
  
- 全景汽车主要是将多个图片加入数组，之后设置为imageView的animationImages等属性。其中想让其播放一次就结束，可以设置__animationRepeatCount__为__1__。
  
  ``` 
    self.imageView.animationImages = images;
    self.imageView.animationDuration = 2.0;
    self.imageView.animationRepeatCount = 1;
    [self.imageView startAnimating];
  ```

# 3. Xcode快捷键

- command + 12345 ...   打开导航栏
- command + 0           关闭导航栏
- command + opiton + 12345 ...   打开右侧atrribute inspector
- command + option + 0           关闭右侧atrribute inspector
- command + shift + y   打开/关闭debug栏
- command + .           结束运行
- 等

# 4. 补充

- 在一个project里面创建多个项目：__点击导航栏里的工程名，在PROGECT中点击下方的__+__来加入新的项目。注意，在运行时如果运行不同的项目，需要修改Stop键边上的不同target。__
  
- C语言.o(obj)为__目标文件__，在编译成功后产生，多个.o文件和系统库文件连接生成可执行文件.out（即编译链接成功之后产生的）。
  
- 在有多个图片名字相似只是序号不同时（比如image-01, image-02），在程序里需要使用到for循环来创建多个NSString的实例，如果这样写：__image-0%d__则不能满足，因为如果序号是两位数就不能得到图片了。这时可以采用的方法是：
  
  ``` 
    NSString *imageName = [NSStringstringWithFormat:"image-%02d", i]; // 意思是保留两位数，如果不足两位则用0来填充。
  ```

