import 'package:examen_practic_2_trimestre/models/person_model.dart';
import 'package:flutter/material.dart';

import '../database/database.dart';

class PersonProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<PersonModel> persons = [];
  PersonModel? detailPerson;
  PersonModel? createPerson;

  PersonProvider() {
    loadCars();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  loadCars() async {
    persons.clear();
    persons = await LocalDatabase.db.getAll();

    notifyListeners();
  }

  createCars() async {
    await LocalDatabase.db.insert(createPerson!);
    loadCars();
  }

  insertData(PersonModel data) async {
    await LocalDatabase.db.insert(data);
  }

  deleteCars(PersonModel car) async {
    LocalDatabase.db.deleteById(car.id!);
    loadCars();
  }

  deleteCarsWithoutListener(PersonModel car) async {
    LocalDatabase.db.deleteById(car.id!);
  }

  updateData(List<PersonModel> newPersons) async {
    if (persons.isNotEmpty) {
      for (PersonModel data in persons) {
        deleteCarsWithoutListener(data);
      }
    }

    for (PersonModel data in newPersons) {
      insertData(data);
    }

    loadCars();
  }
}
