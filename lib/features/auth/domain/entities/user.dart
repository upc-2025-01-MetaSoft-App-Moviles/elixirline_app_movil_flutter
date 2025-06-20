import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String role;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? role,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
    );
  }

  @override
  List<Object> get props => [id, email, name, role];
}
