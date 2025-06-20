import '../../domain/entities/user.dart';
import '../datasources/auth_local_datasource.dart';

abstract class AuthRepository {
  Future<User?> login(String email, String password);
  Future<bool> logout();
  Future<User?> getCurrentUser();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<User?> login(String email, String password) async {
    try {
      final user = await localDataSource.login(email, password);
      return user;
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  @override
  Future<bool> logout() async {
    try {
      return await localDataSource.logout();
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final user = await localDataSource.getCurrentUser();
      return user;
    } catch (e) {
      throw Exception('Error al obtener usuario actual: $e');
    }
  }
}
