import 'dart:convert';

import 'package:equatable/equatable.dart';

class JajvmException extends Equatable implements Exception {
  final String message;
  final String code;
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
  String toString() => 'JajvmException(message: $message, code: $code, time: $time)';

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'code': code,
      'time': time.millisecondsSinceEpoch,
    };
  }

  factory JajvmException.fromMap(Map<String, dynamic> map) {
    return JajvmException(
      message: map['message'] ?? '',
      code: map['code'] ?? '',
      time: DateTime.fromMillisecondsSinceEpoch(map['time']),
    );
  }

  String toJson() => json.encode(toMap());

  factory JajvmException.fromJson(String source) => JajvmException.fromMap(json.decode(source));
}
