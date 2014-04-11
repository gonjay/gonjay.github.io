---
layout: post
title: "cocos2d-x integrate third party SDK with EasyNDK"
date: 2014-04-11 09:36:46 +0800
comments: true
categories: 
---
# 利用EasyNDK调用mpay的SDK


## 创建cocos2d-x项目
新的cocos2d-d v3.0支援了命令行的项目创建、编译和运行方式。在Mac环境下会轻松很多。按照官方的教程配置完成cocos的命令行环境，只需要`cocos new Demo -l cpp`就能在当前目录创建一个完整的具有跨平台特性的cocos项目了。

## 添加mpay的SDK环境

进入proj.ios_mac，打开.xcodeproj文件。

点击项目的Target，再选中Build Settings，然后搜索”Other Linker Flags”或者手工找到Other Linker Flags的项，在这个项的值添加 -ObjC。(**这一步很关键！！不然后面会报很多编译错误！**)

[引用源](http://mpay.netease.com/docs/iOS_sdk_guide.html)

## 添加NDKHelper

将文件夹NDKHelper、IOSNDKHelper以及jansson文件夹添加到项目中，在下面的链接中有EasyNDK的Demo和相关文件的下载。这个项目中使用的是cocos-x v2.x作为范例，在迁移到v3.x的时候会遇到一些API变动带来的编译错误，这个我在教程的后面会讲到。

[EasyNDK-for-cocos2dx](https://github.com/aajiwani/EasyNDK-for-cocos2dx)

## 修改HelloWorldScene

在HelloWorldScene.h中添加

```c
void menuNextCallback(cocos2d::Ref* pSender);//按钮的callback函数
void SampleSelectorWithData(cocos2d::Node *sender, void *data);//c代码中调用iOS Native代码的callback函数
```
在HelloWorldScene.cpp文件中`#include "NDKHelper.h"`，并在init中添加一个Item按钮，menu_seletor设置为`void menuNextCallback(cocos2d::Ref* pSender);`，再在`void HelloWorld::menuNextCallback(Ref* pSender)`中添加NDKHelper::AddSelector，并`SendMessageWithParams(string("SampleSelectorWithData"), prms);`[Sample Code](https://github.com/aajiwani/EasyNDK-for-cocos2dx/blob/master/Sample%20iOS%20Project/SampleNDK/Classes/HelloWorldScene.cpp)

## 修改RootViewController

然后在调用cocos2dx的RootViewController里面`#include "IOSNDKHelper.h" #import "NeteaseMpay.h"`，实现一堆mpay的delegate

```objc
@interface RootViewController () <NeteaseMpayLoginDelegate>

@property (strong, nonatomic) NeteaseMpayManager *manager;
@property (strong, nonatomic) NSString *environment;
@property (strong , nonatomic) NSString *gameId;

@end
```


然后添加

```objc
- (void) SampleSelectorWithData:(NSObject *)prms
{
    [self.manager authenticateUserFromViewController:self];
}
```

当你在cocos里面点击那个按钮的时候，就能触发RootViewController里面的SampleSelectorWithData函数了，因为我们使用的是mpay的SDK，此时会弹出一个Alert窗口，具体的相关部分会在mpay的官方网站guide给出。

如果想要回调到cocos，在该方法里面`[IOSNDKHelper SendMessage:CPPFunctionToBeCalled WithParameters:nil];`就能调用HelloWorldScene.cpp中的`void SampleSelectorWithData(cocos2d::Node *sender, void *data);`方法。


### 注意

对于mapy中NeteaseMpayManager，可能需要一个Lazy instantiation

```objc
- (NeteaseMpayManager *)manager
{
    if (!_manager) {
        _manager = [NeteaseMpayManager sharedManagerWithGameId:@"aecffrufnmaaaaaf"];
        _manager.loginDelegate = self;
        //use Sandbox environment for development only
        [_manager setEnvironment:kNeteaseMpayEnvironmentSandbox];
    }
    
    return _manager;
}
```

# Android项目编译

### cocos compile -p android失败

需要保证proj.android/jni/Android.mk文件中包含了Classes里面的EasyNDK相关的编译路径。

```c
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := cocos2dcpp_shared

LOCAL_MODULE_FILENAME := libcocos2dcpp

LOCAL_SRC_FILES := hellocpp/main.cpp \
                   ../../Classes/AppDelegate.cpp \
                   ../../Classes/HelloWorldScene.cpp \
                   ../../Classes/jansson/dump.c \
                   ../../Classes/jansson/error.c \
                   ../../Classes/jansson/hashtable.c \
                   ../../Classes/jansson/load.c \
                   ../../Classes/jansson/memory.c \
                   ../../Classes/jansson/pack_unpack.c \
                   ../../Classes/jansson/strbuffer.c \
                   ../../Classes/jansson/strconv.c \
                   ../../Classes/jansson/utf.c \
                   ../../Classes/jansson/value.c \
                   ../../Classes/NDKHelper/NDKCallbackNode.cpp \
                   ../../Classes/NDKHelper/NDKHelper.cpp

LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../Classes \
					$(LOCAL_PATH)/../../Classes/NDKHelper \
					$(LOCAL_PATH)/../../Classes/jansson \


LOCAL_WHOLE_STATIC_LIBRARIES := cocos2dx_static
LOCAL_WHOLE_STATIC_LIBRARIES += cocosdenshion_static
LOCAL_WHOLE_STATIC_LIBRARIES += box2d_static


include $(BUILD_SHARED_LIBRARY)

$(call import-module,2d)
$(call import-module,audio/android)
$(call import-module,Box2D)

```

### 找不到JniHelper.h

修改`NDKHelper.cpp` `#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)`后面的代码中为：

	#include "../cocos2d/cocos/2d/platform/android/jni/JniHelper.h"



### 一些log输出的编译错误

在`cocos compile -p android`的时候，可能会遇到一些log输出代码的编译错误，如`__android_log_print CCLog(s.c_str())`等，把它们注释即可，具体原因不明

### System.loadLibrary出错

cocos compile -p android 之后在libs里面出现armeabi/libcocos2dcpp.so的文件，需要在Android的主Activity中：
```java
static {
System.loadLibrary("cocos2dcpp");
}
```

### cpp代码和java代码互相调用方法是遇到错误

java调用cpp方法出错，解决方法：
修改NDKHelper.cpp中

```c
extern "C" {
#if (CC_TARGET_PLATFORM CC_PLATFORM_ANDROID)
// Method for recieving NDK messages from Java, Android
void Java_org_cocos2dx_cpp_AndroidNDKHelper_CPPNativeCallHandler(){}
}
```

使得`Java_org_cocos2dx_cpp_AndroidNDKHelper_CPPNativeCallHandler`为你引用`AndroidNDKHelper.java`的包名路径

cpp调用java出错，解决方法：

```cpp
#if (CC_TARGET_PLATFORM CC_PLATFORM_ANDROID)
	#include "../cocos2d/cocos/2d/platform/android/jni/JniHelper.h" 
	#include <android/log.h>
	#include <jni.h>
	#define LOG_TAG "EasyNDK-for-cocos2dx" 
	#define CLASS_NAME "org/cocos2dx/cpp/AndroidNDKHelper" 
#endif
```

使得`#define CLASS_NAME`为你引用`AndroidNDKHelper.java`的包名路径

### proj.android导入eclipse无法编译

在eclipse里面需要添加library，`import from exsiting android project`路径为：
`../cocos2d/cocos/2d/platform/android/java`

#### iOS Demo截图

![](http://ww2.sinaimg.cn/mw600/a22a83f5gw1ef96hl7538j20hs0qo408.jpg)
![](http://ww3.sinaimg.cn/mw600/a22a83f5gw1ef96hozd7jj20hs0qo0ui.jpg)
![](http://ww1.sinaimg.cn/mw600/a22a83f5gw1ef96hmbczlj20hs0qoq4e.jpg)
![](http://ww1.sinaimg.cn/mw600/a22a83f5gw1ef96hn835mj20hs0qo766.jpg)
![](http://ww1.sinaimg.cn/mw600/a22a83f5gw1ef96hmbczlj20hs0qoq4e.jpg)