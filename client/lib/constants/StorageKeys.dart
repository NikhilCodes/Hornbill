enum StorageKey {
  USER_ID,
  TOKEN,
}

extension ParseStorageKeyToStringValue on StorageKey {
  String get value {
    return this.toString().split('.').last;
  }
}