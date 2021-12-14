import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import '../main.dart';
import '../model/contact_user_model.dart';
import '../model/user_model.dart';
import 'calling.dart';
import 'waiting.dart';
import '../helper/socket_helper.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import '../config/globals.dart';

var socket = Singleton().socket;

class ContactScreen extends StatelessWidget {
  var arrUserContacts = [
    ContactUserModel(
        ottUserId: "31affff1-7eff-4743-a294-64efcd97c81a",
        username: "hao",
        phoneNumber: "1111111111",
        displayName: "hao"),
    ContactUserModel(
        ottUserId: "31affff1-7eff-4743-a294-64efcd97c81a",
        username: "hao",
        phoneNumber: "1111111111",
        displayName: "hao"),
    ContactUserModel(
        ottUserId: "31affff1-7eff-4743-a294-64efcd97c81a",
        username: "hao",
        phoneNumber: "1111111111",
        displayName: "hao"),
    ContactUserModel(
        ottUserId: "31affff1-7eff-4743-a294-64efcd97c81a",
        username: "hao",
        phoneNumber: "1111111111",
        displayName: "hao"),
    ContactUserModel(
        ottUserId: "31affff1-7eff-4743-a294-64efcd97c81a",
        username: "hao",
        phoneNumber: "1111111111",
        displayName: "hao"),
    ContactUserModel(
        ottUserId: "31affff1-7eff-4743-a294-64efcd97c81a",
        username: "hao",
        phoneNumber: "1111111111",
        displayName: "hao"),
  ];

  @override
  Widget build(BuildContext context) {
    const title = 'Contacts cua Thanh';
    Singleton().connectServer(context);
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: 2 > 0
            ? ListView.separated(
                itemCount: arrUserContacts.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(' ${arrUserContacts[index].displayName} '),
                    onTap: () {
                      print(index);
                      socket.emit('NewRoom', {
                        "toUserId": '${arrUserContacts[index].ottUserId}',
                        "call_type": "video",
                        "name": "${arrUserContacts[index].displayName}",
                      });
                      pushToWaitingScreen(context);
                    }, // Handle your onTap here.
                  );
                },
              )
            : const Center(child: Text('No items')),
      ),
    );
  }
}

_joinMeeting() async {
  isCall = true;
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
  call_id = "322612779";
  var options = JitsiMeetingOptions(room: call_id)
    ..serverURL = "https://meeting9.mobifone.vn/"
    ..token =
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjb250ZXh0Ijp7InVzZXIiOnsiYXZhdGFyIjoiaHR0cHM6Ly9zbWFydG9mZmljZS5tb2JpZm9uZS52bi9pbWFnZXMvYXZhdGFyLzY4ODg2YzE5LTMwYTQtNGVmYy1hN2VhLTNlNTVlZDI0OGNjYi8xMzIwNjU3MjBfMzUwMzc3NTIyNjQwMzQ4NF82MjI2NTUzNTIzMDY2Mzg4NzQ4X24uanBlZyIsIm5hbWUiOiJUclx1MWVhN24gVlx1MDEwM24gSFx1MDBlMC1QTUdQS0gtVFRDTlRUIiwiZW1haWwiOiJoYS50cmFudmFuQG1vYmlmb25lLnZuIiwicGFzc3dvcmQiOiI4NDU1Iiwicm9vbV9uYW1lIjoiVGVzdCBPVFQiLCJ1cmwiOiJodHRwczovL3NtYXJ0b2ZmaWNlLm1vYmlmb25lLnZuL21lZXRpbmcvMzIyNjEyNzc5P3B3ZD05OTY5ZTU4MTc0NjdjMTFmZjE1NjM5ZDBlZDUxN2M3YSIsInJvb21fY29kZSI6IjMyMjYxMjc3OSIsInJlZGlyZWN0X3VybCI6Imh0dHBzOi8vc21hcnRvZmZpY2UubW9iaWZvbmUudm4vbWVldGluZyIsInNob3dfbXV0ZV9idG4iOiJZRVMiLCJzaG93X3NoYXJlX2J0biI6IllFUyIsInNob3dfdmlkZW9fYnRuIjoiWUVTIiwic2hvd19lbmRjYWxsX2J0biI6IllFUyIsImRlZmF1bHRfb25fdmlkZW8iOiJOTyIsImRlZmF1bHRfb25fYXVkaW8iOiJOTyJ9LCJvcHRpb25fY29kZSI6Ik9QRU4ifSwiYXVkIjoibW9iaW1lZXRpbmciLCJpc3MiOiJtb2JpbWVldGluZyIsInN1YiI6Imh0dHBzOi8vbWVldGluZzkubW9iaWZvbmUudm4iLCJyb29tIjoiMzIyNjEyNzc5IiwidXNlcl9pZCI6IjY4ODg2YzE5LTMwYTQtNGVmYy1hN2VhLTNlNTVlZDI0OGNjYiIsIm1vZGVyYXRvciI6dHJ1ZSwiaWF0IjoxNjM5MTMxMDIwLCJsb2NrX3N0YXJ0X2RhdGUiOm51bGwsInJvb21fbW9kZSI6Im5vcm1hbCIsInJvb21faWQiOjU1NjY3LCJyb29tX3VzZXJfaWQiOjc3NTQ0NCwicm9vbV9zZXNzaW9uX2lkIjoyMDAxNjJ9.u_zdjeUysmxL3jtuuSe2Dx0R79vgLqcPySihtgIwMbs"
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
