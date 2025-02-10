import 'package:flutter/material.dart';
import 'package:mobile_app/screens/rezervacije_page.dart';

class CancelPage extends StatelessWidget {
  const CancelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cancel, color: Colors.red, size: 100),
            SizedBox(height: 20),
            Text(
              "Vaše plaćanje je otkazano. Vratite se na kreiranje rezervacije.",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RezervacijePage(),
                  ),
                );
              },
              child: const Text("Vrati se"),
            ),
          ],
        ),
      ),
    );
  }
}
