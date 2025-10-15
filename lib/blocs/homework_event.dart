import '../models/homework.dart';

abstract class HomeworkEvent {}

class AddHomework extends HomeworkEvent {
  final Homework homework;
  AddHomework(this.homework);
}

class DeleteHomework extends HomeworkEvent {
  final int index;
  DeleteHomework(this.index);
}

class ToggleHomework extends HomeworkEvent {
  final int index;
  ToggleHomework(this.index);
}
