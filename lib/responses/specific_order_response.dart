// ignore_for_file: use_super_parameters

import 'package:rider/models/orders.dart';
import 'package:rider/responses/base_responses/base_response.dart';

class SpecificOrderResponse extends BaseResponse {
  Body? body;

  SpecificOrderResponse(success, error, {this.body})
      : super(success, error: error);

  SpecificOrderResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    success = json['success'];
    error = json['error'];
    body = json['body'] != null ? Body.fromJson(json['body']) : null;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    if (body != null) {
      data['body'] = body!.toJson();
    }
    return data;
  }
}

class Body {
  Orders? orders;

  Body({this.orders});

  Body.fromJson(Map<String, dynamic> json) {
    orders = json['orders'] != null ? Orders.fromJson(json['orders']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (orders != null) {
      data['orders'] = orders!.toJson();
    }
    return data;
  }
}
