import 'package:floor/floor.dart';

@Entity(tableName: "news")
class NewsEntity {

  @PrimaryKey(autoGenerate: true,)
  final int? id;
  final String userId;
  final String title;
  final String color;
  final String icon;
  final String status;
  final int createTime;
  final int updateTime;

  NewsEntity({
    this.id,
    this.userId = "",
    this.title = "",
    this.color = "",
    this.icon = "",
    this.status = "",
    this.createTime = 0,
    this.updateTime = 0,
  });

}