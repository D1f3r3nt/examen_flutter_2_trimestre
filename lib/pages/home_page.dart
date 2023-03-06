import 'package:examen_practic_2_trimestre/models/person_model.dart';
import 'package:examen_practic_2_trimestre/providers/person_provider.dart';
import 'package:examen_practic_2_trimestre/providers/ui_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/firebase.dart';
import '../ui/ui.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebase = Provider.of<Firebase>(context);
    final personProvider = Provider.of<PersonProvider>(context);
    final uiProvider = Provider.of<UIProvider>(context);

    List<PersonModel> persons = [];

    if (uiProvider.online) {
      persons = firebase.persons;
    } else {
      persons = personProvider.persons;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          IconButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/'),
              icon: const Icon(Icons.logout)),
          Checkbox(
            value: uiProvider.online,
            onChanged: (value) => uiProvider.updateType(value!),
          ),
        ],
      ),
      body: persons.isEmpty
          ? Loading()
          : ListView.builder(
              itemCount: persons.length,
              itemBuilder: ((context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: AlignmentDirectional.centerEnd,
                    color: Colors.red,
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  child: GestureDetector(
                    child: ListTile(
                      title: Text(persons[index].name),
                      subtitle: Text(persons[index].email),
                    ),
                    onTap: () {
                      personProvider.detailPerson = persons[index];
                      Navigator.of(context).pushNamed('detail');
                    },
                  ),
                  onDismissed: (direction) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('${persons[index].name} esborrat')));
                    // DELETE
                    PersonModel personModel = persons[index];
                    personModel.firebaseID = firebase.persons[index].firebaseID;
                    personModel.id = personProvider.persons[index].id;

                    personProvider.deleteCars(personModel);
                    firebase.deleteData(personModel);
                  },
                );
              }),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Cream un usuari temporal nou, per diferenciar-lo d'un ja creat,
          // per que aquest no tindrà id encara, i d'aquesta forma sabrem
          // discernir al detailscreen que estam creant un usuari nou i no
          // modificant un existent
          personProvider.createPerson = PersonModel(
              name: '',
              email: '',
              address: '',
              phone: '',
              photo:
                  'https://empresas.blogthinkbig.com/wp-content/uploads/2019/11/Imagen3-245003649.jpg');

          Navigator.of(context).pushNamed('create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
