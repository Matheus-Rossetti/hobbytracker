import 'package:flutter/material.dart';

void main() => runApp(MyApp());

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
  bool _adicionando = false;

  void _editandoToggle() {
    setState(() {
      _adicionando = !_adicionando;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEAE0D5),
      appBar: AppBar(
          title: AnimatedDefaultTextStyle(
              child: Text('Hobby Tracker'),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: _adicionando ? Color(0xffEAE0D5) : Color(0xff3C3C3C)),
              duration: Duration(milliseconds: 350)),
          centerTitle: true,
          backgroundColor:
              _adicionando ? Colors.black.withOpacity(0.5) : Color(0xffEAE0D5)),
      body: Stack(children: [
        Column(children: [
          HobbyAdicionado(),
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
                  onPressed: _editandoToggle,
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
          // SizedBox(height: 30),
          // Container(height: 100, width: 100, color: Color(0xff087E8B)),
          // // * cyan
          // Container(height: 100, width: 100, color: Color(0xffFF5A5F)),
          // // * red
          // Container(height: 100, width: 100, color: Color(0xff3C3C3C)),
          // // * black
          // Container(height: 100, width: 100, color: Color(0xffEAE0D5)),
          // // * beige
          // Container(height: 100, width: 100, color: Color(0xff81725F)),
          // * brown
        ]),
        IgnorePointer(
          ignoring: !_adicionando,
          child: AnimatedOpacity(
              opacity: _adicionando ? 1.0 : 0.0,
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
                    decoration: BoxDecoration(
                        color: Color(0xff3C3C3C),
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      15, 15, 7.5, 15),
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: TextButton(
                                        onPressed: _editandoToggle,
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
                                  padding: const EdgeInsets.fromLTRB(
                                      7.5, 15, 15, 15),
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: TextButton(
                                        onPressed: _editandoToggle,
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
        )
      ]),
    );
  }
}

class HobbyAdicionado extends StatelessWidget {
  const HobbyAdicionado({super.key});

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
                'Nome do Hobby',
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
                    '1h30min',
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
                child: Icon(
                  Icons.mode_edit_outlined,
                  color: Colors.white,
                  size: 35,
                )))
      ],
    );
  }
}
