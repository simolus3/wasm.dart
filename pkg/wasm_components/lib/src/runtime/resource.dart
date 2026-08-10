sealed class ResourceHandle<T> {
  final int handle;

  new(this.handle);
}

final class Owned<T> extends ResourceHandle<T> {
  final void Function(int) _drop;

  new(super.handle, this._drop);

  void drop() {
    _drop(handle);
  }
}

final class Borrowed<T> extends ResourceHandle<T> {
  new(super.handle);
}
