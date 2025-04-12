import 'package:plant_game/core/errors/sqflite_error_model.dart';

class DatabaseException implements Exception {
  final SQFLiteErrorModel errorModel;
  DatabaseException(this.errorModel);
}

class ConstraintViolationException extends DatabaseException {
  ConstraintViolationException(super.errorModel);
}

class DatabaseClosedException extends DatabaseException {
  DatabaseClosedException(super.errorModel);
}

class ReadOnlyException extends DatabaseException {
  ReadOnlyException(super.errorModel);
}

class NoSuchTableException extends DatabaseException {
  NoSuchTableException(super.errorModel);
}

class SyntaxErrorException extends DatabaseException {
  SyntaxErrorException(super.errorModel);
}

class StorageFullException extends DatabaseException {
  StorageFullException(super.errorModel);
}

class ImageSaveException extends DatabaseException {
  ImageSaveException(super.errorModel);
}

class UnknownDatabaseException extends DatabaseException {
  UnknownDatabaseException(super.errorModel);
}

void handleSQFLiteException(dynamic e) {
  SQFLiteErrorModel defaultErrorModel = SQFLiteErrorModel(
    status: 600,
    errorMessage: e.toString(),
  );

  if (e is! DatabaseException) {
    throw UnknownDatabaseException(
      SQFLiteErrorModel(
        status: 600,
        errorMessage: 'Unexpected error: ${e.toString()}',
      ),
    );
  }

  String errorMessage = e.toString().toLowerCase();

  if (errorMessage.contains('sqlite_constraint')) {
    throw ConstraintViolationException(
      SQFLiteErrorModel(
        status: 601,
        errorMessage: 'Constraint violation: $errorMessage',
      ),
    );
  } else if (errorMessage.contains('database is closed')) {
    throw DatabaseClosedException(
      SQFLiteErrorModel(
        status: 602,
        errorMessage: 'Database is closed',
      ),
    );
  } else if (errorMessage.contains('readonly')) {
    throw ReadOnlyException(
      SQFLiteErrorModel(
        status: 603,
        errorMessage: 'Database is read-only',
      ),
    );
  } else if (errorMessage.contains('no such table')) {
    throw NoSuchTableException(
      SQFLiteErrorModel(
        status: 604,
        errorMessage: 'Table does not exist',
      ),
    );
  } else if (errorMessage.contains('syntax error')) {
    throw SyntaxErrorException(
      SQFLiteErrorModel(
        status: 605,
        errorMessage: 'SQL syntax error',
      ),
    );
  } else if (errorMessage.contains('database or disk is full')) {
    throw StorageFullException(
      SQFLiteErrorModel(
        status: 606,
        errorMessage: 'Storage is full',
      ),
    );
  } else {
    throw UnknownDatabaseException(
      SQFLiteErrorModel(
        status: 600,
        errorMessage: 'Unknown database error: $errorMessage',
      ),
    );
  }
}