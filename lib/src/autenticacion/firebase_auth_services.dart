import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String uid = ' ';

  // Iniciar sesión con correo y contraseña
  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      print("Error al iniciar sesión: $e");
    }
    return null;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Asegúrate de que la escucha de cambios en el estado de autenticación esté configurada
      _setupAuthStateListener();
      return credential.user;
    } catch (e) {
      print("Error al iniciar sesión: $e");
    }
    return null;
  }

  void _setupAuthStateListener() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        uid = user.uid;
        print(user.uid);
        print('Usuario Autenticado');
      }
    });
  }

  // Abstraccion de datos autenticado
  Map<String, dynamic> getProviderInfo(User? user) {
    if (user != null) {
      for (final providerProfile in user.providerData) {
        final provider = providerProfile.providerId;
        final uid = providerProfile.uid;
        final nombreU = providerProfile.displayName;
        final telefonoU = providerProfile.phoneNumber;

        return {
          'provider': provider,
          'uid': uid,
          'nombreU': nombreU,
          'telefonoU': telefonoU,
        };
      }
    }
    // Retorna un mapa vacío si no hay información de proveedores
    return {};
  }
}
