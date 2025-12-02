
abstract interface class IDataAccessor<TEntity> {
  dynamic getValue(TEntity entity, String key);
}

