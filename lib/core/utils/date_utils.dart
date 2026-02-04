import 'package:intl/intl.dart';

const String defaultDateFormat = 'dd MMM yyyy';

String formatDate(DateTime date, {format = defaultDateFormat}) {
  return DateFormat(format).format(date);
}
