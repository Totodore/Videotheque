import 'dart:collection';

class Singletons {
  static HashMap<Type, Object> _map = new HashMap<Type, Object>();

  static T instance<T>() {
    return _map[T]; 
  }

  static registerSingleton<T>(T instance){
    _map[T] = instance;
  }
}