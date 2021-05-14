enum Routes {
  HOME,
  PRE_LOGIN,
  LOGIN,
  SPLASH,
  CREATE_CHAT,
  CONTACT_SELECT,
  CREATE_GROUP_FORM,
  CHAT_ROOM,
}

extension RoutesExtension on Routes {
  String get path {
    return this.toString().split('.').last;
  }
}

const API_URL = 'http://hornbill.nikhilcodes.in:8000/api';
const WEB_SOCKET_URL = 'http://hornbill.nikhilcodes.in:8000';
