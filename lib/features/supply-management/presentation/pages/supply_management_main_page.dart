import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:elixirline_app_movil_flutter/core/utils/color_pallet.dart';
import 'supply_list_page.dart';
import 'supply_form_page.dart';
import 'supply_usage_page.dart';
import 'supply_history_page.dart';

/// Página principal de Gestión de Insumos con navegación entre diferentes funcionalidades
class SupplyManagementMainPage extends StatefulWidget {
  const SupplyManagementMainPage({super.key});

  @override
  State<SupplyManagementMainPage> createState() => _SupplyManagementMainPageState();
}

class _SupplyManagementMainPageState extends State<SupplyManagementMainPage> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        Widget page;

        switch (settings.name) {
          case '/list':
            page = SupplyListPage(
              onAddSupply: () => _navigateToForm(),
              onEditSupply: (supplyId) => _navigateToForm(supplyId: supplyId),
              onRegisterUsage: (supplyId) => _navigateToUsage(supplyId: supplyId),
            );
            break;
          case '/form':
            final args = settings.arguments as Map<String, dynamic>?;
            page = SupplyFormPage(
              supplyId: args?['supplyId'],
              onSuccess: () => _navigateBack(),
              onCancel: () => _navigateBack(),
            );
            break;
          case '/usage':
            final args = settings.arguments as Map<String, dynamic>?;
            page = SupplyUsagePage(
              preselectedSupplyId: args?['supplyId'],
              onSuccess: () => _navigateBack(),
              onCancel: () => _navigateBack(),
            );
            break;
          case '/history':
            page = SupplyHistoryPage(
              onBack: () => _navigateBack(),
            );
            break;
          default:
            page = _buildMainDashboard();
        }

        return MaterialPageRoute(builder: (_) => page, settings: settings);
      },
    );
  }

  /// Construye el dashboard principal con opciones de navegación
  Widget _buildMainDashboard() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestión de Insumos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: ColorPalette.vinoTinto,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con descripción
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorPalette.vinoTinto.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ColorPalette.vinoTinto.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.inventory_2,
                    size: 32,
                    color: ColorPalette.vinoTinto,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Centro de Control de Insumos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Administra tu inventario, registra consumos y mantén control total de tus suministros.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            const Text(
              'Opciones disponibles',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),

            // Grid de opciones
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  _buildDashboardCard(
                    icon: FontAwesomeIcons.listCheck,
                    title: 'Lista de Insumos',
                    subtitle: 'Ver inventario completo',
                    color: Colors.blue,
                    onTap: () => _navigateToList(),
                  ),
                  _buildDashboardCard(
                    icon: FontAwesomeIcons.plus,
                    title: 'Agregar Insumo',
                    subtitle: 'Registrar nuevo material',
                    color: Colors.green,
                    onTap: () => _navigateToForm(),
                  ),
                  _buildDashboardCard(
                    icon: FontAwesomeIcons.arrowDown,
                    title: 'Registrar Consumo',
                    subtitle: 'Anotar uso de insumos',
                    color: Colors.orange,
                    onTap: () => _navigateToUsage(),
                  ),
                  _buildDashboardCard(
                    icon: FontAwesomeIcons.clockRotateLeft,
                    title: 'Historial',
                    subtitle: 'Ver movimientos pasados',
                    color: Colors.purple,
                    onTap: () => _navigateToHistory(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye una tarjeta del dashboard
  Widget _buildDashboardCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: FaIcon(
                  icon,
                  size: 28,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Métodos de navegación
  void _navigateToList() {
    _navigatorKey.currentState?.pushNamed('/list');
  }

  void _navigateToForm({String? supplyId}) {
    _navigatorKey.currentState?.pushNamed(
      '/form',
      arguments: supplyId != null ? {'supplyId': supplyId} : null,
    );
  }

  void _navigateToUsage({String? supplyId}) {
    _navigatorKey.currentState?.pushNamed(
      '/usage',
      arguments: supplyId != null ? {'supplyId': supplyId} : null,
    );
  }

  void _navigateToHistory() {
    _navigatorKey.currentState?.pushNamed('/history');
  }

  void _navigateBack() {
    _navigatorKey.currentState?.pop();
  }
}
