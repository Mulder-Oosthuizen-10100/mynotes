// Login Exceptions
class UserNotFoundException implements Exception {}

class WrongPasswordException implements Exception {}

// Register Exceptions
class WeakPasswordException implements Exception {}

class EmailAlradyInUseException implements Exception {}

class InvalidEmailException implements Exception {}

// General Exceptions
class GeneralAuthException implements Exception {}

class UserNotLoggedInException implements Exception {}

class GeneralException implements Exception {}
