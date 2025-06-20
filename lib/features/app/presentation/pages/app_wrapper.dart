import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/blocs/auth/auth_bloc.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import 'home_page.dart';

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
        repository: AuthRepositoryImpl(
          localDataSource: AuthLocalDataSourceImpl(),
        ),
      )..add(CheckAuthStatus()),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          // Listener para manejar cambios de estado si es necesario
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthInitial || state is AuthLoading) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Color(0xFF8B0000),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Cargando...',
                      style: TextStyle(
                        color: Color(0xFF8B0000),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is AuthAuthenticated) {
            return HomePage(user: state.user);
          } else {
            // AuthUnauthenticated or AuthError
            return BlocProvider.value(
              value: context.read<AuthBloc>(),
              child: const LoginPage(),
            );
          }
        },
      ),
    );
  }
}
