import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'home_screen.dart';

class PinScreen extends StatefulWidget {
  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  final _pinController = TextEditingController();
  final _storage = FlutterSecureStorage();
  bool _obscurePin = true;
  String? _errorText;

  void _checkPin() async {
    final enteredPin = _pinController.text.trim();

    if (enteredPin.length != 8) {
      setState(() {
        _errorText = 'Le PIN doit contenir 8 chiffres';
      });
      return;
    }

    String? storedPin = await _storage.read(key: 'pin');

    if (storedPin != null && enteredPin == storedPin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      setState(() {
        _errorText = 'PIN incorrect';
      });
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Titre
              Text(
                'Bienvenue',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[700],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Entrez votre code PIN pour continuer',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),

              // Champ PIN
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                maxLength: 8,
                obscureText: _obscurePin,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Code PIN',
                  hintText: '8 chiffres',
                  errorText: _errorText,
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePin ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePin = !_obscurePin;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Bouton Valider avec texte blanc
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _checkPin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text(
                    'Valider',
                    style: TextStyle(
                      color: Colors.white, // texte blanc
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
