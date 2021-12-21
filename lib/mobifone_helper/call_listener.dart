
import 'package:mobi_call/models/SignalResponModel.dart';

abstract class CallListener {
  onSignalingStateChange(String state, SignalResponModel model);
  onError(String? message);
}