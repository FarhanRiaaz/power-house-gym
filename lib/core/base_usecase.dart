import 'package:flutter/foundation.dart';

/// Abstract base class for all Use Cases in the application.
/// 
/// [Type] is the expected return type of the use case (e.g., List<Member>).
/// [Params] is the input parameter type required by the use case (e.g., int, String, Member, or void).
abstract class UseCase<Type, Params> {
  /// Executes the core business logic defined by the use case.
  @mustCallSuper
  Future<Type> call({required Params params});
}

/// Helper class for use cases that do not require any parameters.
class NoParams {}
