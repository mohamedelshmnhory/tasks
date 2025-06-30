enum TaskStatus {
  todo(0, 'todo'),
  doing(1, 'doing'),
  done(2, 'done'),
  canceled(3, 'canceled');

  final String name;
  final int value;
  const TaskStatus(this.value, this.name);
}
