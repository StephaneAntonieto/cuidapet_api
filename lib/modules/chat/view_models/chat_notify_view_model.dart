import 'package:cuidapet_api/app/helpers/request_mapping.dart';

enum NotificationUserType { user, supplier }

class ChatNotifyViewModel extends RequestMapping {
  late int chat;
  late String message;
  late NotificationUserType notificationUserType;

  ChatNotifyViewModel(super.dataRequest);

  @override
  void map() {
    chat = data['chat'];
    message = data['message'];
    String notificationTypeRq = data['to'];
    notificationUserType = notificationTypeRq.toLowerCase() == 'u'
        ? NotificationUserType.user
        : NotificationUserType.supplier;
  }
}
