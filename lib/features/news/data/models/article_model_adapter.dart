import 'package:hive_flutter/hive_flutter.dart';
import 'article_model.dart';

class ArticleModelAdapter extends TypeAdapter<ArticleModel> {
  @override
  final int typeId = 0;

  @override
  ArticleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ArticleModel(
      modelTitle: fields[0] as String,
      modelDescription: fields[1] as String,
      modelUrl: fields[2] as String,
      modelUrlToImage: (fields[3] as String?) ?? '',
      modelPublishedAt: (fields[4] as String?) ?? '',
      modelSourceName: (fields[5] as String?) ?? '',
      modelContent: (fields[6] as String?) ?? 'No extra content available.',
    );
  }

  @override
  void write(BinaryWriter writer, ArticleModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.modelTitle)
      ..writeByte(1)
      ..write(obj.modelDescription)
      ..writeByte(2)
      ..write(obj.modelUrl)
      ..writeByte(3)
      ..write(obj.modelUrlToImage)
      ..writeByte(4)
      ..write(obj.modelPublishedAt)
      ..writeByte(5)
      ..write(obj.modelSourceName)
      ..writeByte(6)
      ..write(obj.modelContent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticleModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
