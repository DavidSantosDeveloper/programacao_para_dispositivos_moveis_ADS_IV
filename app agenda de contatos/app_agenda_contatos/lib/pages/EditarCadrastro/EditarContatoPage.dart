import 'package:flutter/material.dart';
import '../../services/bd.dart';

class EditarContatoPage extends StatefulWidget {
  final int id;
  final String nome;
  final String telefone;

  const EditarContatoPage({Key? key, required this.id, required this.nome, required this.telefone}) : super(key: key);

  @override
  _EditarContatoPageState createState() => _EditarContatoPageState();
}

class _EditarContatoPageState extends State<EditarContatoPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _telefoneController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.nome);
    _telefoneController = TextEditingController(text: widget.telefone);
  }

  Future<void> _updateContact() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> updatedContact = {
        'id': widget.id,
        'nome': _nomeController.text,
        'telefone': _telefoneController.text,
      };
      await BancoDeDadosService.instance.update(updatedContact);
      Navigator.pop(context, true); // Retorna para a tela anterior e indica que houve uma atualização
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Contato'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefoneController,
                decoration: InputDecoration(labelText: 'Telefone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um telefone';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateContact,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}