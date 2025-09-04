import 'dart:async';
import 'package:floor/floor.dart';
import 'package:tech_news/features/article_list/data/datasource/local/dao/article_dao.dart';
import 'package:tech_news/features/article_list/data/datasource/local/entity/article_entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
part 'database.g.dart';


@Database(
  version: 1,
  entities: [
    ArticleEntity,
  ],
)
abstract class AppDatabase extends FloorDatabase {
  ArticleDao get articleDao;
}
