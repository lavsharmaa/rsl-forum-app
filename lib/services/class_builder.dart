import '../screens/admin/posts/post_list.dart';
import '../screens/events/post_list.dart';
import '../screens/contact_us/contact_us.dart';

typedef T Constructor<T>();

final Map<String, Constructor<Object>> _constructors =
    <String, Constructor<Object>>{};

void register<T>(Constructor<T> constructor) {
  _constructors[T.toString()] = constructor as Constructor<Object>;
}

class ClassBuilder {
  static void registerClasses() {
    register<Events>(() => Events());
    register<Discussions>(() => Discussions());
    register<ContactUs>(() => ContactUs());
  }

  static dynamic fromString(String type) {
    return _constructors[type]!();
  }
}
