import 'package:elixirline_app_movil_flutter/features/winemaking-process/presentation/pages/wine_batches_page.dart';
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

  int _selectedIndex = 0;

  // Claves de navegadores por cada pestaña
  final List<GlobalKey<NavigatorState>> _navigatorKeys = List.generate(
    6,
    (_) => GlobalKey<NavigatorState>(),
  );

  // Maneja taps en la BottomNavigationBar
  void _onItemTapped(int index) {
    if (index == 1) {
      _scaffoldKey.currentState?.openDrawer(); // Abre el Drawer
    } else {
      setState(() => _selectedIndex = 0); // Solo perfil
    }
  }

  /// Cambia la vista desde el Drawer
  void _navigateFromDrawer(int pageIndex) {
    Navigator.pop(context);
    setState(() => _selectedIndex = pageIndex);
  }

  /// Construye un Navigator por cada pestaña
  Widget _buildTabNavigator(int index, Widget initialPage) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (_) => initialPage,
          settings: settings,
        );
      },
    );
  }

  /// Drawer lateral
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
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInTab =
            !await _navigatorKeys[_selectedIndex].currentState!.maybePop();
        return isFirstRouteInTab;
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: _buildDrawer(),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildTabNavigator(0, const Center(child: Text('Perfil del Usuario'))),
            _buildTabNavigator(1, const WineBatchesPage()),
            _buildTabNavigator(2, const Center(child: Text('Gestión de Insumos'))),
            _buildTabNavigator(3, const Center(child: Text('Actividades Agrícolas'))),
            _buildTabNavigator(4, const Center(child: Text('Gestión de Empleados'))),
            _buildTabNavigator(5, const Center(child: Text('Historial de Producción'))),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex == 0 ? 0 : 1,
          onTap: _onItemTapped,
          backgroundColor: ColorPalette.vinoTinto,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          type: BottomNavigationBarType.fixed,
          items: const [
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
          ],
        ),
      ),
    );
  }
}
