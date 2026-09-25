import 'package:flutter/material.dart';

void main() {
  runApp(const ControlTurnosApp());
}

class ControlTurnosApp extends StatelessWidget {
  const ControlTurnosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de Turnos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2C3E50)),
        useMaterial3: true,
      ),
      home: const PantallaPrincipal(),
    );
  }
}

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  final List<String> turnos = ['D', 'N', 'L', 'A', 'B', 'C'];
  
  final Map<String, Color> coloresTurnos = {
    'D': const Color(0xFFFFF9C4), // Amarillo muy claro
    'N': const Color(0xFFE1F5FE), // Azul muy claro
    'L': const Color(0xFF8AF141), // Verde manzana
    'A': const Color(0xFFFFE0B2), // Naranja claro
    'B': const Color(0xFFE1BEE7), // Lila claro
    'C': const Color(0xFFCFD8DC), // Gris claro
  };

  final List<String> dias = ['Lun 21', 'Mar 22', 'Mié 23', 'Jue 24', 'Vie 25', 'Sáb 26', 'Dom 27'];
  
  final Map<String, List<String>> programacion = {
    'Carlos Mendoza': ['D', 'D', 'D', 'N', 'N', 'N', 'L'],
    'Ana Gómez': ['A', 'A', 'B', 'B', 'C', 'C', 'L'],
  };

  final List<String> historialLog = [];

  void _cambiarTurno(String empleado, int indexDia) {
    setState(() {
      String turnoActual = programacion[empleado]![indexDia];
      int siguienteIndex = (turnos.indexOf(turnoActual) + 1) % turnos.length;
      String nuevoTurno = turnos[siguienteIndex];

      programacion[empleado]![indexDia] = nuevoTurno;

      String hora = "${TimeOfDay.now().hour}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}";
      historialLog.insert(0, "[$hora] $empleado (${dias[indexDia]}): $turnoActual ➔ $nuevoTurno");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📱 Control de Turnos Personal'),
        backgroundColor: const Color(0xFF2C3E50),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('🏢 Cliente: Conjunto Torres del Parque', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('📍 Puesto: Portería Peatonal'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: coloresTurnos.entries.map((entry) {
                return Chip(
                  label: Text('${entry.key}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  backgroundColor: entry.value,
                  side: const BorderSide(color: Colors.black12),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(const Color(0xFF2C3E50)),
                columns: [
                  const DataColumn(label: Text('Empleado', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  ...dias.map((d) => DataColumn(label: Text(d, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
                ],
                rows: programacion.entries.map((entry) {
                  String empleado = entry.key;
                  List<String> turnosEmp = entry.value;

                  return DataRow(
                    cells: [
                      DataCell(Text(empleado, style: const TextStyle(fontWeight: FontWeight.bold))),
                      ...List.generate(turnosEmp.length, (i) {
                        String codigo = turnosEmp[i];
                        return DataCell(
                          InkWell(
                            onTap: () => _cambiarTurno(empleado, i),
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: coloresTurnos[codigo],
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.black12),
                              ),
                              child: Text(
                                codigo,
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            const Text('📋 Historial de Modificaciones:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              height: 150,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber),
              ),
              child: historialLog.isEmpty
                  ? const Center(child: Text('No hay modificaciones en esta sesión.'))
                  : ListView.builder(
                      itemCount: historialLog.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Text(historialLog[index], style: const TextStyle(fontSize: 13)),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
