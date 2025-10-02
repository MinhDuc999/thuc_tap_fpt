import 'package:equatable/equatable.dart';

abstract class EditTodoEvent extends Equatable {
  const EditTodoEvent();
  @override
  List<Object?> get props => [];
}

class EditSubmit extends EditTodoEvent {
  const EditSubmit();
}