import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../constants/exception_codes.dart';

class JajvmException extends Equatable implements Exception {
  final String message;
  final JajvmExceptionCode code;
  late final DateTime time;

  JajvmException({
    required this.message,
    required this.code,
    DateTime? time,
  }) {
    this.time = time ?? DateTime.now();
  }

  @override
  List<Object> get props => [message, code, time];

  @override
  String toString() =>
      'JajvmException(message: $message, code: $code, time: $time)';

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'code': code.name,
      'time': time.millisecondsSinceEpoch,
    };
  }

  factory JajvmException.fromMap(Map<String, dynamic> map) {
    return JajvmException(
      message: map['message'] ?? '',
      code: JajvmExceptionCode.values.byName(map['code']),
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
    );
  }

  String toJson() => json.encode(toMap());

  factory JajvmException.fromJson(String source) =>
      JajvmException.fromMap(json.decode(source));
}
