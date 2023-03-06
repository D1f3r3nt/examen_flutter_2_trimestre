import 'package:examen_practic_2_trimestre/providers/firebase.dart';
import 'package:examen_practic_2_trimestre/providers/person_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../ui/input_decorations.dart';

class CreatePage extends StatelessWidget {
  CreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userForm = Provider.of<PersonProvider>(context, listen: false);
    final firebase = Provider.of<Firebase>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Screen'),
      ),
      body: _UserForm(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (userForm.isValidForm()) {
            userForm.createCars();
            firebase.createData(userForm.createPerson!);
            Navigator.of(context).pop();
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}

class _UserForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userForm = Provider.of<PersonProvider>(context);
    final tempCar = userForm.createPerson!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: userForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              SizedBox(height: 10),
              TextFormField(
                initialValue: tempCar.name,
                onChanged: (value) => tempCar.name = value,
                validator: (value) {
                  if (value == null || value.length < 1)
                    return 'El name és obligatori';
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Name', labelText: 'Name:'),
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: tempCar.address,
                onChanged: (value) => tempCar.address = value,
                validator: (value) {
                  if (value == null || value.length < 1)
                    return 'El address és obligatori';
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Address', labelText: 'Address:'),
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: tempCar.email,
                onChanged: (value) => tempCar.email = value,
                validator: (value) {
                  if (value == null || value.length < 1)
                    return 'El email és obligatori';
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Email', labelText: 'Email:'),
              ),
              SizedBox(height: 30),
              TextFormField(
                initialValue: tempCar.phone,
                onChanged: (value) => tempCar.phone = value,
                validator: (value) {
                  if (value == null || value.length < 1)
                    return 'El phone és obligatori';
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Phone', labelText: 'Phone:'),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(0, 5),
              blurRadius: 5),
        ],
      );
}
