import 'package:ceo_events/models/message.dart';

class ChatViewModel {
  Message _message;

  ChatViewModel({Message message}) : this._message = message;

  String get content => _message.message;
  bool get isMy => _message.isMy;
  String get createdAt => _message.createdAt;
  bool get isImage => _message.isImage;
}
