import 'package:ride_share/core/shared/shared_models/base_response_model.dart';

class GeneralAdminMessagesModel
    extends BaseResponseModel<List<AdminMessagesModel>> {
  const GeneralAdminMessagesModel({
    required super.status,
    required super.message,
    super.body,
  });

  factory GeneralAdminMessagesModel.fromJson(Map<String, dynamic> json) {
    return GeneralAdminMessagesModel(
      status: json['status'],
      message: json['message'],
      body: List<AdminMessagesModel>.from(
          json['data'].map((e) => AdminMessagesModel.fromJson(e))).toList(),
    );
  }
}


class AdminMessagesModel {
  int? id;
  String? content;
  String? priority;
  bool? read;
  int? userId;
  String? date;
  String? createdAt;
  String? updatedAt;

  AdminMessagesModel({
    this.id,
    this.content,
    this.priority,
    this.read,
    this.userId,
    this.date,
    this.createdAt,
    this.updatedAt,
  });

  AdminMessagesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    priority = json['priority'];
    read = json['read'];
    userId = json['user_id'];
    date = json['date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['content'] = content;
    data['priority'] = priority;
    data['read'] = read;
    data['user_id'] = userId;
    data['date'] = date;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
