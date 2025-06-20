import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/blocs/auth/auth_bloc.dart';
import '../../../auth/domain/entities/user.dart';
import '../widgets/app_drawer.dart';
import '../../../supply-management/presentation/pages/supply_list_page.dart';
import '../../../supply-management/presentation/pages/supply_form_page.dart';
import '../../../supply-management/presentation/pages/supply_usage_page.dart';
import '../../../supply-management/presentation/pages/supply_history_page.dart';
import '../../../winemaking-process/presentation/pages/wine_batch_list_page.dart';
import '../../../winemaking-process/presentation/pages/wine_batch_detail_page.dart';

enum AppSection {
  supplies,
  winemaking,
}

enum SupplySubPage {
  list,
  form,
  usage,
  history,
}

enum WinemakingSubPage {
  list,
  detail,
}

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({
    super.key,
    required this.user,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppSection _currentSection = AppSection.supplies;
  SupplySubPage _currentSupplyPage = SupplySubPage.list;
  WinemakingSubPage _currentWinemakingPage = WinemakingSubPage.list;
  
  String? _editingSupplyId;
  String? _preselectedSupplyId;
  String? _selectedBatchId;

  void _navigateToSection(AppSection section) {
    setState(() {
      _currentSection = section;
      // Reset sub-pages when changing sections
      _currentSupplyPage = SupplySubPage.list;
      _currentWinemakingPage = WinemakingSubPage.list;
      _editingSupplyId = null;
      _preselectedSupplyId = null;
      _selectedBatchId = null;
    });
    Navigator.of(context).pop(); // Close drawer
  }

  // Supply navigation methods
  void _navigateToAddSupply() {
    setState(() {
      _currentSupplyPage = SupplySubPage.form;
      _editingSupplyId = null;
    });
  }

  void _navigateToEditSupply(String supplyId) {
    setState(() {
      _currentSupplyPage = SupplySubPage.form;
      _editingSupplyId = supplyId;
    });
  }

  void _navigateToRegisterUsage(String supplyId) {
    setState(() {
      _currentSupplyPage = SupplySubPage.usage;
      _preselectedSupplyId = supplyId;
    });
  }

  void _navigateToSupplyList() {
    setState(() {
      _currentSupplyPage = SupplySubPage.list;
      _editingSupplyId = null;
      _preselectedSupplyId = null;
    });
  }

  void _navigateToSupplyHistory() {
    setState(() {
      _currentSupplyPage = SupplySubPage.history;
    });
  }

  // Winemaking navigation methods
  void _navigateToWineBatchDetail(String batchId) {
    setState(() {
      _currentWinemakingPage = WinemakingSubPage.detail;
      _selectedBatchId = batchId;
    });
  }

  void _navigateToWineBatchList() {
    setState(() {
      _currentWinemakingPage = WinemakingSubPage.list;
      _selectedBatchId = null;
    });
  }

  Widget _getCurrentPage() {
    switch (_currentSection) {
      case AppSection.supplies:
        return _getSupplyPage();
      case AppSection.winemaking:
        return _getWinemakingPage();
    }
  }

  Widget _getSupplyPage() {
    switch (_currentSupplyPage) {
      case SupplySubPage.list:
        return SupplyListPage(
          onAddSupply: _navigateToAddSupply,
          onEditSupply: _navigateToEditSupply,
          onRegisterUsage: _navigateToRegisterUsage,
        );
      case SupplySubPage.form:
        return SupplyFormPage(
          supplyId: _editingSupplyId,
          onSuccess: _navigateToSupplyList,
          onCancel: _navigateToSupplyList,
        );
      case SupplySubPage.usage:
        return SupplyUsagePage(
          preselectedSupplyId: _preselectedSupplyId,
          onSuccess: _navigateToSupplyList,
          onCancel: _navigateToSupplyList,
        );
      case SupplySubPage.history:
        return SupplyHistoryPage(
          onBack: _navigateToSupplyList,
        );
    }
  }

  Widget _getWinemakingPage() {
    switch (_currentWinemakingPage) {
      case WinemakingSubPage.list:
        return WineBatchListPage(
          onBatchSelected: _navigateToWineBatchDetail,
          onAddBatch: () {
            // TODO: Implementar navegación a agregar lote
          },
        );
      case WinemakingSubPage.detail:
        if (_selectedBatchId != null) {
          return WineBatchDetailPage(
            batchId: _selectedBatchId!,
            onBack: _navigateToWineBatchList,
            onAddStage: () {
              // TODO: Implementar navegación a agregar etapa
            },
          );
        }
        return _getWinemakingPage();
    }
  }

  String _getAppBarTitle() {
    switch (_currentSection) {
      case AppSection.supplies:
        switch (_currentSupplyPage) {
          case SupplySubPage.list:
            return 'Gestión de Insumos';
          case SupplySubPage.form:
            return _editingSupplyId != null ? 'Editar Insumo' : 'Agregar Insumo';
          case SupplySubPage.usage:
            return 'Registrar Uso';
          case SupplySubPage.history:
            return 'Historial de Insumos';
        }
      case AppSection.winemaking:
        switch (_currentWinemakingPage) {
          case WinemakingSubPage.list:
            return 'Proceso de Vinificación';
          case WinemakingSubPage.detail:
            return 'Detalle de Lote';
        }
    }
  }

  Widget? _getFloatingActionButton() {
    if (_currentSection == AppSection.supplies && _currentSupplyPage == SupplySubPage.list) {
      return FloatingActionButton(
        onPressed: _navigateToAddSupply,
        child: const Icon(Icons.add),
      );
    }
    if (_currentSection == AppSection.winemaking && _currentWinemakingPage == WinemakingSubPage.list) {
      return FloatingActionButton(
        onPressed: () {
          // TODO: Implementar agregar lote
        },
        child: const Icon(Icons.add),
      );
    }
    return null;
  }

  Widget? _getBottomNavigationBar() {
    if (_currentSection == AppSection.supplies) {
      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentSupplyPage.index,
        onTap: (index) {
          switch (index) {
            case 0:
              _navigateToSupplyList();
              break;
            case 1:
              _navigateToAddSupply();
              break;
            case 2:
              setState(() {
                _currentSupplyPage = SupplySubPage.usage;
                _preselectedSupplyId = null;
              });
              break;
            case 3:
              _navigateToSupplyHistory();
              break;
          }
        },
        backgroundColor: const Color(0xFF8B0000),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Registrar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Uso',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Historial',
          ),
        ],
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // TODO: Mostrar perfil de usuario
            },
          ),
        ],
      ),
      drawer: AppDrawer(
        user: widget.user,
        currentSection: _currentSection,
        onSectionSelected: _navigateToSection,
        onLogout: () {
          context.read<AuthBloc>().add(LogoutRequested());
        },
      ),
      body: _getCurrentPage(),
      floatingActionButton: _getFloatingActionButton(),
      bottomNavigationBar: _getBottomNavigationBar(),
    );
  }
}
