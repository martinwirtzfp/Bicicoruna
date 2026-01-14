import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/station_viewmodel.dart';
import 'station_detail_view.dart';

// Pantalla principal que muestra la lista de estaciones
class StationListView extends StatefulWidget {
  const StationListView({super.key});

  @override
  State<StationListView> createState() => _StationListViewState();
}

class _StationListViewState extends State<StationListView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Cuando se crea la pantalla, cargamos las estaciones
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StationViewModel>().loadStations();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BiciCoruña'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar estación...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<StationViewModel>().searchStations('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                // Al escribir, filtramos las estaciones
                context.read<StationViewModel>().searchStations(value);
              },
            ),
          ),
          // Lista de estaciones
          Expanded(
            child: Consumer<StationViewModel>(
              builder: (context, viewModel, child) {
                // Mostramos diferentes widgets según el estado
                switch (viewModel.state) {
                  case StationState.initial:
                  case StationState.loading:
                    // Pantalla de carga
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Cargando estaciones...'),
                        ],
                      ),
                    );

                  case StationState.error:
                    // Pantalla de error con opción de reintentar
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Ups! Algo salió mal',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              viewModel.errorMessage,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () => viewModel.loadStations(),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      ),
                    );

                  case StationState.loaded:
                    final stations = viewModel.filteredStations;

                    // Si no hay estaciones después de filtrar
                    if (stations.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No se encontraron estaciones',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // Lista de estaciones con pull-to-refresh
                    return RefreshIndicator(
                      onRefresh: () => viewModel.refreshStations(),
                      child: ListView.builder(
                        itemCount: stations.length,
                        itemBuilder: (context, index) {
                          final station = stations[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: _getStatusColor(station),
                                child: Icon(
                                  Icons.directions_bike,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                station.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                '${station.numBikesAvailable} bicis disponibles',
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                // Al tocar, navegamos a la pantalla de detalle
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        StationDetailView(station: station),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Función auxiliar para determinar el color según disponibilidad
  Color _getStatusColor(station) {
    if (station.numBikesAvailable == 0) {
      return Colors.red; // Sin bicis
    } else if (station.numBikesAvailable < 3) {
      return Colors.orange; // Pocas bicis
    } else {
      return Colors.green; // Bicis disponibles
    }
  }
}
