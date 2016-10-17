# Samsung Development Guide for Web Apps

TV Apps are created as standard HTML5 apps. You can create your TV app using the TizenTV IDE ([Tizen SDK](https://developer.tizen.org/development/tools/download)), or any editor that you choose.

Apps are usually created as SPA. You can use most frameworks and libraries used in web based application development including jQuery, Backbone, Angular, React, and others.

TV apps are displayed on the TV fullscreen, without any browser controls. The window size will vary depending on the resolution of the TV. But typically this means you will only have to deal with 2 different sizes: [1920x1080 or 1280x720](https://www.samsungdforum.com/Tizen/Spec#GeneralFeatures).

###Essentials of Developing Tizen Web Application

####SDK
To develop Tizen TV web apps, you need to install a SDK. You can download a SDK from Samsung Developer Forum site:
[Tizen SDK Download](https://developer.tizen.org/development/tools/download)

To use a GPU accelerator you should install Intel HAXM(Hardware Accelerated Execution), otherwise an emulator will not work properly. During installing a SDK, Intel HAXM should be installed automatically. In case of any errors you can install manually the following file: [HAXM](https://www.samsungdforum.com/guide_static/tizenoverviewguide/_downloads/IntelHaxmTizen_mac.zip).

Emulator runs on a virtual machine (QEMU), none of these are supported (and the Emulator will complain/not work if they are running on the host computer):
	* Virtual Box
	* VMWare
	* Parallels(Mac PC)
####Generating Author Certificate

All apps must be signed with an author certificate. It is used to identify an app developer and protect apps from mixing and misusing. It is registered by a SDK installed on each PC. The following is the guide of registering.

_Follow this guide to generate the certificate:_
[https://www.samsungdforum.com/TizenGuide/tizen3531/index.html](https://www.samsungdforum.com/TizenGuide/tizen3531/index.html)

After creating the author certificate, be careful not to lose it. This is the unique proof for certifying app developer. If you lose it, you can’t version up your app.

####UI/UX Requirements
Samsung Smart TV provides a user experience that differs completely from that of other familiar devices, such as mobile devices and desktop computers.

#####General Considerations:
![alt text][tv]
[tv]: https://www.samsungdforum.com/guide_static/tizenuxguide/img_01_01_tv_viewing.png "TV Use"

* The average distance between a TV and its viewers is 3 meters (10ft).
* The standard remote control is the main input method.
* TV is used by more than one person.
* Simplicity, Clarity, User Control, ConsistencyFeedback, Feedback and Aesthetic Considerations should be taken into consideration when developing the app.

> [More about UI/UX Guidelines. ](https://www.samsungdforum.com/TizenUxGuide/)

####App Resolution
On Samsung UHD TV, the standard of app resolution is 1920x1080px and the aspect ratio is 16:9. (In case of Samsung FHD TV, it is 1280x720px.) Even if the resolution is different from the standard, the aspect ratio should be kept. Only if you keep the ratio, whitespace and scrollbars will not appear on a screen when the app is scaled up or down.

####APIs
Information about the APIs available [here](https://www.samsungdforum.com/TizenApiGuide/).

###App Development

####Registering Remote Controller Key
An app should controlled by the _KeyCode_ of a remote controller. Only if you register the key to use, an app can receive the KeyCode.

Key codes can be registered with the Tizen API as follows:
```javascript
tizen.tvinputdevice.registerKey(KeyName);
```

Getting supported keys:
```javascript

var value = tizen.tvinputdevice.getSupportedKeys();
console.log(value);
```

Using key codes requires the following privilege on the config.xml file.
```xml
<tizen:privilege name='http://tizen.org/privilege/tv.inputdevice'/>
```

> [More on TVInputDevice API.](https://www.samsungdforum.com/tizenapiguide/tizen3331/index.html)

> [More on _privileges_.](https://www.samsungdforum.com/TizenGuide/tizen3431/index.html)

####APIs for VOD Service App
1. There are two ways to play VODs on an app. One way is using the video tag, which is an HTML5 standard element. And the other way is by using __webapis.avplay__ which is an API supported by Samsung Tizen TV. More details bellow:

  1.1. __Video Tag__: Video tag makes VODs playing easy by a HTML5 standard element. If you can enough develop by using only it, we recommend using it rather than webapis.avplay

  1.2. __webapis.avplay__: The following is the list to be difficult or not supported by video tag. When you use these technologies, you can use webapi.avplay.

* DRM(Digital Rights Management)
* HLS(HTTP Live Streaming)
* DASH(Dynamic Adaptive Streaming over HTTP)
* Smooth Streaming
* Adaptive Streaming
* 3D Contents, Closed Caption etc…

> [More on AVPlay API](https://www.samsungdforum.com/tizenapiguide/tizen3001/index.html)

> [Guide Overview PDF](https://www.samsungdforum.com/guide_static/tizenoverviewguide/_downloads/Essentials_of_Developing_Tizen_Web_Application_EN_1_4(1).pdf)

... in progress...
