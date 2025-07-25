import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'package:logger/logger.dart';

export 'dart:math' show min, max;
export 'package:intl/intl.dart';
export 'package:page_transition/page_transition.dart';

// Logging utilities
class JMPLogger {
  static final logger = Logger();

  static void debug(String message) => logger.d(message);
  static void info(String message) => logger.i(message);
  static void warning(String message) => logger.w(message);
  static void error(String message, [dynamic error, StackTrace? stackTrace]) => 
      logger.e(message, error: error, stackTrace: stackTrace);
}

// URL utilities
class UrlUtil {
  static Future<void> launchURL(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      JMPLogger.error('Error launching URL', e);
      throw 'Could not launch $url: $e';
    }
  }

  static bool isValidUrl(String urlString) {
    try {
      final url = Uri.parse(urlString);
      return url.hasScheme && url.hasAuthority;
    } catch (_) {
      return false;
    }
  }
}

// Keep your existing formatting enums and functions
enum FormatType {
  decimal,
  percent,
  scientific,
  compact,
  compactLong,
  custom,
}

// T valueOrDefault<T>(T value, T defaultValue) =>
//     (value is String && value.isEmpty) || value == null ? defaultValue : value;

T valueOrDefault<T>(T? value, T defaultValue) {
  try {
    if (value == null) return defaultValue;
    if (value is String && value.isEmpty) return defaultValue;
    return value;
  } catch (e) {
    JMPLogger.error('Error in valueOrDefault', e);
    return defaultValue;
  }
}

String dateTimeFormat(String format, DateTime dateTime) {
  if (format == 'relative') {
    return timeago.format(dateTime);
  }
  return DateFormat(format).format(dateTime);
}

Future launchURL(String url) async {
  final uri = Uri.parse(url);
  try {
    await launchUrl(uri);
  } catch (e) {
    throw 'Could not launch $uri: $e';
  }
}

// enum FormatType {
//   decimal,
//   percent,
//   scientific,
//   compact,
//   compactLong,
//   custom,
// }

enum DecimalType {
  automatic,
  periodDecimal,
  commaDecimal,
}

String formatNumber(
  num value, {
  required FormatType formatType,
  required DecimalType decimalType,
  String? currency,
  bool toLowerCase = false,
  String? format,
  String? locale,
}) {
  var formattedValue = '';
  switch (formatType) {
    case FormatType.decimal:
      switch (decimalType) {
        case DecimalType.automatic:
          formattedValue = NumberFormat.decimalPattern().format(value);
          break;
        case DecimalType.periodDecimal:
          formattedValue = NumberFormat.decimalPattern('en_US').format(value);
          break;
        case DecimalType.commaDecimal:
          formattedValue = NumberFormat.decimalPattern('es_PA').format(value);
          break;
      }
      break;
    case FormatType.percent:
      formattedValue = NumberFormat.percentPattern().format(value);
      break;
    case FormatType.scientific:
      formattedValue = NumberFormat.scientificPattern().format(value);
      if (toLowerCase) {
        formattedValue = formattedValue.toLowerCase();
      }
      break;
    case FormatType.compact:
      formattedValue = NumberFormat.compact().format(value);
      break;
    case FormatType.compactLong:
      formattedValue = NumberFormat.compactLong().format(value);
      break;
    case FormatType.custom:
      final hasLocale = locale != null && locale.isNotEmpty;
      formattedValue =
          NumberFormat(format, hasLocale ? locale : null).format(value);
  }

  if (formattedValue.isEmpty) {
    return value.toString();
  }

  if (currency != null) {
    final currencySymbol = currency.isNotEmpty
        ? currency
        : NumberFormat.simpleCurrency().format(0.0).substring(0, 1);
    formattedValue = '$currencySymbol$formattedValue';
  }

  return formattedValue;
}

DateTime get getCurrentTimestamp => DateTime.now();

extension DateTimeComparisonOperators on DateTime {
  bool operator <(DateTime other) => isBefore(other);

  bool operator >(DateTime other) => isAfter(other);

  bool operator <=(DateTime other) => this < other || isAtSameMomentAs(other);

  bool operator >=(DateTime other) => this > other || isAtSameMomentAs(other);
}

// dynamic getJsonField(dynamic response, String jsonPath) {
//   final field = JsonPath(jsonPath).read(response);
//   return field.isNotEmpty
//       ? field.length > 1
//           ? field.map((f) => f.value).toList()
//           : field.first.value
//       : null;
// }

bool get isAndroid => !kIsWeb && Platform.isAndroid;

void showSnackbar(
  BuildContext context,
  String message, {
  bool loading = false,
  int duration = 4,
  SnackBarBehavior behavior = SnackBarBehavior.floating,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          if (loading)
            const Padding(
              padding: EdgeInsetsDirectional.only(end: 10.0),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          // 
          Expanded(child: Text(message)),
        ],
      ),
      duration: Duration(seconds: duration),
      behavior: behavior,
    ),
  );
}

extension FFStringExt on String {
  String maybeHandleOverflow({int? maxChars, String replacement = ''}) =>
      maxChars != null && length > maxChars
          ? replaceRange(maxChars, null, replacement)
          : this;
}

final logger = Logger();