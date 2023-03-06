import 'package:examen_practic_2_trimestre/providers/person_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatelessWidget {
  DetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userForm = Provider.of<PersonProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(userForm.detailPerson!.photo)),
              ),
            ),
            Text('Nom: ${userForm.detailPerson!.name}'),
            Text('Adresa: ${userForm.detailPerson!.address}'),
            Text('Email: ${userForm.detailPerson!.email}'),
            Text('Telefon: ${userForm.detailPerson!.phone}'),
          ],
        ),
      ),
    );
  }
}
