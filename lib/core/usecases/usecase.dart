import '../utils/result.dart';

/// Standard use-case contract: one public method, takes Params, returns
/// a Result so blocs never touch Firebase types directly.
abstract class UseCase<Type, Params> {
  Future<Result<Type>> call(Params params);
}

/// Marker for use cases that take no parameters.
class NoParams {
  const NoParams();
}