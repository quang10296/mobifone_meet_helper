import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobifone_meet/mbf_meet.dart';
import '../config/globals.dart';
import 'contacts.dart';
import '../helper/socket_helper.dart';

var socket = Singleton().socket;

class WaitingScreen extends StatelessWidget {
  const WaitingScreen({Key? key}) : super(key: key);

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
                print("CancelCall");
                socket.emit('CancelCall', {
                  "call_id": '${call_id}',
                });
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(fontSize: 25, color: Color(0xffffffff)),
              ),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(50),
                primary: Colors.red, // <-- Button color
                onPrimary: Colors.red, // <-- Splash color
              ),
            )),
          ],
        ),
      ),
    );
  }

  @override
  void onCancelCallAction(context) {
    // TODO: implement onCancelCallAction
    pushToContactScreenFunction(context);
  }

  @override
  void onEndCallAction(context) {
    // TODO: implement onEndCallAction
    MBFMeet.closeMeeting();
    socket.emit("leave room");
    isCall = false;
    pushToContactScreenFunction(context);
  }

  @override
  void onMissAction(context) {
    // TODO: implement onMissAction
    pushToContactScreenFunction(context);
  }

  _joinMeeting() async {
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
    var options = MBFMeetingOptions(room: call_id)
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
      listener: MBFMeetingListener(
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
            MBFGenericListener(
                eventName: 'readyToClose',
                callback: (dynamic message) {
                  debugPrint("readyToClose callback");
                }),
          ]),
    );
  }
}
