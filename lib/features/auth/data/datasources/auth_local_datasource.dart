import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> login(String email, String password);
  Future<bool> logout();
  Future<UserModel?> getCurrentUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  // Simulamos usuarios predefinidos
  final List<Map<String, dynamic>> _users = [
    {
      'id': '1',
      'email': 'admin@elixirline.com',
      'password': 'admin123',
      'name': 'Administrador',
      'role': 'admin',
    },
    {
      'id': '2',
      'email': 'operador@elixirline.com',
      'password': 'operador123',
      'name': 'Operador de Campo',
      'role': 'operator',
    },
    {
      'id': '3',
      'email': 'supervisor@elixirline.com',
      'password': 'supervisor123',
      'name': 'Supervisor de Producción',
      'role': 'supervisor',
    },
  ];

  UserModel? _currentUser;

  @override
  Future<UserModel?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simular delay de red

    try {
      final userData = _users.firstWhere(
        (user) => user['email'] == email && user['password'] == password,
      );

      _currentUser = UserModel.fromJson(userData);
      return _currentUser;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
    return true;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _currentUser;
  }
}
