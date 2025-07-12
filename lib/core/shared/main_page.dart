import 'package:elixirline_app_movil_flutter/features/winemaking-process/presentation/pages/batches_pages/wine_batches_page.dart';
import 'package:elixirline_app_movil_flutter/core/shared/test_data_generator.dart';
import 'package:elixirline_app_movil_flutter/features/production-history/presentation/pages/production_history_list_page.dart';
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

  /// Genera datos de prueba en el backend
  Future<void> _generateTestData() async {
    Navigator.pop(context); // Cerrar drawer
    
    int selectedBatchCount = 4; // Valor por defecto
    
    // Mostrar diálogo de selección de cantidad y confirmación
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.science, color: Colors.orange),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Generar Datos de Prueba',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selecciona cuántos lotes crear:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  
                  // Selector de cantidad
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<int>(
                      value: selectedBatchCount,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: 1, child: Text('1 lote')),
                        DropdownMenuItem(value: 2, child: Text('2 lotes')),
                        DropdownMenuItem(value: 3, child: Text('3 lotes')),
                        DropdownMenuItem(value: 4, child: Text('4 lotes (completo)')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedBatchCount = value!;
                        });
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  const Text(
                    'Lotes que se crearán:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  
                  // Lista de lotes que se crearán
                  ...List.generate(selectedBatchCount, (index) {
                    final lotes = [
                      {'name': '🍇 Premium Cabernet Sauvignon 2025', 'stages': 'Completo (8/8 etapas)'},
                      {'name': '🍇 Reserva Merlot 2025', 'stages': 'Hasta fermentación (3/8 etapas)'},
                      {'name': '🍇 Blend Económico 2025', 'stages': 'Hasta prensado (4/8 etapas)'},
                      {'name': '🍇 Experimental Syrah 2025', 'stages': 'Solo recepción (1/8 etapas)'},
                    ];
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lotes[index]['name']!,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '   → ${lotes[index]['stages']}',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    );
                  }),
                  
                  const SizedBox(height: 12),
                  const Text(
                    '¿Desea continuar?',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, {'generate': true, 'count': selectedBatchCount}),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Generar Datos'),
            ),
          ],
        ),
      ),
    );

    if (result?['generate'] != true) return;
    
    final int batchCount = result!['count'];
    
    // Mostrar indicador de carga
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 20),
                Expanded(
                  child: Text('Generando $batchCount ${batchCount == 1 ? 'lote' : 'lotes'} de prueba...'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    try {
      await TestDataGenerator.generateAndStoreTestData(batchCount: batchCount);
      
      if (mounted) {
        Navigator.pop(context); // Cerrar diálogo de carga
        
        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 $batchCount ${batchCount == 1 ? 'lote' : 'lotes'} de prueba ${batchCount == 1 ? 'generado' : 'generados'} exitosamente'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
        
        // Navegar a la página de lotes para ver los datos generados
        setState(() => _selectedIndex = 1);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Cerrar diálogo de carga
        
        // Mostrar mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error generando datos: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
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
            leading: const Icon(Icons.science, color: Colors.orange),
            title: const Text(
              'Generar Datos de Prueba',
              style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('4 lotes con diferentes etapas'),
            onTap: _generateTestData,
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return;
        
        final navigator = _navigatorKeys[_selectedIndex].currentState;
        if (navigator != null) {
          final canPop = await navigator.maybePop();
          if (!canPop && context.mounted) {
            // Si no se puede hacer pop en el navegador de la pestaña actual,
            // entonces permitir que la app se cierre
            Navigator.of(context).pop();
          }
        }
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
            _buildTabNavigator(5, const ProductionHistoryListPage()),
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
