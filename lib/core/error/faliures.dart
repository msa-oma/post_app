import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class OfflineFaliure extends Failure {
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class EmptyCacheFaliure extends Failure {
  @override
  List<Object?> get props => [];
}
