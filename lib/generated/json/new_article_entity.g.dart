import 'package:news_on_the_go/generated/json/base/json_convert_content.dart';
import 'package:news_on_the_go/Models/new_article_entity.dart';

NewArticleEntity $NewArticleEntityFromJson(Map<String, dynamic> json) {
  final NewArticleEntity newArticleEntity = NewArticleEntity();
  final String? id = jsonConvert.convert<String>(json['_id']);
  if (id != null) {
    newArticleEntity.id = id;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    newArticleEntity.title = title;
  }
  final String? link = jsonConvert.convert<String>(json['link']);
  if (link != null) {
    newArticleEntity.link = link;
  }
  final String? image = jsonConvert.convert<String>(json['image']);
  if (image != null) {
    newArticleEntity.image = image;
  }
  final String? source = jsonConvert.convert<String>(json['source']);
  if (source != null) {
    newArticleEntity.source = source;
  }
  final String? category = jsonConvert.convert<String>(json['category']);
  if (category != null) {
    newArticleEntity.category = category;
  }
  final String? dateFetched = jsonConvert.convert<String>(json['dateFetched']);
  if (dateFetched != null) {
    newArticleEntity.dateFetched = dateFetched;
  }
  final double? v = jsonConvert.convert<double>(json['__v']);
  if (v != null) {
    newArticleEntity.v = v;
  }
  return newArticleEntity;
}

Map<String, dynamic> $NewArticleEntityToJson(NewArticleEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['_id'] = entity.id;
  data['title'] = entity.title;
  data['link'] = entity.link;
  data['image'] = entity.image;
  data['source'] = entity.source;
  data['category'] = entity.category;
  data['dateFetched'] = entity.dateFetched;
  data['__v'] = entity.v;
  return data;
}

extension NewArticleEntityExtension on NewArticleEntity {
  NewArticleEntity copyWith({
    String? id,
    String? title,
    String? link,
    String? image,
    String? source,
    String? category,
    String? dateFetched,
    double? v,
  }) {
    return NewArticleEntity()
      ..id = id ?? this.id
      ..title = title ?? this.title
      ..link = link ?? this.link
      ..image = image ?? this.image
      ..source = source ?? this.source
      ..category = category ?? this.category
      ..dateFetched = dateFetched ?? this.dateFetched
      ..v = v ?? this.v;
  }
}