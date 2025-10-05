import 'package:app_tareas/login_screen.dart'; // Importa un archivo donde está definida la pantalla de inicio de sesión
import 'package:flutter/material.dart'; // Importa las herramientas necesarias de Flutter para construir la interfaz

void main() {
  runApp(const MainApp()); // Función principal: ejecuta la aplicación usando el widget MainApp
}

class MainApp extends StatelessWidget { // Define una clase MainApp que no puede cambiar (es inmutable)
  const MainApp({super.key}); // Constructor de la clase, que permite usar claves únicas para el widget

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Login",
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 240, 230, 230),
      ),
      home: const LoginScreen(),
    );
  }
}
