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

const API_URL = 'https://hornbill.nikhilcodes.in/api';
const WEB_SOCKET_URL = 'https://hornbill.nikhilcodes.in:5000';

// const API_URL = 'http://10.0.2.2:8000/api';
// const WEB_SOCKET_URL = 'http://10.0.2.2:8001';
