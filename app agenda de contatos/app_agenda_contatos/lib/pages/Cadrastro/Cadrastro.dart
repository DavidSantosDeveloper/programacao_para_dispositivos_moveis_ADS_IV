import 'package:flutter/material.dart';
import '../../services/bd.dart';

class CadrastroPage extends StatefulWidget {
  const CadrastroPage({super.key});

  @override
  _CadrastroPageState createState() => _CadrastroPageState();
}

class _CadrastroPageState extends State<CadrastroPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();

  Future<void> _salvarContato() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> novoContato = {
        'nome': _nomeController.text,
        'telefone': _telefoneController.text,
      };
      await BancoDeDadosService.instance.salvar(novoContato);
      Navigator.pop(context, true); // Retorna para a tela anterior e indica que houve uma atualização
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Contato'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um nome';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _telefoneController,
                decoration: InputDecoration(
                  labelText: 'Telefone',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um telefone';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _salvarContato,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}