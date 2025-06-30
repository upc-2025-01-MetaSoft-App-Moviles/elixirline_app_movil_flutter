import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:elixirline_app_movil_flutter/core/utils/color_pallet.dart';

/// Página principal con barra de navegación inferior y menú lateral (Drawer)
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Índice actual del contenido visible
  int _selectedIndex = 0;

  /// Todas las páginas disponibles (Perfil + las del Drawer)
  static const List<Widget> _pages = [
    Center(child: Text('Perfil del Usuario')),
    Center(child: Text('Proceso de vinificación')),
    Center(child: Text('Gestión de Insumos')),
    Center(child: Text('Actividades Agrícolas')),
    Center(child: Text('Gestión de Empleados')),
    Center(child: Text('Historial de Producción')),
  ];

  /// Ítems de la barra de navegación inferior
  static const List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outlined),
      activeIcon: Icon(Icons.person),
      label: 'Perfil',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.menu),
      activeIcon: Icon(Icons.menu_open_rounded),
      label: 'Menú',
    ),
  ];

  /// Maneja taps en el BottomNavigationBar
  void _onItemTapped(int index) {
    if (index == 1) {
      _scaffoldKey.currentState?.openDrawer(); // Abre el Drawer
    } else {
      setState(() => _selectedIndex = 0); // Siempre lleva a perfil
    }
  }

  /// Cambia la vista desde el Drawer
  void _navigateFromDrawer(int pageIndex) {
    Navigator.pop(context);
    setState(() => _selectedIndex = pageIndex);
  }

  /// Construye el Drawer lateral con navegación personalizada
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: ColorPalette.vinoTinto),
            child: const Text(
              'Elixir Line',
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.wineBottle),
            title: const Text('Proceso de Vinificación'),
            onTap: () => _navigateFromDrawer(1),
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Gestión de Insumos'),
            onTap: () => _navigateFromDrawer(2),
          ),
          ListTile(
            leading: const Icon(Icons.agriculture),
            title: const Text('Actividades Agrícolas'),
            onTap: () => _navigateFromDrawer(3),
          ),
          ListTile(
            leading: const Icon(Icons.groups),
            title: const Text('Gestión de Empleados'),
            onTap: () => _navigateFromDrawer(4),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Historial de Producción'),
            onTap: () => _navigateFromDrawer(5),
          ),
          
          Divider(), // Separador visual

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  /// Construye la interfaz principal
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      
      drawer: _buildDrawer(),

      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex == 0 ? 0 : 1, // marca Menú si no es perfil
        onTap: _onItemTapped,
        backgroundColor: ColorPalette.vinoTinto,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        type: BottomNavigationBarType.fixed,
        items: _navItems,
      ),
    );
  }
}
