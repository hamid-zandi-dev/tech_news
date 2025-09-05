// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ArticleDao? _articleDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `articles` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `sourceId` TEXT NOT NULL, `sourceName` TEXT NOT NULL, `author` TEXT NOT NULL, `title` TEXT NOT NULL, `description` TEXT NOT NULL, `url` TEXT NOT NULL, `urlToImage` TEXT NOT NULL, `publishedAt` TEXT NOT NULL, `content` TEXT NOT NULL, `queryTitle` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ArticleDao get articleDao {
    return _articleDaoInstance ??= _$ArticleDao(database, changeListener);
  }
}

class _$ArticleDao extends ArticleDao {
  _$ArticleDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _articleEntityInsertionAdapter = InsertionAdapter(
            database,
            'articles',
            (ArticleEntity item) => <String, Object?>{
                  'id': item.id,
                  'sourceId': item.sourceId,
                  'sourceName': item.sourceName,
                  'author': item.author,
                  'title': item.title,
                  'description': item.description,
                  'url': item.url,
                  'urlToImage': item.urlToImage,
                  'publishedAt': item.publishedAt,
                  'content': item.content,
                  'queryTitle': item.queryTitle
                },
            changeListener),
        _articleEntityUpdateAdapter = UpdateAdapter(
            database,
            'articles',
            ['id'],
            (ArticleEntity item) => <String, Object?>{
                  'id': item.id,
                  'sourceId': item.sourceId,
                  'sourceName': item.sourceName,
                  'author': item.author,
                  'title': item.title,
                  'description': item.description,
                  'url': item.url,
                  'urlToImage': item.urlToImage,
                  'publishedAt': item.publishedAt,
                  'content': item.content,
                  'queryTitle': item.queryTitle
                },
            changeListener),
        _articleEntityDeletionAdapter = DeletionAdapter(
            database,
            'articles',
            ['id'],
            (ArticleEntity item) => <String, Object?>{
                  'id': item.id,
                  'sourceId': item.sourceId,
                  'sourceName': item.sourceName,
                  'author': item.author,
                  'title': item.title,
                  'description': item.description,
                  'url': item.url,
                  'urlToImage': item.urlToImage,
                  'publishedAt': item.publishedAt,
                  'content': item.content,
                  'queryTitle': item.queryTitle
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ArticleEntity> _articleEntityInsertionAdapter;

  final UpdateAdapter<ArticleEntity> _articleEntityUpdateAdapter;

  final DeletionAdapter<ArticleEntity> _articleEntityDeletionAdapter;

  @override
  Stream<List<ArticleEntity>> getAllArticles() {
    return _queryAdapter.queryListStream('SELECT * FROM articles',
        mapper: (Map<String, Object?> row) => ArticleEntity(
            id: row['id'] as int?,
            sourceId: row['sourceId'] as String,
            sourceName: row['sourceName'] as String,
            author: row['author'] as String,
            title: row['title'] as String,
            description: row['description'] as String,
            url: row['url'] as String,
            urlToImage: row['urlToImage'] as String,
            publishedAt: row['publishedAt'] as String,
            content: row['content'] as String,
            queryTitle: row['queryTitle'] as String),
        queryableName: 'articles',
        isView: false);
  }

  @override
  Stream<List<ArticleEntity>> getArticlesWithPaging(
    String to,
    String from,
    int page,
    int pageLimit,
  ) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM articles      WHERE publishedAt <= ?1 AND publishedAt > ?2      ORDER BY publishedAt      LIMIT ?4      OFFSET (?3 - 1) * ?4',
        mapper: (Map<String, Object?> row) => ArticleEntity(
            id: row['id'] as int?,
            sourceId: row['sourceId'] as String,
            sourceName: row['sourceName'] as String,
            author: row['author'] as String,
            title: row['title'] as String,
            description: row['description'] as String,
            url: row['url'] as String,
            urlToImage: row['urlToImage'] as String,
            publishedAt: row['publishedAt'] as String,
            content: row['content'] as String,
            queryTitle: row['queryTitle'] as String),
        arguments: [to, from, page, pageLimit],
        queryableName: 'articles',
        isView: false);
  }

  @override
  Future<List<ArticleEntity>> getArticlesWithPagingAndQuery(
    String query,
    String to,
    String from,
    int page,
    int pageLimit,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM articles      WHERE publishedAt <= ?2 AND publishedAt > ?3 AND queryName = ?1      ORDER BY publishedAt      LIMIT ?5      OFFSET (?4 - 1) * ?5',
        mapper: (Map<String, Object?> row) => ArticleEntity(id: row['id'] as int?, sourceId: row['sourceId'] as String, sourceName: row['sourceName'] as String, author: row['author'] as String, title: row['title'] as String, description: row['description'] as String, url: row['url'] as String, urlToImage: row['urlToImage'] as String, publishedAt: row['publishedAt'] as String, content: row['content'] as String, queryTitle: row['queryTitle'] as String),
        arguments: [query, to, from, page, pageLimit]);
  }

  @override
  Future<List<ArticleEntity>> getArticlesWithQuery(
    String query,
    String to,
    String from,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM articles      WHERE publishedAt <= ?2 AND publishedAt > ?3 AND queryName = ?1      ORDER BY publishedAt',
        mapper: (Map<String, Object?> row) => ArticleEntity(id: row['id'] as int?, sourceId: row['sourceId'] as String, sourceName: row['sourceName'] as String, author: row['author'] as String, title: row['title'] as String, description: row['description'] as String, url: row['url'] as String, urlToImage: row['urlToImage'] as String, publishedAt: row['publishedAt'] as String, content: row['content'] as String, queryTitle: row['queryTitle'] as String),
        arguments: [query, to, from]);
  }

  @override
  Future<List<ArticleEntity>> getArticlesWithTitle(
    String title,
    String to,
    String from,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM articles      WHERE publishedAt <= ?2 AND publishedAt > ?3 AND title = ?1      ORDER BY publishedAt',
        mapper: (Map<String, Object?> row) => ArticleEntity(id: row['id'] as int?, sourceId: row['sourceId'] as String, sourceName: row['sourceName'] as String, author: row['author'] as String, title: row['title'] as String, description: row['description'] as String, url: row['url'] as String, urlToImage: row['urlToImage'] as String, publishedAt: row['publishedAt'] as String, content: row['content'] as String, queryTitle: row['queryTitle'] as String),
        arguments: [title, to, from]);
  }

  @override
  Future<ArticleEntity?> getArticleById(String articleId) async {
    return _queryAdapter.query('SELECT * FROM articles      WHERE id = ?1',
        mapper: (Map<String, Object?> row) => ArticleEntity(
            id: row['id'] as int?,
            sourceId: row['sourceId'] as String,
            sourceName: row['sourceName'] as String,
            author: row['author'] as String,
            title: row['title'] as String,
            description: row['description'] as String,
            url: row['url'] as String,
            urlToImage: row['urlToImage'] as String,
            publishedAt: row['publishedAt'] as String,
            content: row['content'] as String,
            queryTitle: row['queryTitle'] as String),
        arguments: [articleId]);
  }

  @override
  Future<int?> getArticlesCount() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM articles',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int> insertArticle(ArticleEntity articleEntity) {
    return _articleEntityInsertionAdapter.insertAndReturnId(
        articleEntity, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertArticles(List<ArticleEntity> entities) async {
    await _articleEntityInsertionAdapter.insertList(
        entities, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateArticle(ArticleEntity articleEntity) {
    return _articleEntityUpdateAdapter.updateAndReturnChangedRows(
        articleEntity, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteArticle(ArticleEntity articleEntity) async {
    await _articleEntityDeletionAdapter.delete(articleEntity);
  }
}
