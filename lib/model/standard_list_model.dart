import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'standard_list_model.g.dart';

@HiveType(typeId: 0)  // Define the typeId for Hive
@JsonSerializable(nullable: true)
class StandardListModels {
  @HiveField(0)
  @JsonKey(name: 'page')
  int? page;

  @HiveField(1)
  @JsonKey(name: 'per_page')
  int? per_page;

  @HiveField(2)
  @JsonKey(name: 'total')
  int? total;

  @HiveField(3)
  @JsonKey(name: 'total_pages')
  int? total_pages;

  @HiveField(4)
  List<Map<String, dynamic>>? data;

  StandardListModels(this.page, this.per_page, this.total, this.total_pages, this.data);

  factory StandardListModels.fromJson(Map<String, dynamic> json) =>
      _$StandardListModelsFromJson(json);

  Map<String, dynamic> toJson() => _$StandardListModelsToJson(this);

  StandardListModels.withError();
}
