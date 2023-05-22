// if image url not start with http://, 
import 'package:local_biz/config.dart';

String getImgUrl(String url) {
  if (url.startsWith('http://') || url.startsWith('https://')) {
    return url;
  }
  return '$fileUrl/$url';
}
