import 'dart:convert';
import 'package:mobile_app/models/rezervacija.dart';
import 'base_provider.dart';
import 'package:http/http.dart' as http;

class RezervacijeProvider extends BaseProvider<Rezervacija> {
  RezervacijeProvider()
      : super("Rezervacije",
            "isKorisnikIncluded=true&isUslugaIncluded=true&isTerminIncluded=true&isStatusIncluded=true");

  @override
  Rezervacija fromJson(data) {
    // TODO: implement fromJson
    return Rezervacija.fromJson(data);
  }

  Future<bool> OtkaziRezervaciju(int id) async {
    var url = "${BaseProvider.baseUrl}Rezervacije/otkaziRezervaciju/$id";

    print("url: $url");

    var uri = Uri.parse(url);
    var headers = createHeaders();
    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      return true;
    } else {
      return false;
    }
  }
}
