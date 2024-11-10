import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crude/firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

// * cyan
// Color(0xff087E8B)

// * red
// Color(0xffFF5A5F)

// * black
// Color(0xff3C3C3C),

// * beige
// Color(0xffEAE0D5)

// * brown
// Color(0xff81725F)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TelaPrincipal(),
      title: 'Hobbie Tracker',
      debugShowCheckedModeBanner: false,
    );
  }
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  bool adicionando = false;
  bool editando = false;

  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController hobbyName = TextEditingController();
  final TextEditingController timePracticed = TextEditingController();

  void adicionandoToggle() {
    setState(() {
      adicionando = !adicionando;
    });
  }

  void editandoToggle() {
    setState(() {
      editando = !editando;
    });
  }

  List<String> hobbyNames = [];
  List<String> practiceTimes = [];
  List<String> docIds = [];

  Future<void> fetchHobbies() async {
    QuerySnapshot snapshot = await firestoreService.getHobbies().first;
    setState(() {
      hobbyNames.clear();
      practiceTimes.clear();
      docIds.clear();
      for (var doc in snapshot.docs) {
        hobbyNames.add(doc['hobbyName']);
        practiceTimes.add(doc['timePracticed']);
        docIds.add(doc.id);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchHobbies();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEAE0D5),
      appBar: AppBar(
          title: AnimatedDefaultTextStyle(
              child: Text('Hobby Tracker'),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: adicionando ? Color(0xffEAE0D5) : Color(0xff3C3C3C)),
              duration: Duration(milliseconds: 350)),
          centerTitle: true,
          backgroundColor:
              adicionando ? Colors.black.withOpacity(0.5) : Color(0xffEAE0D5)),
      body: Stack(children: [
        Column(children: [
          Expanded(
            child: ListView.builder(
              itemCount: hobbyNames.length,
              itemBuilder: (context, index) {
                return HobbyTile(
                  hobbyName: hobbyNames[index],
                  timePracticed: practiceTimes[index],
                  firestoreService: firestoreService,
                  fetchHobbies: fetchHobbies,
                  editandoToggle: editandoToggle,
                  docId: docIds[index],
                );
              },
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color(0xff3C3C3C),
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                      minimumSize: Size(double.infinity, double.infinity)),
                  onPressed: adicionandoToggle,
                  child: Text(
                    'Adicionar Hobby',
                    style: TextStyle(
                        color: Color(0xffEAE0D5),
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
        ]),
        AddingHobbyOverlay(
          adicionando: adicionando,
          hobbyName: hobbyName,
          timePracticed: timePracticed,
          adicionandoToggle: adicionandoToggle,
          firestoreService: firestoreService,
          fetchHobbies: fetchHobbies,
        ),
        EditingHobbyOverlay(
          editando: editando,
          hobbyName: hobbyName,
          timePracticed: timePracticed,
          editandoToggle: editandoToggle,
          firestoreService: firestoreService,
          fetchHobbies: fetchHobbies,
          docId: docIds[0],
        ),
      ]),
    );
  }
}

class AddingHobbyOverlay extends StatelessWidget {
  final bool adicionando;
  final TextEditingController hobbyName;
  final TextEditingController timePracticed;
  final Function adicionandoToggle;
  final FirestoreService firestoreService;
  final Function fetchHobbies;

  const AddingHobbyOverlay({
    super.key,
    required this.adicionando,
    required this.hobbyName,
    required this.timePracticed,
    required this.adicionandoToggle,
    required this.firestoreService,
    required this.fetchHobbies,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !adicionando,
      child: AnimatedOpacity(
          opacity: adicionando ? 1.0 : 0.0,
          duration: Duration(milliseconds: 350),
          child: Center(
              child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withOpacity(0.5),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                height: 600,
                width: double.infinity,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Color(0xff3C3C3C),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: TextFormField(
                        controller: hobbyName,
                        decoration: InputDecoration(
                            hintText: 'Nome do Hobby (ex: Piano)',
                            hintStyle: TextStyle(
                                color: Color(0xffFF5A5F).withOpacity(0.5),
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(15)),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: TextFormField(
                        controller: timePracticed,
                        decoration: InputDecoration(
                            hintText: 'Tempo de Prática (ex: 1h30min)',
                            hintStyle: TextStyle(
                                color: Color(0xff087E8B).withOpacity(0.5),
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(15)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 6, 15),
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextButton(
                                    onPressed: () {
                                      hobbyName.clear();
                                      timePracticed.clear();
                                      adicionandoToggle();
                                    },
                                    child: Text(
                                      'Cancelar',
                                      style: TextStyle(
                                          color: Color(0xffEAE0D5),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(6, 15, 0, 15),
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextButton(
                                    onPressed: () {
                                      firestoreService.createHobby(
                                          hobbyName.text, timePracticed.text);
                                      hobbyName.clear();
                                      timePracticed.clear();
                                      fetchHobbies();
                                      adicionandoToggle();
                                    },
                                    child: Text(
                                      'Adicionar',
                                      style: TextStyle(
                                          color: Color(0xffEAE0D5),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ))),
    );
  }
}

class EditingHobbyOverlay extends StatelessWidget {
  final bool editando;
  final TextEditingController hobbyName;
  final TextEditingController timePracticed;
  final Function editandoToggle;
  final FirestoreService firestoreService;
  final Function fetchHobbies;
  final String docId;

  const EditingHobbyOverlay({
    super.key,
    required this.editando,
    required this.hobbyName,
    required this.timePracticed,
    required this.editandoToggle,
    required this.firestoreService,
    required this.fetchHobbies,
    required this.docId,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !editando,
      child: AnimatedOpacity(
          opacity: editando ? 1.0 : 0.0,
          duration: Duration(milliseconds: 350),
          child: Center(
              child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black.withOpacity(0.5),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                height: 600,
                width: double.infinity,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: Color(0xff3C3C3C),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: TextFormField(
                        controller: hobbyName,
                        decoration: InputDecoration(
                            hintText: 'Novo nome do hobby',
                            hintStyle: TextStyle(
                                color: Color(0xffFF5A5F).withOpacity(0.5),
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(15)),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      child: TextFormField(
                        controller: timePracticed,
                        decoration: InputDecoration(
                            hintText: 'Novo tempo de Prática',
                            hintStyle: TextStyle(
                                color: Color(0xff087E8B).withOpacity(0.5),
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(15)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 6, 15),
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextButton(
                                    onPressed: () {
                                      hobbyName.clear();
                                      timePracticed.clear();
                                      editandoToggle();
                                    },
                                    child: Text(
                                      'Cancelar',
                                      style: TextStyle(
                                          color: Color(0xffEAE0D5),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(6, 15, 0, 15),
                              child: Container(
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextButton(
                                    onPressed: () {
                                      firestoreService.updateHobby(docId,
                                          hobbyName.text, timePracticed.text);
                                      fetchHobbies();
                                      editandoToggle();
                                    },
                                    child: Text(
                                      'Adicionar',
                                      style: TextStyle(
                                          color: Color(0xffEAE0D5),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ))),
    );
  }
}

class HobbyTile extends StatefulWidget {
  const HobbyTile({
    super.key,
    required this.hobbyName,
    required this.timePracticed,
    required this.firestoreService,
    required this.fetchHobbies,
    required this.editandoToggle,
    required this.docId,
  });

  final String hobbyName;
  final String timePracticed;
  final FirestoreService firestoreService;
  final Function fetchHobbies;
  final Function editandoToggle;
  final String docId;

  @override
  State<HobbyTile> createState() => _HobbyTileState();
}

class _HobbyTileState extends State<HobbyTile> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Container(
            height: 60,
            width: 180,
            decoration: BoxDecoration(
                color: Color(0xffFF5A5F),
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text(
                widget.hobbyName,
                style: TextStyle(
                    color: Color(0xffEAE0D5),
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            height: 60,
            width: 100,
            decoration: BoxDecoration(
                color: Color(0xff087E8B),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Column(
                children: [
                  Icon(
                    Icons.timer_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                  Text(
                    widget.timePracticed,
                    style: TextStyle(
                        color: Color(0xffEAE0D5),
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                    color: Color(0xff81725F),
                    borderRadius: BorderRadius.circular(10)),
                child: IconButton(
                  onPressed: () {
                    widget.editandoToggle();
                  },
                  icon: Icon(Icons.mode_edit_outlined),
                  color: Colors.white,
                  iconSize: 35,
                )))
      ],
    );
  }
}
