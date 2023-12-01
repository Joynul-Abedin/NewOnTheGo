import 'package:news_on_the_go/generated/json/base/json_field.dart';
import 'package:news_on_the_go/generated/json/new_article_entity.g.dart';
import 'dart:convert';
export 'package:news_on_the_go/generated/json/new_article_entity.g.dart';

@JsonSerializable()
class NewArticleEntity {
	@JSONField(name: "_id")
	String? id = '';
	String? title = '';
	String? link = '';
	String? image = '';
	String? source = '';
	String? category = '';
	String? dateFetched = '';
	@JSONField(name: "__v")
	double? v;

	NewArticleEntity();

	factory NewArticleEntity.fromJson(Map<String, dynamic> json) => $NewArticleEntityFromJson(json);

	Map<String, dynamic> toJson() => $NewArticleEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}