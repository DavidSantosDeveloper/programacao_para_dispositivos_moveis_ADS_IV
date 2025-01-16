import 'package:app_agenda_contatos/pages/EditarCadrastro/EditarContatoPage.dart';
import 'package:flutter/material.dart';
import "package:path/path.dart";
import 'package:sqflite/sqflite.dart';
import '../../services/bd.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  List dadosContatosBd = [];
  late Database db;

  @override
  void initState() {
    super.initState();
    _initDb();
  }

  Future<void> _initDb() async {
    db = await _openBanco();
    _lerBd();
    // _dropTable();
  }

  Future<Database> _openBanco() async {
    var dataBasePath = await getDatabasesPath();
    String path = join(dataBasePath, "my_db.db");
    var db = await openDatabase(path, version: 1, onCreate: (db, versaoRecente) async {
      String sql = "CREATE TABLE contatos (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, telefone VARCHAR);";
      await db.execute(sql);
    });
    print("Banco: " + db.isOpen.toString());
    return db;
  }

  Future<void> _lerBd() async {
    List<Map> list = await db.rawQuery('SELECT * FROM contatos');
    print(list);
    setState(() {
      dadosContatosBd = list;
    });
  }

  Future<void> _salvar() async {
    Map<String, dynamic> dadosContatos = {'nome': 'Francisco', 'telefone': '(85) 9 9988-2554'};
    await db.insert('contatos', dadosContatos);
    await _lerBd();
  }

  Future<void> _dropTable() async {
    await db.execute('DROP TABLE IF EXISTS contatos');
    print("Tabela deletada");
    _lerBd();
  }

  void navegarParaTelaCadrastro(BuildContext context) {
    Navigator.pushNamed(context, "/cadrastro").then((_) {
      _lerBd(); // Recarrega os dados quando voltar da tela de cadastro
    });
  }
  void navegarParaTelaEdicao(BuildContext context, int id, String nome, String telefone) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarContatoPage(id: id, nome: nome, telefone: telefone),
      ),
    ).then((result) {
      if (result == true) {
        _lerBd(); // Recarrega os dados quando voltar da tela de edição
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Agenda de Contatos"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: dadosContatosBd.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(dadosContatosBd[index]["id"].toString() + ". " + dadosContatosBd[index]['nome']),
                    subtitle: Text(dadosContatosBd[index]['telefone']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Adicione a lógica para editar os dados aqui
                            print("Editar contato: ${dadosContatosBd[index]['id']}");
                            navegarParaTelaEdicao(
                              context,
                              dadosContatosBd[index]["id"],
                              dadosContatosBd[index]['nome'],
                              dadosContatosBd[index]['telefone'],
                            );

                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await BancoDeDadosService.instance.delete(dadosContatosBd[index]["id"]);
                            print("Contato deletado com sucesso!");
                            _lerBd(); // Recarrega os dados após a exclusão
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navegarParaTelaCadrastro(context),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
