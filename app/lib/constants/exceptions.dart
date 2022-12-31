abstract class SokutwiError implements Exception {
  final String message;

  const SokutwiError(this.message);
}

class UnauthorizedError implements SokutwiError {
  @override
  final String message = 'ログインし直してください。';

  const UnauthorizedError();
}
