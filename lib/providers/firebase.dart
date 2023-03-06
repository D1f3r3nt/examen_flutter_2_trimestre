import 'dart:convert';
import 'package:examen_practic_2_trimestre/models/person_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Firebase extends ChangeNotifier {
  final String _baseUrl =
      "examen-34461-default-rtdb.europe-west1.firebasedatabase.app";

  List<PersonModel> persons = [];

  Firebase() {
    getData();
  }

  getData() async {
    persons.clear();
    final url = Uri.https(_baseUrl, 'persons.json');
    final response = await http.get(url);
    final Map<String, dynamic> usersMap = json.decode(response.body);

    // Mapejam la resposta del servidor, per cada usuari, el convertim a la classe i l'afegim a la llista
    usersMap.forEach((key, value) {
      final auxUser = PersonModel.fromMap(value);
      auxUser.firebaseID = key;
      persons.add(auxUser);
    });

    notifyListeners();
  }

  createData(PersonModel person) async {
    final url = Uri.https(_baseUrl, 'persons.json');
    await http.post(url, body: person.toJson());
    getData();
  }

  deleteData(PersonModel person) async {
    final url = Uri.https(_baseUrl, 'persons/${person.firebaseID}.json');
    await http.delete(url);
    getData();
  }

  createDataWithoutListeners(PersonModel person) async {
    final url = Uri.https(_baseUrl, 'persons.json');
    await http.post(url, body: person.toJson());
  }

  deleteDataWithoutListeners(PersonModel person) async {
    final url = Uri.https(_baseUrl, 'persons/${person.firebaseID}.json');
    await http.delete(url);
  }

  updateData(List<PersonModel> newPersons) async {
    if (persons.isNotEmpty) {
      for (PersonModel data in persons) {
        deleteDataWithoutListeners(data);
      }
    }
    for (PersonModel data in newPersons) {
      createDataWithoutListeners(data);
    }
    getData();
  }
}
