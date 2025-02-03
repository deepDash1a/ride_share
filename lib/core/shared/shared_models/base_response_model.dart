import 'package:equatable/equatable.dart';

class BaseResponseModel<T> extends Equatable {
  final String? status;
  final String? message;
  final String? token;
  final T? body;

  const BaseResponseModel({
    required this.status,
    required this.message,
    this.token,
    this.body,
  });

  factory BaseResponseModel.fromJson(Map<String, dynamic> json) {
    return BaseResponseModel(
      status: json['status'],
      message: json['message'],
      token: json['token'],
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        token,
        T,
      ];
}

class BaseResponseModel2<T> extends Equatable {
  final bool? status;
  final String? message;
  final String? token;
  final T? body;

  const BaseResponseModel2({
    required this.status,
    required this.message,
    this.token,
    this.body,
  });

  factory BaseResponseModel2.fromJson(Map<String, dynamic> json) {
    return BaseResponseModel2(
      status: json['status'],
      message: json['message'],
      token: json['token'],
    );
  }

  @override
  List<Object?> get props => [
        status,
        message,
        token,
        T,
      ];
}
