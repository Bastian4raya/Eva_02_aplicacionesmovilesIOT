import 'package:app_tareas/login_fields.dart'; 
import 'package:flutter/material.dart'; 

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key}); 

  @override
  Widget build(BuildContext context) {
    // Construye la estructura visual de la pantalla
    return Scaffold(
      appBar: AppBar(title: const Text("Inicio de sesión"),
      backgroundColor: const Color.fromARGB(255, 237, 179, 165)),
      body: SafeArea( 
        child: Center( 
          child: SingleChildScrollView( 
            padding: const EdgeInsets.all(16), 
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420), 
              child: LoginFields(), 
            ),
          ),
        ),
      ),
    );
  }
}
