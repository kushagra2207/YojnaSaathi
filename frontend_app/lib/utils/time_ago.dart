import 'package:flutter/widgets.dart';
import 'package:easy_localization/easy_localization.dart';

String timeAgo(DateTime dateTime, [BuildContext? context]) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return context != null ? context.tr('just_now') : 'just_now'.tr();
  } else if (difference.inMinutes < 60) {
    final count = difference.inMinutes.toString();
    return context != null
        ? context.tr('minutes_ago', namedArgs: {'count': count})
        : 'minutes_ago'.tr(namedArgs: {'count': count});
  } else if (difference.inHours < 24) {
    final count = difference.inHours.toString();
    return context != null
        ? context.tr('hours_ago', namedArgs: {'count': count})
        : 'hours_ago'.tr(namedArgs: {'count': count});
  } else {
    final count = difference.inDays.toString();
    return context != null
        ? context.tr('days_ago', namedArgs: {'count': count})
        : 'days_ago'.tr(namedArgs: {'count': count});
  }
}
