import 'package:flutter_test/flutter_test.dart';

class User {
  final String name;
  bool isActive;

  User({required this.name, this.isActive = false});
}

class UserService {
  final List<User> users = [];

  void addUser(String name) {
    users.add(User(name: name));
  }

  void activateUser(String name) {
    final user = users.firstWhere((u) => u.name == name);
    user.isActive = true;
  }
}

void main() {
  late UserService userService;

  setUp(() {
    userService = UserService();
  });

  test('should add and activate user', () {
    userService.addUser('John');
    userService.activateUser('John');

    final user = userService.users.first;
    expect(user.name, equals('John'));
    expect(user.isActive, isTrue);
  });
}
