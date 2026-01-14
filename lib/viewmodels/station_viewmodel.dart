import 'package:flutter/foundation.dart';
import '../models/station.dart';
import '../repositories/station_repository.dart';

// Estados posibles de la aplicación
enum StationState {
  initial, // Estado inicial, antes de cargar
  loading, // Cargando datos
  loaded, // Datos cargados correctamente
  error, // Error al cargar
}

// ViewModel que gestiona el estado y la lógica de las estaciones
// Usamos ChangeNotifier para notificar a la UI cuando hay cambios
class StationViewModel extends ChangeNotifier {
  final IStationRepository _repository;

  // Constructor con inyección de dependencias opcional
  // Si no se proporciona un repository, usa el real por defecto
  StationViewModel([IStationRepository? repository])
      : _repository = repository ?? StationRepository();

  // Estado actual de la aplicación
  StationState _state = StationState.initial;
  StationState get state => _state;

  // Lista de todas las estaciones
  List<Station> _stations = [];
  List<Station> get stations => _stations;

  // Lista de estaciones filtradas por la búsqueda
  List<Station> _filteredStations = [];
  List<Station> get filteredStations => _filteredStations;

  // Mensaje de error si algo falla
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // Texto de búsqueda actual
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  // Carga todas las estaciones desde la API
  Future<void> loadStations() async {
    // Cambiamos el estado a "cargando"
    _state = StationState.loading;
    notifyListeners(); // Avisamos a la UI para que muestre el loading

    try {
      // Intentamos obtener las estaciones del repositorio
      _stations = await _repository.getAllStations();

      // Ordenamos alfabéticamente por nombre
      _stations.sort((a, b) => a.name.compareTo(b.name));

      // Inicialmente mostramos todas las estaciones
      _filteredStations = List.from(_stations);

      // Si todo fue bien, cambiamos el estado a "cargado"
      _state = StationState.loaded;
      _errorMessage = '';
    } catch (e) {
      // Si hubo un error, guardamos el mensaje
      _state = StationState.error;
      _errorMessage = e.toString();
    }

    notifyListeners(); // Avisamos a la UI del cambio de estado
  }

  // Filtra las estaciones según el texto de búsqueda
  void searchStations(String query) {
    _searchQuery = query;

    if (query.isEmpty) {
      // Si no hay búsqueda, mostramos todas
      _filteredStations = List.from(_stations);
    } else {
      // Filtramos las que contengan el texto (sin importar mayúsculas)
      _filteredStations = _stations
          .where(
            (station) =>
                station.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }

    notifyListeners(); // Avisamos a la UI para que actualice la lista
  }

  // Recarga las estaciones (por ejemplo, al hacer pull-to-refresh)
  Future<void> refreshStations() async {
    await loadStations();
  }
}
