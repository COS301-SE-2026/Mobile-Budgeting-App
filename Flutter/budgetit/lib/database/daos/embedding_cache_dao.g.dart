// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'embedding_cache_dao.dart';

// ignore_for_file: type=lint
mixin _$EmbeddingCacheDaoMixin on DatabaseAccessor<AppDatabase> {
  $EmbeddingCacheEntriesTable get embeddingCacheEntries =>
      attachedDatabase.embeddingCacheEntries;
  EmbeddingCacheDaoManager get managers => EmbeddingCacheDaoManager(this);
}

class EmbeddingCacheDaoManager {
  final _$EmbeddingCacheDaoMixin _db;
  EmbeddingCacheDaoManager(this._db);
  $$EmbeddingCacheEntriesTableTableManager get embeddingCacheEntries =>
      $$EmbeddingCacheEntriesTableTableManager(
        _db.attachedDatabase,
        _db.embeddingCacheEntries,
      );
}
