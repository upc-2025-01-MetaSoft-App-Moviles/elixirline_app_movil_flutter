import 'package:flutter/material.dart';
import '../../../supply-management/presentation/pages/supply_list_page.dart';
import '../../../supply-management/presentation/pages/supply_form_page.dart';
import '../../../supply-management/presentation/pages/supply_usage_page.dart';
import '../../../supply-management/presentation/pages/supply_history_page.dart';
import '../../../winemaking-process/presentation/pages/wine_batch_list_page.dart';
import '../../../winemaking-process/presentation/pages/wine_batch_detail_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  String? _editingSupplyId;
  String? _preselectedSupplyId;
  String? _selectedBatchId;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _editingSupplyId = null;
      _preselectedSupplyId = null;
      _selectedBatchId = null;
    });
  }

  void _navigateToAddSupply() {
    setState(() {
      _selectedIndex = 1;
      _editingSupplyId = null;
    });
  }

  void _navigateToEditSupply(String supplyId) {
    setState(() {
      _selectedIndex = 1;
      _editingSupplyId = supplyId;
    });
  }

  void _navigateToRegisterUsage(String supplyId) {
    setState(() {
      _selectedIndex = 2;
      _preselectedSupplyId = supplyId;
    });
  }

  void _navigateToSupplyList() {
    setState(() {
      _selectedIndex = 0;
      _editingSupplyId = null;
      _preselectedSupplyId = null;
    });
  }

  void _navigateToWineBatchDetail(String batchId) {
    setState(() {
      _selectedIndex = 4; // Wine batch detail
      _selectedBatchId = batchId;
    });
  }

  void _navigateToWineBatchList() {
    setState(() {
      _selectedIndex = 5; // Wine batch list
      _selectedBatchId = null;
    });
  }

  Widget _getSelectedPage() {
    switch (_selectedIndex) {
      case 0:
        return SupplyListPage(
          onAddSupply: _navigateToAddSupply,
          onEditSupply: _navigateToEditSupply,
          onRegisterUsage: _navigateToRegisterUsage,
        );
      case 1:
        return SupplyFormPage(
          supplyId: _editingSupplyId,
          onSuccess: _navigateToSupplyList,
          onCancel: _navigateToSupplyList,
        );
      case 2:
        return SupplyUsagePage(
          preselectedSupplyId: _preselectedSupplyId,
          onSuccess: _navigateToSupplyList,
          onCancel: _navigateToSupplyList,
        );
      case 3:
        return SupplyHistoryPage(
          onBack: _navigateToSupplyList,
        );
      case 4:
        if (_selectedBatchId != null) {
          return WineBatchDetailPage(
            batchId: _selectedBatchId!,
            onBack: _navigateToWineBatchList,
            onAddStage: () {
              // TODO: Implementar navegación a agregar etapa
            },
          );
        }
        return _navigateToWineBatchListWidget();
      case 5:
        return _navigateToWineBatchListWidget();
      default:
        return SupplyListPage(
          onAddSupply: _navigateToAddSupply,
          onEditSupply: _navigateToEditSupply,
          onRegisterUsage: _navigateToRegisterUsage,
        );
    }
  }

  Widget _navigateToWineBatchListWidget() {
    return WineBatchListPage(
      onBatchSelected: _navigateToWineBatchDetail,
      onAddBatch: () {
        // TODO: Implementar navegación a agregar lote
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getSelectedPage(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex >= 4 ? 4 : _selectedIndex,
        onTap: (index) {
          if (index == 4) {
            _navigateToWineBatchList();
          } else {
            _onItemTapped(index);
          }
        },
        backgroundColor: const Color(0xFF8B0000),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Insumos',
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
          BottomNavigationBarItem(
            icon: Icon(Icons.wine_bar),
            label: 'Vinificación',
          ),
        ],
      ),
    );
  }
}
