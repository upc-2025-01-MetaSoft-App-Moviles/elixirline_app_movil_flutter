import 'package:flutter/material.dart';
import '../../../auth/domain/entities/user.dart';
import '../pages/home_page.dart';

class AppDrawer extends StatelessWidget {
  final User user;
  final AppSection currentSection;
  final Function(AppSection) onSectionSelected;
  final VoidCallback onLogout;

  const AppDrawer({
    super.key,
    required this.user,
    required this.currentSection,
    required this.onSectionSelected,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF8B0000),
            ),
            accountName: Text(
              user.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(user.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B0000),
                ),
              ),
            ),
            otherAccountsPictures: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.wine_bar,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildSectionTile(
                  context,
                  icon: Icons.inventory,
                  title: 'Gestión de Insumos',
                  subtitle: 'Registro y control de insumos',
                  section: AppSection.supplies,
                ),
                _buildSectionTile(
                  context,
                  icon: Icons.wine_bar,
                  title: 'Proceso de Vinificación',
                  subtitle: 'Lotes y etapas de producción',
                  section: AppSection.winemaking,
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Configuración'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Implementar configuración
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('Ayuda'),
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: Implementar ayuda
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context);
              _showLogoutDialog(context);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required AppSection section,
  }) {
    final isSelected = currentSection == section;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF8B0000).withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? const Color(0xFF8B0000) : null,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? const Color(0xFF8B0000) : null,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? const Color(0xFF8B0000).withOpacity(0.7) : Colors.grey,
          ),
        ),
        onTap: () => onSectionSelected(section),
        selected: isSelected,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar Sesión'),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
  }
}
