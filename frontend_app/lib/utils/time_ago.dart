import 'package:easy_localization/easy_localization.dart';

String timeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return 'just_now'.tr();
  } else if (difference.inMinutes < 60) {
    return 'minutes_ago'.tr(namedArgs: {'count': difference.inMinutes.toString()});
  } else if (difference.inHours < 24) {
    return 'hours_ago'.tr(namedArgs: {'count': difference.inHours.toString()});
  } else {
    return 'days_ago'.tr(namedArgs: {'count': difference.inDays.toString()});
  }
}
