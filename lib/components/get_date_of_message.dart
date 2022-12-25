import 'package:intl/intl.dart';

String GetDateOfMessage(String Date){
  var DayMap = {
    'Saturday':'Saturday',
    'Sunday':'Sunday',
    'Monday':'Monday',
    'Tuesday':'Tuesday',
    'Wednesday':'Wednesday',
    'Thursday':'Thursday',
    'Friday':'Friday',
  };
 DateTime MessageDate = DateTime.parse(Date);
  if(DateTime.now().difference(MessageDate).inDays < 1)
   return DateFormat('jm').format(MessageDate);
  else if(DateTime.now().difference(MessageDate).inDays < 7 )
    // return DayMap[DateFormat('MMMM').format(MessageDate).toString()]!;
    return DateTime.now().toString();

  else
    return DateFormat('yy/MM/dd').format(MessageDate);
}