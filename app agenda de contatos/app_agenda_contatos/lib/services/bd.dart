import 'package:flutter/material.dart';

import "package:path/path.dart";
import 'package:sqflite/sqflite.dart';




class BancoDeDadosService {
  BancoDeDadosService._privateConstructor();

  static final BancoDeDadosService instance = BancoDeDadosService._privateConstructor();

  late Database db;

  Future<Database> openBanco() async{
      var dataBasePath=await getDatabasesPath();
      String path =join(dataBasePath,"my_db.db");
      var db=await openDatabase(path,version: 1,
      onCreate: (db,versaoRecente) async{
          String sql=
          "CREATE TABLE contatos (id INTEGER PRIMARY KEY AUTOINCREMENT,nome VARCHAR,telefone VARCHAR);";
          await db.execute(sql);
         
      }
      );
      print("Banco: "+db.isOpen.toString());

      return db;
  }


  Future<int> salvar(Map<String,dynamic> dados_cadrastro) async{
    Database db=await openBanco();
    // Map<String,dynamic> dadosContatos={'nome':'Francisco','telefone':'(85) 9 9988-2554'};
    Map<String,dynamic> dadosContatos=dados_cadrastro;
    int idContato=await db.insert('contatos', dadosContatos);

    print(idContato);
    return idContato;
  }

  lerTodosContatos() async {
       var databasesPath = await getDatabasesPath();
        String path = join(databasesPath, 'my_db.db');

      // open the database
      Database database = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        // When creating the db, create the table
      
      });
// Get the records
    List<Map> list = await database.rawQuery('SELECT * FROM contatos');
    print(list);

  // Close the database
    await database.close();

    return list;


  }

  Future<void> dropTable() async {
    await db.execute('DROP TABLE IF EXISTS contatos');

    print("Tabela deletada");
  }

  Future<int> delete(int id_contato) async {
    final db = await openBanco();
    var resultado= await db.delete('contatos', where: 'id = ?', whereArgs: [id_contato]);

    print("Contato deletado id''"+id_contato.toString());

    return resultado;
  }
   Future<int> update(Map<String, dynamic> contato) async {
    final db = await openBanco();
    var resultado = await db.update('contatos', contato, where: 'id = ?', whereArgs: [contato['id']]);
    print("Contato atualizado id: " + contato['id'].toString());
    return resultado;
  }


}