// Modelo para la información estática de una estación
// Viene del endpoint station_information
class StationInfo {
  final String stationId;
  final String name;
  final int capacity;
  final String address;

  StationInfo({
    required this.stationId,
    required this.name,
    required this.capacity,
    required this.address,
  });

  // Parsea el JSON que viene de la API
  factory StationInfo.fromJson(Map<String, dynamic> json) {
    return StationInfo(
      stationId: json['station_id'] as String,
      name: json['name'] as String,
      capacity: (json['capacity'] as num).toInt(),
      address: (json['address'] as String?) ?? 'Dirección no disponible',
    );
  }
}
