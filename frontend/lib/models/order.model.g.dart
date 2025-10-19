// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
  id: json['id'] as String,
  date: Order._dateTimeFromJson(json['date'] as String),
  status: json['status'] as String,
  total: (json['total'] as num).toDouble(),
  items: (json['items'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
  'id': instance.id,
  'date': Order._dateTimeToJson(instance.date),
  'status': instance.status,
  'total': instance.total,
  'items': instance.items,
};
