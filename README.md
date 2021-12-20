# Tổng đài Mobifone SDK
<!-- Has been modified by ... -->


Mobifone SDK for Flutter. Supports Android, iOS.

"Jitsi Meet is an open-source (Apache) WebRTC JavaScript application that uses Jitsi Videobridge to provide high quality, secure and scalable video conferences." 

Find more information about Jitsi Meet [here](https://github.com/jitsi/jitsi-meet)

## Table of Contents
  - [Configuration](#configuration)
    - [IOS](#ios)
      - [Podfile](#podfile)
      - [Info.plist](#infoplist)
    - [Android](#android)
      - [Gradle](#gradle)
      - [AndroidManifest.xml](#androidmanifestxml)
      - [Minimum SDK Version 23](#minimum-sdk-version-23)
      - [Proguard](#proguard)
    - [Configuration Constants](#constants)
  - [Join A Meeting](#join-a-meeting)
    - [MBFMeetingOptions](#mbfmeetingoptions)
    - [FeatureFlag](#featureflag)
    - [MBFMeetingResponse](#mbfmeetingresponse)
  - [Listening to Meeting Events](#listening-to-meeting-events)
    - [Per Meeting Events](#per-meeting-events)
    - [Global Meeting Events](#global-meeting-events)
  - [Closing a Meeting Programmatically](#closing-a-meeting-programmatically)
  - [Contributing](#contributing)

<a name="configuration"></a>
## Configuration

<a name="ios"></a>
### IOS
* Note: Example compilable with XCode 12.2 & Flutter 1.22.4.

#### Podfile
Ensure in your Podfile you have an entry like below declaring platform of 11.0 or above and disable BITCODE.
```
platform :ios, '11.0'

...

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
```

#### Info.plist
Add NSCameraUsageDescription and NSMicrophoneUsageDescription to your
Info.plist.

```text
<key>NSCameraUsageDescription</key>
<string>$(PRODUCT_NAME) Example needs access to your camera for meetings.</string>
<key>NSMicrophoneUsageDescription</key>
<string>$(PRODUCT_NAME) Example needs access to your microphone for meetings.</string>
```

<a name="android"></a>
### Android

#### Gradle
Set dependencies of build tools gradle to minimum 3.6.3:
```gradle
dependencies {
    classpath 'com.android.tools.build:gradle:3.6.3' <!-- Upgrade this -->
    classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
}
```

Set distribution gradle wrapper to minimum 5.6.4.
```gradle
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-5.6.4-all.zip <!-- Upgrade this -->
```

#### AndroidManifest.xml
Jitsi Meet's SDK AndroidManifest.xml will conflict with your project, namely 
the application:label field. To counter that, go into 
`android/app/src/main/AndroidManifest.xml` and add the tools library
and `tools:replace="android:label"` to the application tag.

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="yourpackage.com"
    xmlns:tools="http://schemas.android.com/tools"> <!-- Add this -->
    <application 
        tools:replace="android:label"  
        android:name="your.application.name"
        android:label="My Application"
        android:icon="@mipmap/ic_launcher">
        ...
    </application>
...
</manifest>
```

#### Minimum SDK Version 23
Update your minimum sdk version to 23 in android/app/build.gradle
```groovy
defaultConfig {
    minSdkVersion 23 //Required for Jitsi
    targetSdkVersion 28
    versionCode flutterVersionCode.toInteger()
    versionName flutterVersionName
}
```

#### Proguard

Jitsi's SDK enables proguard, but without a proguard-rules.pro file, your release 
apk build will be missing the Flutter Wrapper as well as react-native code. 
In your Flutter project's android/app/build.gradle file, add proguard support

```groovy
buildTypes {
    release {
        // TODO: Add your own signing config for the release build.
        // Signing with the debug keys for now, so `flutter run --release` works.
        signingConfig signingConfigs.debug
        
        // Add below 3 lines for proguard
        minifyEnabled true
        useProguard true
        proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
    }
}
```

Then add a file in the same directory called proguard-rules.pro. See the example 
app's [proguard-rules.pro](example/android/app/proguard-rules.pro) file to know what to paste in.

*Note*  
If you do not create the proguard-rules.pro file, then your app will 
crash when you try to join a meeting or the meeting screen tries to open
but closes immediately. You will see one of the below errors in logcat.

```
## App crashes ##
java.lang.RuntimeException: Parcel android.os.Parcel@8530c57: Unmarshalling unknown type code 7536745 at offset 104
    at android.os.Parcel.readValue(Parcel.java:2747)
    at android.os.Parcel.readSparseArrayInternal(Parcel.java:3118)
    at android.os.Parcel.readSparseArray(Parcel.java:2351)
    .....
```

```
## Meeting won't open and you go to previous screen ##
W/unknown:ViewManagerPropertyUpdater: Could not find generated setter for class com.BV.LinearGradient.LinearGradientManager
W/unknown:ViewManagerPropertyUpdater: Could not find generated setter for class com.facebook.react.uimanager.g
W/unknown:ViewManagerPropertyUpdater: Could not find generated setter for class com.facebook.react.views.art.ARTGroupViewManager
W/unknown:ViewManagerPropertyUpdater: Could not find generated setter for class com.facebook.react.views.art.a
.....
```



<a name="constants"></a>
### Configuration Constants

#### Get Library
Run `flutter pub get` after add lib in pubspec.yaml
```
dependencies:
  flutter:
    sdk: flutter


  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.2
  
  http: ^0.13.4
  mobi_call:
    git:
      url: https://github.com/quang10296/mobifone_meet_helper.git
      ref: develop

```

#### How to use ?
Import package 

```
import 'package:mobi_call/config/config.dart';
import 'package:mobi_call/helper/socket_helper.dart';
import 'package:mobi_call/mobifone_helper/call_listener.dart';
import 'package:mobi_call/mobifone_helper/mobifone_helper.dart';
```

Implements MobifoneHelperListener, CallListener

```
class _DetailScreenState extends State<DetailScreen >implements MobifoneHelperListener, CallListener{
```

Init state 
```
@override
  void initState() {
    super.initState();
    Config.socketUrl = "http://123.456.789.642:6868";

    Config.jwt_token = "eyJhbGciOiJIUzI.mV4cCI6MTYzOTk4MzkyNH0.9RQtF8kGdZCQj0" ;
    
    MobifoneClient().mobifoneHelperListener = this;
    MobifoneClient().callListener = this;
    MobifoneClient().connectServer(context);
  }
```


#### Full Code 

```
import 'package:example_mobi_call/models/TokenModel.dart';
import 'package:flutter/material.dart';
import 'package:mobi_call/config/config.dart';
import 'package:mobi_call/helper/socket_helper.dart';
import 'package:mobi_call/mobifone_helper/call_listener.dart';
import 'package:mobi_call/mobifone_helper/mobifone_helper.dart';

class DetailScreen extends StatefulWidget {

  const DetailScreen({Key? key, required this.model}) : super(key: key);

  final TokenModel model;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen >implements MobifoneHelperListener, CallListener{
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    Config.socketUrl = "http://103.199.79.64:3000";

    Config.jwt_token = widget.model.token ;
    print("thanh " + Config.jwt_token);
    print("thanh2: " + widget.model.token);
    MobifoneClient().mobifoneHelperListener = this;
    MobifoneClient().callListener = this;
    MobifoneClient().connectServer(context);
  }

  void _incrementCounter() {
    setState(() {
    });
  }

  @override
  onConnectionConnect() {
    print("onConnectionConnect");
  }

  @override
  onConnectionError() {
    print("onConnectionError");
  }

  @override
  onError(String message) {
    print("onError");
  }

  @override
  onSignalingStateChange(String state) {
    print("$state");
    if (state == Config().EVENT_ACCEPT) {
      MobifoneClient().joinMeeting();
    }
  }

  void call() {
    print("token la ${widget.model.token}");
    MobifoneClient().makeCall("2cbeea73-23f7-43ce-8338-40c060f2283c", "video", "hong");
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text("Quang_daxua_vjp_pr0_n0_1"),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:  call,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

<a name="join-a-meeting"></a>



## Join A Meeting

```dart
_joinMeeting() async {
    try {
	  FeatureFlag featureFlag = FeatureFlag();
	  featureFlag.welcomePageEnabled = false;
	  featureFlag.resolution = FeatureFlagVideoResolution.MD_RESOLUTION; // Limit video resolution to 360p
	  
      var options = MBFMeetingOptions(room: "myroom") // room is Required, spaces will be trimmed
        ..serverURL = "https://someHost.com"
        ..subject = "Meeting with Mobifone SDK"
        ..userDisplayName = "My Name"
        ..userEmail = "myemail@email.com"
        ..userAvatarURL = "https://someimageurl.com/image.jpg" // or .png
        ..audioOnly = true
        ..audioMuted = true
        ..videoMuted = true
        ..featureFlag = featureFlag;

      await MBFMeet.joinMeeting(options);
    } catch (error) {
      debugPrint("error: $error");
    }
  }
```

<a name="mbfmeetingoptions"></a>

### MBFMeetingOptions

| Field             | Required  | Default           | Description |
 ------------------ | --------- | ----------------- | ----------- |
| room              | Yes       | N/A               | Unique room name that will be appended to serverURL. Valid characters: alphanumeric, dashes, and underscores. |
| subject           | No        | $room             | Meeting name displayed at the top of the meeting.  If null, defaults to room name where dashes and underscores are replaced with spaces and first characters are capitalized. |
| userDisplayName   | No        | "Fellow Jitster"  | User's display name. |
| userEmail         | No        | none              | User's email address. |
| audioOnly         | No        | false             | Start meeting without video. Can be turned on in meeting. |
| audioMuted        | No        | false             | Start meeting with audio muted. Can be turned on in meeting. |
| videoMuted        | No        | false             | Start meeting with video muted. Can be turned on in meeting. |
| serverURL         | No        | meet.jitsi.si     | Specify your own hosted server. Must be a valid absolute URL of the format `<scheme>://<host>[/path]`, i.e. https://someHost.com. Defaults to Jitsi Meet's servers. |
| userAvatarURL     | N/A       | none              | User's avatar URL. |
| token             | N/A       | none              | JWT token used for authentication. |
| featureFlag      | No        | see below         | Object of FeatureFlag class used to enable/disable features and set video resolution of Jitsi Meet SDK. |

<a name="mbfmeetingresponse"></a>

### FeatureFlag

Feature flag allows you to limit video resolution and enable/disable few features of MBF SDK mentioned in the list below.  
If you don't provide any flag to MBFMeetingOptions, default values will be used.  

We are using the [official list of flags, taken from the Jitsi Meet repository](https://github.com/jitsi/jitsi-meet/blob/master/react/features/base/flags/constants.js)

| Flag | Default (Android) | Default (iOS) | Description |
| ------------------------------ | ----- | ----- | ----------- |
| `addPeopleEnabled`          | true  | true  | Enable the blue button "Add people", show up when you are alone in a call. Required for flag `inviteEnabled` to work. |
| `calendarEnabled`            | true  | auto  | Enable calendar integration. |
| `callIntegrationEnabled`    | true  | true  | Enable call integration (CallKit on iOS, ConnectionService on Android). **SEE REMARK BELOW** |
| `closeCaptionsEnabled`      | true  | true  | Enable close captions (subtitles) option in menu. |
| `conferenceTimerEnabled`                | true  | true  | Enable conference timer. |
| `chatEnabled`                | true  | true  | Enable chat (button and feature). |
| `inviteEnabled`              | true  | true  | Enable invite option in menu. |
| `iOSRecordingEnabled`       | N/A   | false | Enable recording in iOS. |
| `kickOutEnabled`       | true   | true | Enable kick-out option in video thumb of participants. |
| `liveStreamingEnabled`      | auto  | auto  | Enable live-streaming option in menu. |
| `meetingNameEnabled`        | true  | true  | Display meeting name. |
| `meetingPasswordEnabled`    | true  | true  | Display meeting password option in menu (if a meeting has a password set, the dialog will still show up). |
| `pipEnabled`                 | auto  | auto  | Enable Picture-in-Picture mode. |
| `raiseHandEnabled`          | true  | true  | Enable raise hand option in menu. |
| `recordingEnabled`           | auto  | N/A   | Enable recording option in menu. |
| `resoulution`           | N/A  | N/A  | Set local and (maximum) remote video resolution. Overrides server configuration. Accepted values are: LD_RESOLUTION for 180p, MD_RESOLUTION for 360p, SD_RESOLUTION for 480p(SD), HD_RESOLUTION for 720p(HD) . |
| `serverURLChangeEnabled`           | true  | true  | Enable server URL change. |
| `tileViewEnabled`           | true  | true  | Enable tile view option in menu. |
| `toolboxAlwaysVisible`      | true  | true  | Toolbox (buttons and menus) always visible during call (if not, a single tap displays it). |
| `videoShareButtonEnabled`      | true  | true  | Enable video share button. |
| `welcomePageEnabled`        | false | false | Enable welcome page. "The welcome page lists recent meetings and calendar appointments and it's meant to be used by standalone applications." |

**REMARK about Call integration** Call integration on Android (known as ConnectionService) [has been disabled on the official Jitsi Meet app](https://github.com/jitsi/jitsi-meet/commit/95eb551156c6769e25be9855dd2bc21adf71ac76) because it creates a lot of issues. You should disable it too to avoid these issues.

### MBFMeetingResponse

| Field           | Type    | Description |
| --------------- | ------- | ----------- |
| isSuccess       | bool    | Success indicator. |
| message         | String  | Success message or error as a String. |
| error           | dynamic | Optional, only exists if isSuccess is false. The error object. |

<a name="listening-to-meeting-events"></a>

## Listening to Meeting Events

Events supported

| Name                   | Description  |
| :--------------------- | :----------- |
| onConferenceWillJoin   | Meeting is loading. |
| onConferenceJoined     | User has joined meeting. |
| onConferenceTerminated | User has exited the conference. |
| onPictureInPictureWillEnter | User entered PIP mode. |
| onPictureInPictureTerminated | User exited PIP mode. |
| onError                | Error has occurred with listening to meeting events. |

### Per Meeting Events
To listen to meeting events per meeting, pass in a MBFMeetingListener
in joinMeeting. The listener will automatically be removed when an  
onConferenceTerminated event is fired.

```
await MBFMeet.joinMeeting(options,
  listener: MBFMeetingListener(onConferenceWillJoin: ({message}) {
    debugPrint("${options.room} will join with message: $message");
  }, onConferenceJoined: ({message}) {
    debugPrint("${options.room} joined with message: $message");
  }, onConferenceTerminated: ({message}) {
    debugPrint("${options.room} terminated with message: $message");
  }, onPictureInPictureWillEnter: ({message}) {
	debugPrint("${options.room} entered PIP mode with message: $message");
  }, onPictureInPictureTerminated: ({message}) {
	debugPrint("${options.room} exited PIP mode with message: $message");
  }));
```

### Global Meeting Events
To listen to global meeting events, simply add a MBFMeetListener with  
`MBFMeet.addListener(myListener)`. You can remove listeners using  
`MBFMeet.removeListener(listener)` or `MBFMeet.removeAllListeners()`.

```dart
@override
void initState() {
  super.initState();
  MBFMeet.addListener(MBFMeetingListener(
    onConferenceWillJoin: _onConferenceWillJoin,
    onConferenceJoined: _onConferenceJoined,
    onConferenceTerminated: _onConferenceTerminated,
    onPictureInPictureWillEnter: _onPictureInPictureWillEnter,
    onPictureInPictureTerminated: _onPictureInPictureTerminated,
    onError: _onError));
}

@override
void dispose() {
  super.dispose();
  MBFMeet.removeAllListeners();
}

_onConferenceWillJoin({message}) {
  debugPrint("_onConferenceWillJoin broadcasted");
}

_onConferenceJoined({message}) {
  debugPrint("_onConferenceJoined broadcasted");
}

_onConferenceTerminated({message}) {
  debugPrint("_onConferenceTerminated broadcasted");
}

_onPictureInPictureWillEnter({message}) {
debugPrint("_onPictureInPictureWillEnter broadcasted with message: $message");
}

_onPictureInPictureTerminated({message}) {
debugPrint("_onPictureInPictureTerminated broadcasted with message: $message");
}

_onError(error) {
  debugPrint("_onError broadcasted");
}
```

## Closing a Meeting Programmatically
```dart
MBFMeet.closeMeeting();
```

<a name="contributing"></a>

## Contributing
KEEP IT FOR YOURSELF.