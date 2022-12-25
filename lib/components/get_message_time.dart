import 'package:intl/intl.dart';

String GetMessageTime(DateTime MessageTime){
  return DateFormat('jm').format(MessageTime);
}