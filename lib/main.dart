import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/station_viewmodel.dart';
import 'views/station_list_view.dart';

void main() {
  runApp(const MyApp());
}

// Aplicación principal
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos ChangeNotifierProvider para hacer disponible el ViewModel
    // en toda la aplicación (patrón MVVM)
    return ChangeNotifierProvider(
      create: (_) => StationViewModel(),
      child: MaterialApp(
        title: 'BiciCoruña',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const StationListView(),
      ),
    );
  }
}
