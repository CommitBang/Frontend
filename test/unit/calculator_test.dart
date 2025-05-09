import 'package:flutter_test/flutter_test.dart';

int add(int a, int b) => a + b;
int subtract(int a, int b) => a - b;
int multiply(int a, int b) => a * b;
double divide(int a, int b) => a / b;

void main() {
  test('adds two numbers correctly', () {
    expect(add(2, 3), equals(5));
  });

  group('Calculator Tests', () {
    test('subtracts two numbers correctly', () {
      expect(subtract(5, 3), equals(2));
      expect(subtract(1, 1), equals(0));
      expect(subtract(0, 5), equals(-5));
    });

    test('multiplies two numbers correctly', () {
      expect(multiply(2, 3), equals(6));
      expect(multiply(-2, 3), equals(-6));
      expect(multiply(0, 5), equals(0));
    });

    test('divides two numbers correctly', () {
      expect(divide(6, 2), equals(3.0));
      expect(divide(5, 2), equals(2.5));
      expect(divide(0, 5), equals(0.0));
    });
  });
}
