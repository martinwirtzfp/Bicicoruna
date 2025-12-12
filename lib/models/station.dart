class Station {
  final int station_id;
  final String name;
  final int capacity;
  final int num_docks_available;
  final int num_docks_disabled;

  Station({
    required this.station_id,
    required this.name,
    required this.capacity,
    required this.num_docks_available,
    required this.num_docks_disabled,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      station_id: (json['station_id'] as num).toInt(),
      name: (json['name'] ?? '') as String,
      capacity: (json['capacity'] as num).toInt(),
      num_docks_available: (json['num_docks_available'] as num).toInt(),
      num_docks_disabled: (json['num_docks_disabled'] as num).toInt(),
    );
  }
}