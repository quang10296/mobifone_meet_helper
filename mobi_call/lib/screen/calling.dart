import 'dart:io';

import 'package:flutter/material.dart';
import '../config/globals.dart';
import 'contacts.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import '../helper/socket_helper.dart';

var socket = Singleton().socket;

class CallingScreen extends StatelessWidget {
  const CallingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(""),
      ),
      body: Center(
        child: Row(
          children: [
            Expanded(
                child: ElevatedButton(
              onPressed: () {
                print("Reject");
                socket.emit('RejectCall', {
                  "call_id": '${call_id}',
                });
                pushToContactScreenFunction(context);
              },
              child: Text(
                "Reject",
                style: TextStyle(fontSize: 25, color: Color(0xffffffff)),
              ),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(50),
                primary: Colors.red, // <-- Button color
                onPrimary: Colors.red, // <-- Splash color
              ),
            )),
            Expanded(
                child: ElevatedButton(
              onPressed: () {
                print("Answer");
                socket.emit('AcceptCall', {
                  "call_id": '${call_id}',
                });
                pushToContactScreenFunction(context);
                joinMeeting();
              },
              child: Text(
                "Answer",
                style: TextStyle(fontSize: 25, color: Color(0xffffffff)),
              ),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(50),
                primary: Colors.green, // <-- Button color
                onPrimary: Colors.green, // <-- Splash color
              ),
            )),
          ],
        ),
      ),
    );
  }

  joinMeeting() async {
    // Enable or disable any feature flag here
    // If feature flag are not provided, default values will be used
    // Full list of feature flags (and defaults) available in the README
    Map<FeatureFlagEnum, bool> featureFlags = {
      FeatureFlagEnum.WELCOME_PAGE_ENABLED: false,
    };
    if (true) {
      // Here is an example, disabling features for each platform
      if (Platform.isAndroid) {
        // Disable ConnectionService usage on Android to avoid issues (see README)
        featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      } else if (Platform.isIOS) {
        // Disable PIP on iOS as it looks weird
        featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      }
      //config off redundant function
      featureFlags[FeatureFlagEnum.ADD_PEOPLE_ENABLED] = false;
      featureFlags[FeatureFlagEnum.CALENDAR_ENABLED] = false;
      featureFlags[FeatureFlagEnum.CALL_INTEGRATION_ENABLED] = false;
      featureFlags[FeatureFlagEnum.CLOSE_CAPTIONS_ENABLED] = false;
      featureFlags[FeatureFlagEnum.INVITE_ENABLED] = false;
      featureFlags[FeatureFlagEnum.IOS_RECORDING_ENABLED] = false;
      featureFlags[FeatureFlagEnum.MEETING_NAME_ENABLED] = false;
      featureFlags[FeatureFlagEnum.MEETING_PASSWORD_ENABLED] = false;
      featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      featureFlags[FeatureFlagEnum.RAISE_HAND_ENABLED] = false;
      featureFlags[FeatureFlagEnum.RECORDING_ENABLED] = false;
      featureFlags[FeatureFlagEnum.TILE_VIEW_ENABLED] = false;
      featureFlags[FeatureFlagEnum.TOOLBOX_ALWAYS_VISIBLE] = false;
      featureFlags[FeatureFlagEnum.WELCOME_PAGE_ENABLED] = false;
    }
    // Define meetings options here
    // thanh
    call_id = "322612779";
    var options = JitsiMeetingOptions(room: call_id)
      ..serverURL = serverString
      ..token = tokenString
      ..subject = ""
      ..userDisplayName = call_id
      ..userEmail = ""
      ..iosAppBarRGBAColor = ""
      ..featureFlags.addAll(featureFlags)
      ..webOptions = {
        "roomName": call_id,
        "width": "100%",
        "height": "100%",
        "enableWelcomePage": false,
        "chromeExtensionBanner": null,
        "userInfo": {"displayName": call_id}
      };

    debugPrint("JitsiMeetingOptions: $options");
    await MBFMeet.joinMeeting(
      options,
      listener: JitsiMeetingListener(
          onConferenceWillJoin: (message) {
            debugPrint("${options.room} will join with message: $message");
          },
          onConferenceJoined: (message) {
            debugPrint("${options.room} joined with message: $message");
          },
          onConferenceTerminated: (message) {
            debugPrint("${options.room} terminated with message: $message");
            socket.emit('leave room');
          },
          genericListeners: [
            JitsiGenericListener(
                eventName: 'readyToClose',
                callback: (dynamic message) {
                  debugPrint("readyToClose callback");
                }),
          ]),
    );
  }
}
