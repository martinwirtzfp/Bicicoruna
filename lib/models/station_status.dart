// Modelo para el estado dinámico de una estación
// Viene del endpoint station_status
class StationStatus {
  final String stationId;
  final int numBikesAvailable;
  final int numBikesDisabled;
  final int numDocksAvailable;
  final int numDocksDisabled;
  final int numBikesElectric;
  final int numBikesMechanic;
  final DateTime lastReported;

  StationStatus({
    required this.stationId,
    required this.numBikesAvailable,
    required this.numBikesDisabled,
    required this.numDocksAvailable,
    required this.numDocksDisabled,
    required this.numBikesElectric,
    required this.numBikesMechanic,
    required this.lastReported,
  });

  // Parsea el JSON que viene de la API
  factory StationStatus.fromJson(Map<String, dynamic> json) {
    // Contamos cuántas bicis eléctricas y mecánicas hay disponibles
    int numElectric = 0;
    int numMechanic = 0;

    // La API trae un array de tipos de vehículos disponibles
    if (json['vehicle_types_available'] != null) {
      final List<dynamic> vehicleTypes = json['vehicle_types_available'];
      for (var vehicle in vehicleTypes) {
        // La API de BiciCoruña usa estos IDs:
        // FIT = bicicleta mecánica
        // EFIT = bicicleta eléctrica FIT
        // BOOST = bicicleta eléctrica BOOST
        final vehicleTypeId = vehicle['vehicle_type_id'] as String?;
        final count = (vehicle['count'] as num?)?.toInt() ?? 0;

        if (vehicleTypeId == 'EFIT' || vehicleTypeId == 'BOOST') {
          numElectric += count;
        } else if (vehicleTypeId == 'FIT') {
          numMechanic += count;
        }
      }
    }

    return StationStatus(
      stationId: json['station_id'] as String,
      numBikesAvailable: (json['num_bikes_available'] as num).toInt(),
      numBikesDisabled: (json['num_bikes_disabled'] as num?)?.toInt() ?? 0,
      numDocksAvailable: (json['num_docks_available'] as num).toInt(),
      numDocksDisabled: (json['num_docks_disabled'] as num?)?.toInt() ?? 0,
      numBikesElectric: numElectric,
      numBikesMechanic: numMechanic,
      // Convertimos el timestamp Unix a DateTime
      lastReported: DateTime.fromMillisecondsSinceEpoch(
        (json['last_reported'] as num).toInt() * 1000,
      ),
    );
  }
}
