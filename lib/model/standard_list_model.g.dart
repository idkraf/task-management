// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'standard_list_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StandardListModelsAdapter extends TypeAdapter<StandardListModels> {
  @override
  final int typeId = 0;

  @override
  StandardListModels read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StandardListModels(
      fields[0] as int?,
      fields[1] as int?,
      fields[2] as int?,
      fields[3] as int?,
      (fields[4] as List?)
          ?.map((dynamic e) => (e as Map).cast<String, dynamic>())
          ?.toList(),
    );
  }

  @override
  void write(BinaryWriter writer, StandardListModels obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.page)
      ..writeByte(1)
      ..write(obj.per_page)
      ..writeByte(2)
      ..write(obj.total)
      ..writeByte(3)
      ..write(obj.total_pages)
      ..writeByte(4)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StandardListModelsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StandardListModels _$StandardListModelsFromJson(Map<String, dynamic> json) =>
    StandardListModels(
      (json['page'] as num?)?.toInt(),
      (json['per_page'] as num?)?.toInt(),
      (json['total'] as num?)?.toInt(),
      (json['total_pages'] as num?)?.toInt(),
      (json['data'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$StandardListModelsToJson(StandardListModels instance) =>
    <String, dynamic>{
      'page': instance.page,
      'per_page': instance.per_page,
      'total': instance.total,
      'total_pages': instance.total_pages,
      'data': instance.data,
    };
