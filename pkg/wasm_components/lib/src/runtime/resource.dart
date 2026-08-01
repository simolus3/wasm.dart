sealed class ResourceHandle<T> {
  final int handle;

  new(this.handle);
}

final class Owned<T> extends ResourceHandle<T> {
  new(super.handle);
}

final class Borrowed<T> extends ResourceHandle<T> {
  new(super.handle);
}
