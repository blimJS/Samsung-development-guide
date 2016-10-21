# Samsung Development Guide for Web Apps

TV Apps are created as standard HTML5 apps. You can create your TV app using the TizenTV IDE ([Tizen SDK](https://developer.tizen.org/development/tools/download)), or any editor that you choose.

Apps are usually created as SPA. You can use most frameworks and libraries used in web based application development including jQuery, Backbone, Angular, React, and others.

TV apps are displayed on the TV fullscreen, without any browser controls. The window size will vary depending on the resolution of the TV. But typically this means you will only have to deal with 2 different sizes: [1920x1080 or 1280x720](https://www.samsungdforum.com/Tizen/Spec#GeneralFeatures).

###Essentials of Developing Tizen Web Application

####SDK
To develop Tizen TV web apps, you need to install a SDK. You can download a SDK from Samsung Developer Forum site:
[Tizen SDK Download](https://developer.tizen.org/development/tools/download)

To use a GPU accelerator you should install Intel HAXM(Hardware Accelerated Execution), otherwise an emulator will not work properly. During installing a SDK, Intel HAXM should be installed automatically. In case of any errors you can install manually the following file: [HAXM](https://www.samsungdforum.com/guide_static/tizenoverviewguide/_downloads/IntelHaxmTizen_mac.zip).

> The HAXM driver is automatically installed with the IDE, only install it if the emulator does not work.

Emulator runs on a virtual machine (QEMU), none of these are supported (and the Emulator will complain/not work if they are running on the host computer):
	* Virtual Box
	* VMWare
	* Parallels(Mac PC)
####Generating Author Certificate

All apps must be signed with an author certificate. It is used to identify an app developer and protect apps from mixing and misusing. It is registered by a SDK installed on each PC. The following is the guide of registering.

_Follow this guide to generate the certificate:_
[https://www.samsungdforum.com/TizenGuide/tizen3531/index.html](https://www.samsungdforum.com/TizenGuide/tizen3531/index.html)

[Certificate Guide(PDF)](resources/CertificateGuide.pdf)

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

> [More on UI/UX Guidelines. ](https://www.samsungdforum.com/TizenUxGuide/)

####App Resolution
On Samsung UHD TV, the standard of app resolution is 1920x1080px and the aspect ratio is 16:9. (In case of Samsung FHD TV, it is 1280x720px.) Even if the resolution is different from the standard, the aspect ratio should be kept. Only if you keep the ratio, whitespace and scrollbars will not appear on a screen when the app is scaled up or down.

####APIs
Information about the APIs available [here](https://www.samsungdforum.com/TizenApiGuide/).

####Browser User-Agent String Format

| Year | UA String |
| :--: | :------- |
| 2015 | Mozilla/5.0 (SMART-TV; Linux; Tizen 2.3) AppleWebkit/538.1 (KHTML, like Gecko) SamsungBrowser/1.0 TV Safari/538.1 |
| 2014 | Mozilla/5.0 (SMART-TV; X11; Linux armv7l) AppleWebkit/537.42 (KHTML, like Gecko) Safari/537.42 |
| 2013 | Mozilla/5.0 (SMART-TV;X11; Linux i686) AppleWebkit/535.20+ (KHTML, like Gecko) Version/5.0 Safari/535.20+ |
| 2012 | Mozilla/5.0 (SMART-TV; X11; Linux i686) AppleWebKit/534.7 (KHTML, like Gecko) Version/5.0 Safari/534.7 |
| 2011 | Mozilla/5.0 (SmartHub; SMART-TV; U; Linux/SmartTV) AppleWebKit/531.2 (KHTML, like Gecko) Web Browser/1.0 SmartTV Safari/531.2+ |

@source: [https://github.com/ruiposse/smart-tv-app-dev-guidelines](https://github.com/ruiposse/smart-tv-app-dev-guidelines)

@source: [http://developer.samsung.com/technical-doc/view.do?v=T000000203](http://developer.samsung.com/technical-doc/view.do?v=T000000203)

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

> [AVPlay API Reference](https://www.samsungdforum.com/tizenapiguide/tizen3001/index.html)

> [Sample Code](https://github.com/SamsungDForum/PlayerAVPlayDRM)

> [Official Guide Overview PDF](https://www.samsungdforum.com/guide_static/tizenoverviewguide/_downloads/Essentials_of_Developing_Tizen_Web_Application_EN_1_4(1).pdf)

###AVPlay API

####AVPlay Object Lifecycle

![alt text][cycle]
[cycle]: https://www.samsungdforum.com/guide_static/tizenguide/_images/AVPlay_state.jpg "AVPlay Object Lifecycle"

####Adaptive Streaming
AVPlay module of Samsung Tizen TV supports adaptive streaming playing. DASH, HLS, Smooth Streaming are supported in Samsung Tizen TV. It enables user to change bitrate during playback.

The adaptive streaming engine needs to be specified when __open()__ API is called. Based on media file extension name, adaptive streaming engine is adjusted.

__Smooth Streaming__
.ism/Manifest

__DASH__
.xml
.mpd

__HLS__
.m3u8

__Widevine__
.wvm
.vob

####Example of object initialization (Call order is very important.)

```javascript
videoPlay: function (url) {
    var listener = {
        onbufferingstart: function () {
            console.log("Buffering start.");
        },
        onbufferingprogress: function (percent) {
            console.log("Buffering progress data : " + percent);
        },
        onbufferingcomplete: function () {
            console.log("Buffering complete.");
        },
        oncurrentplaytime: function (currentTime) {
            console.log("Current playtime: " + currentTime);
        },
        onevent: function (eventType, eventData) {
            console.log("event type: " + eventType + ", data: " + eventData);
        },
        ondrmevent: function (drmEvent, drmData) {
            console.log("DRM callback: " + drmEvent + ", data: " + drmData);
        },
        onstreamcompleted: function () {
            console.log("Stream Completed");
            webapis.avplay.stop();
        },
        onerror: function (eventType) {
            console.log("event type error : " + eventType);
        }
    };

    webapis.avplay.open(url);
    webapis.avplay.setDisplayRect(0, 0, 1920, 1080);
    webapis.avplay.setListener(listener);

    var drmParam = {
      DeleteLicenseAfterUse : true
    };

    //drmParam.LicenseServer = "license server url to play content";
    //drmParam.CustomData = "Custom Data to play content";
    webapis.avplay.setDrm("PLAYREADY", "SetProperties", JSON.stringify(drmParam));

    webapis.avplay.prepare();
    webapis.avplay.play();
}
```

To adjust the properties of the streaming you can use __webapis.avplay.setStreamingProperty()__.

```javascript
webapis.avplay.setStreamingProperty("ADAPTIVE_INFO", params);
```

This method should be called only on "IDLE" state.

To configure DRM playback, the method __webapis.avplay.setDrm()__ can be used.

This method updates DRM information, such as SetProperties etc. It changes the DRM mode, and runs the Control Feature. Every DRM has difference between AVPlayDrmOperation and jsonParam.

```javascript
var params = {
  LicenseServer: 'URL TO LICENSE SERVER',
  DeleteLicenseAfterUse: true
};

try {
    webapis.avplay.setDrm("PLAYREADY", "SetProperties", JSON.stringify(params));
} catch (e) {
    //Error
}
```

This method should be called on these states - "IDLE" and "PAUSED".


>[setStreamingProperty()](https://www.samsungdforum.com/TizenApiGuide/tizen3001/index.html#AVPlay-AVPlayManager-setStreamingProperty)

>[AVPlay Official Guide](https://www.samsungdforum.com/TizenGuide/tizen3451/index.html)

###CLI Tizen SDK

__Export SDK path__
```bash
export PATH=$PATH:/Users/keiverh/tizen-sdk/tools/ide/bin
```

__Setup global profile__
```bash
tizen cli-config -g default.profiles.path=/Users/keiverh/workspace/.metadata/.plugins/org.tizen.common.sign/profiles.xml
```

> This profile is created using the Tizen IDE. It identifies the developer and distributor certificate.

__List platforms and templates__
```bash
tizen list web-project
```

__Create project__
```bash
tizen create web-project -p  tv-2.4 -t WebBasicapplication -n blimcli -- /Users/keiverh/workspace
```

__Build package__
```bash
tizen build-web -- ~/workspace/blimcli
```

__Package app__
```bash
tizen package --type wgt --sign dev -- /Users/keiverh/workspace/blimcli/.buildResult
```

__Install package__
```bash
tizen install --target emulator-26101 --name blimcli.wgt -- /Users/keiverh/workspace/blimcli/.buildResult
```
___
> ###Online Resources
>- [App Structure](https://www.samsungdforum.com/TizenOverview#contents)
>- [Platform Features](https://www.samsungdforum.com/Tizen/Spec#GeneralFeatures)
>- [W3C/HTML5 API Reference](https://www.samsungdforum.com/TizenApiGuide/tizen851/index.html)
>- [Setting Project Properties ](https://developer.tizen.org/ko/development/getting-started/web-application/application-development-process/setting-project-properties?langredirect=1#set_widget)
>- [Examples on GitHub from Samsung](https://github.com/Samsung/TizenTVApps)
>- [Examples on GitHub from SamsungDForum](https://github.com/SamsungDForum/)
>- [APIs Reference](https://developer.tizen.org/development/api-references/web-application)
>- [AVPlay Reference](https://www.samsungdforum.com/tizenapiguide/tizen3001/index.html)
>- [Caph - Focus handling for Angular and jQuery](https://www.samsungdforum.com/AddLibrary/CaphSdkDownload)
>- [App Distribution Guide](http://www.samsungdforum.com/Support/Distribution)
>- [CLI Dev Tools](https://developer.tizen.org/development/tools/web-tools/command-line-interface)
>- [Tizen Key Codes](https://www.samsungdforum.com/TizenGuide/tizen3551/index.html)
>- [Developing for Tizen TV - Article](http://clearbridgemobile.com/lessons-learned-developing-for-tizen-tv/)


###Caph

CAPH is a Web UI framework for TVs, it has these modules:

- Key Navigation
- Scrollable List and Grid
- UI Components : Button, Radio Button, Toggle Button, Checkbox, Input, Dialog, Context Menu, Dropdown Menu
- Touch feature : Pan, Tap and Double Tap. (from CAPH 3.1)

Helps developers handle user input from four directional keys on the remote and maximizes the usage of the GPU, since TV devices generally have a far more powerful GPU than CPU.

> Problems: It is not open source and only has versions for jQuery and Angular 1.x.

[Caph Documentation](https://www.samsungdforum.com/caphdocs/)

###Privileges

Privilege level defines access level for the APIs, based on their influence.

There are 3 levels of privilege.

1. __public__ - Everyone can use public privilege, but be careful to use APIs, because these are security-sensitive.

2. __partner__ - Only authorized partners can use APIs.

3. __platform__ - Very security-sensitive. not permitted to Samsung Smart TV

These privileges will be used when configuring the app on the config.xml file.

#####Tizen Device API Privileges

> Privileges which are not in this table are not used in Samsung Tizen Smart TV.

|Privilege|Level|Description|
|----------|:-------------:|------|
|http://tizen.org/privilege/alarm | public |The application can set alarms and wake up the device at scheduled times.|
|http://tizen.org/privilege/application.info | public |The application can retrieve information related to other applications.|
|http://tizen.org/privilege/application.launch | public |The application can open other applications using the application ID or application control. |
|http://tizen.org/privilege/appmanager.certificate | partner |The application can retrieve specified application certificates. |
|http://tizen.org/privilege/appmanager.kill | partner |The application can close other applications. |
|http://tizen.org/privilege/content.read | public |The application can read media content information. |
|http://tizen.org/privilege/content.write | public |The application can create, update, and delete media content information. |
|http://tizen.org/privilege/download | public |The application can manage HTTP downloads. |
|http://tizen.org/privilege/filesystem.read | public |The application can read file systems. |
|http://tizen.org/privilege/filesystem.write | public |The application can write to file systems. |
|http://tizen.org/privilege/package.info | public |The application can retrieve information about installed packages. |
|http://tizen.org/privilege/packagemanager.install | platform |	The application can install or uninstall application packages. |
|http://tizen.org/privilege/system | public |The application can read system information. |
|http://tizen.org/privilege/systemmanager | partner |The application can read secure system information. |
|http://tizen.org/privilege/tv.audio | public |	The application can control TV audio. |
|http://tizen.org/privilege/tv.channel | public |The application can control TV channel. |
|http://tizen.org/privilege/tv.display | public |The application can control TV 3D mode. |
|http://tizen.org/privilege/tv.inputdevice | public |The application can generate a key event from TV remote control. |
|http://tizen.org/privilege/tv.window | public |The application can control TV window. (e.g. main windwos, PIP window) |
|http://tizen.org/privilege/websetting | public |The application can change its Web application settings, including deleting cookies. |
|http://tizen.org/privilege/datacontrol.consumer | public |Allows the application to access specific data exported by other applications. It is a privilege for a Web application sharing data with other applications. |
|http://tizen.org/privilege/telephony | public |Allows the application to retrieve telephony information, such as the used network and SIM card, the IMEI, and the call statuses. This privilege is for a native application. |
|http://tizen.org/privilege/led | public |Allows the application to switch LEDs on and off, such as the LED on the front of the device and the camera flash. This privilege is for a native application. |
|http://tizen.org/privilege/keymanager | public |Allows the application to save keys, certificates, and data to, and retrieve and delete them from, a password-protected storage.  This privilege is for a native application. |


#####Samsung Product API Privileges

> Privileges which are not in this table are not used in Samsung Tizen Smart TV.

|Privilege|Level|Description|
|----------|:-------------:|------|
|http://developer.samsung.com/privilege/adstreamingfw | public |The application can use the Adstreaming framework feature. |
|http://developer.samsung.com/privilege/allshare | public |The application can use the allshare feature. |
|http://developer.samsung.com/privilege/avplay | public |The application can play multimedia. |
|http://developer.samsung.com/privilege/drminfo | partner |The application can play DRM encrypted multimedia |
|http://developer.samsung.com/privilege/network.public | public |The application can read network status and informations. |
|http://developer.samsung.com/privilege/productinfo | public |The application can read device product related informations (e.g. DUID, model code) |
|http://developer.samsung.com/privilege/widgetdata | public |The application can read/write widget's secured storage. |
|http://developer.samsung.com/privilege/microphone | public |The application can use Microphone. |
|http://developer.samsung.com/privilege/sso.partner | partner |The application can read SSO related informations. |
|http://developer.samsung.com/privilege/drmplay | public |Allows the application to play the DRM contents. This privilege is for a Web application. |
|http://developer.samsung.com/privilege/billing | public |Allows the application to use in-app purchase provided by Samsung Checkout on TV. |

#####W3C/HTML5 API Privileges

|Privilege|Level|Description|
|----------|:-------------:|------|
|http://tizen.org/privilege/internet | public |The application can access the Internet using the WebSocket,XMLHttpRequest Level 2, Server-Sent Events, HTML5 Application caches, and Cross-Origin Resource Sharing APIs.  |
|http://tizen.org/privilege/mediacapture | public | The application can manipulate streams from cameras and microphones using the getUserMedia API. |
|http://tizen.org/privilege/unlimitedstorage | public |In the local domain, if this privilege is defined, permission is granted. Otherwise, pop-up user prompt is used. In the remote domain, pop-up user prompt is used. |
|http://tizen.org/privilege/notification | public |The application can display simple notifications using the Web Notifications API. |
|http://tizen.org/privilege/location | public |The application can access geographic locations using the GeolocationAPI. |

#####Web Supplementary API Privileges

|Privilege|Level|Description|
|----------|:-------------:|------|
|http://tizen.org/privilege/fullscreen | public |Allows the application to display in full-screen mode using the FullScreen API (Mozilla). |

> [Privilege Reference](https://www.samsungdforum.com/TizenGuide/tizen3431/index.html)

###Application Configuration File
Each application developed for Tizen will require a configuration file (config.xml) on the root path of the app.

Example:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<widget xmlns="http://www.w3.org/ns/widgets" xmlns:tizen="http://tizen.org/ns/widgets" id="http://www.blim.com" version="1.0.0" viewmodes="maximized">
    <tizen:allow-navigation>*</tizen:allow-navigation>
    <tizen:application id="NgUSbxuJwx.blim" package="NgUSbxuJwx" required_version="2.3"/>
    <content src="dist/index.html"/>
    <tizen:content-security-policy>*</tizen:content-security-policy>
    <feature name="http://tizen.org/feature/screen.size.all"/>
    <feature name="http://www.samsungdforum.com/feature/Mouse"/>
    <feature name="http://tizen.org/privilege/application.read" required="true"/>
    <icon src="icon.jpg"/>
    <name>blim</name>
    <tizen:privilege name="http://tizen.org/privilege/system"/>
    <tizen:privilege name="http://tizen.org/privilege/content.read"/>
    <tizen:privilege name="http://tizen.org/privilege/content.write"/>
    <tizen:privilege name="http://tizen.org/privilege/tv.inputdevice"/>
    <tizen:privilege name="http://tizen.org/privilege/tv.audio"/>
    <tizen:privilege name="http://tizen.org/privilege/filesystem.read"/>
    <tizen:privilege name="http://tizen.org/privilege/filesystem.write"/>
    <tizen:privilege name="http://developer.samsung.com/privilege/drmplay"/>
    <tizen:privilege name="http://developer.samsung.com/privilege/avplay"/>
    <tizen:privilege name="http://developer.samsung.com/privilege/network.public"/>
    <tizen:privilege name="http://developer.samsung.com/privilege/drminfo"/>
    <tizen:privilege name="http://developer.samsung.com/privilege/productinfo"/>
    <tizen:profile name="tv"/>
</widget>
```

This file will hold the basic information about the application, what privileges it needs and what features will have.

Failing to add a required privilege will cause the app not to work or behave the way it is not suppose to.

###Architecture & Application Life Cycle
####Tizen Architecture
![alt text][arch]
[arch]: https://www.samsungdforum.com/guide_static/tizenintroduction/_images/Tizen_Arch.jpg
"Tizen Architecture"

Samsung has created a customized wrapper over Tizen platform to facilitate development of Tizen TV apps. Tizen apps have a defined lifecycle which is handled by the Core component of Tizen Platform as shown in the Tizen Architecture above. Application Lifecycle can be visualized as shown below:

####Application Life Cycle
![alt text][alc]
[alc]: https://www.samsungdforum.com/guide_static/tizenintroduction/_images/App_lifecycle.jpg "Application Life Cycle"

When any app is launched then application main loop is created, which is responsible for all the app states.

1. __Ready__ means app has been launched by the user and main loop is created.
2. __Create__ means app has been initialized and an instance is created for use.
3. __Reset__ means app has re-launch request.
4. __Running__ means app is active on device and responding to all the events received.
5. __Pause__ means app has been suspended by hiding the application window. Upon resume app comes back in running state, and the previous scene is recovered. With the help of this feature Tizen provides multitasking in the devices.
6. __Resume__ means the suspended app has been resumed and the application window becomes visible.
7. __Terminated__ means after the execution of the main loop terminate the application.

For more details refer to the [ App Lifecycle](https://developer.tizen.org/documentation/articles/application-fundamentals-developer-guide?langswitch=en#appLifeCycle) reference page.
##Development Notes

###The Emulator
The Emulator is a virtual machine running Tizen TV OS. It is a bit slower than an actual TV. Create a new emulator image using the Emulator Manager which comes with the Tizen SDK.

###The Simulator
The Simulator is a node app much faster than the Emulator, but with less supported functionalities. (Video playback, some key binding...)

###Debugging on the Emulator
In order to debug an app running on the Emulator or an actual TV, the project needs to be launched form the official SDK, in case you want to debug an app from the TV, the TV needs to be on Developer Mode and configured to use your computer IP address.

[Developer Mode and App Install on TV (PDF)](resources/Install_on_TV.pdf)
