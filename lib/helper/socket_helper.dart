import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:mobi_call/mobifone_helper/call_listener.dart';
import 'package:mobi_call/mobifone_helper/mobifone_helper.dart';
import 'package:mobi_call/models/SignalResponModel.dart';
import '../config/config.dart';
import '../config/globals.dart';
import 'package:socket_io_client/socket_io_client.dart';

class MobifoneClient {

  MobifoneHelperListener? mobifoneHelperListener;
  CallListener? callListener;


  static final MobifoneClient _singleton = MobifoneClient._internal();

  factory MobifoneClient() {
    return _singleton;
  }

  MobifoneClient._internal();

  Socket socket = io(
      Config.socketUrl,
      OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setQuery({'jwt': Config.jwt_token})
          .build());

  void connectServer(context) {
    socket.connect();

    socket.onConnect((data) {
      print("onConnect in plugin");
      mobifoneHelperListener?.onConnectionConnect();
    });

    socket.onDisconnect((data) {
      print("onDisconnect in plugin");
      mobifoneHelperListener?.onConnectionError();
    });

    // socket.on("NewCall:Response", (data) {
    //   data.forEach((key, value) {
    //     if (key == "call_id") {
    //       call_id = value;
    //     }
    //     if (key == "fromUserName") {
    //       fromUserName = value;
    //     }
    //   });
    //   callListener?.onSignalingStateChange(Config().EVENT_CALLING);
    // });

    socket.on("NewCall:Response", (res) {
      var model = SignalResponModel.fromJson(res);
      switch (model.r) {
        case 0:
          callListener?.onError(model.error);
          break;
        case 1:
          fromUser = model.data.from_user.toString();
          toUser = model.data.to_user.toString();
          toHotline = model.data.to_hotline.toString();

          if (requestId == model.data.request_id) {
            callListener?.onSignalingStateChange(Config.EVENT_CALLING, model);
          } else {
            requestId = model.data.request_id;
            callListener?.onSignalingStateChange(Config.EVENT_RINGING, model);
          }
          break;
        case 2:
          requestId = model.data.request_id;
          roomId = model.data.room_id.toString();
          fromUser = model.data.from_user.toString();
          toUser = model.data.to_user.toString();

          callListener?.onSignalingStateChange(Config.EVENT_ACCEPT, model);
          break;
        case 3:
          callListener?.onSignalingStateChange(Config.EVENT_REJECT, model);
          break;
        case 4:
          callListener?.onSignalingStateChange(Config.EVENT_MISS, model);
          break;
        case 5:
          callListener?.onSignalingStateChange(Config.EVENT_CANCEL, model);
          break;
        case 6:
          requestId = model.data.request_id;
          break;
      }

    });

    // socket.on("CancelCall:Response", (res) {
    //   var model = SignalResponModel.fromJson(res);
    //   if (model.r == 0) {
    //     callListener?.onError(model.error);
    //   } else {
    //     callListener?.onSignalingStateChange(Config.EVENT_CANCEL, model);
    //   }
    //
    // });
    //
    // socket.on("RejectCall:Response", (res) {
    //   var model = SignalResponModel.fromJson(res);
    //   if (model.r == 0) {
    //     callListener?.onError(model.error);
    //   } else {
    //     callListener?.onSignalingStateChange(Config.EVENT_REJECT, model);
    //   }
    //
    // });
    //
    // socket.on("AcceptCall:Response", (res) {
    //   var model = SignalResponModel.fromJson(res);
    //   if (model.r == 0) {
    //     callListener?.onError(model.error);
    //   } else {
    //     callListener?.onSignalingStateChange(Config.EVENT_ACCEPT, model);
    //   }
    //
    // });

    socket.on("EndCall:Response", (res) {
      var model = SignalResponModel.fromJson(res);
      if (model.r == 0) {
        callListener?.onError(model.error);
      } else {
        callListener?.onSignalingStateChange(Config.EVENT_END, model);
      }

    });

    // socket.on("MISS", (res) {
    //   var model = SignalResponModel.fromJson(res);
    //   if (model.r == 0) {
    //     callListener?.onError(model.error);
    //   } else {
    //     callListener?.onSignalingStateChange(Config.EVENT_MISS, model);
    //   }
    //
    // });
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
      featureFlags[FeatureFlagEnum.IOS_RECORDING_ENABLED] = true;
      featureFlags[FeatureFlagEnum.MEETING_NAME_ENABLED] = false;
      featureFlags[FeatureFlagEnum.MEETING_PASSWORD_ENABLED] = false;
      featureFlags[FeatureFlagEnum.PIP_ENABLED] = false;
      featureFlags[FeatureFlagEnum.RAISE_HAND_ENABLED] = false;
      featureFlags[FeatureFlagEnum.RECORDING_ENABLED] = true;
      featureFlags[FeatureFlagEnum.TILE_VIEW_ENABLED] = false;
      featureFlags[FeatureFlagEnum.TOOLBOX_ALWAYS_VISIBLE] = false;
      featureFlags[FeatureFlagEnum.WELCOME_PAGE_ENABLED] = false;
    }
    // Define meetings options here
    // thanh
    var options = JitsiMeetingOptions(room: roomId)
      ..serverURL = serverString
      ..token = tokenString
      ..subject = ""
      ..userDisplayName = fromUser
      ..userEmail = ""
      ..iosAppBarRGBAColor = ""
      ..featureFlags.addAll(featureFlags)
      ..webOptions = {
        "roomName": roomId,
        "width": "100%",
        "height": "100%",
        "enableWelcomePage": false,
        "chromeExtensionBanner": null,
        "userInfo": {"displayName": fromUser}
      };

    debugPrint("JitsiMeetingOptions: $options");
    await JitsiMeet.joinMeeting(
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
            endCall();
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

  closeMeeting() {
    JitsiMeet.closeMeeting();
  }

  makeCall(String? to_hotline_code, dynamic custom_data,String? to_user, String call_type) {
    socket.emit('NewCall', {
      "to_hotline_code": to_hotline_code,
      "custom_data": custom_data,
      "to_user": to_user,
      "call_type": call_type
    });
  }

  cancelCall() {
    socket.emit('CancelCall', {
      "request_id": requestId
    });
  }

  rejectCall() {
    socket.emit('RejectCall', {
      "request_id": requestId
    });
  }

  endCall() {
    socket.emit('EndCall', {

    });
  }

  acceptCall() {
    socket.emit('AcceptCall', {
      "request_id": requestId
    });
  }
}





