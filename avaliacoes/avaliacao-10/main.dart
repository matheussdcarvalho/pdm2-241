import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matheus Carvalho',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  String? _date;
  String? _email;
  String? _cpf;
  String? _value;

  bool isValidCPF(String cpf) {
    // Verificar CPF
    // Fonte: https://pt.wikipedia.org/wiki/Cadastro_de_Pessoas_Físicas
    int soma = 0;
    int peso = 10;
    for (int i = 0; i < 9; i++) {
      soma += int.parse(cpf[i]) * peso;
      peso--;
    }
    int resto = soma % 11;
    if (resto < 2) {
      return int.parse(cpf[9]) == 0;
    } else {
      return int.parse(cpf[9]) == 11 - resto;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário com Validação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              //Campo de data
              TextFormField(
                decoration: InputDecoration(labelText: 'Data'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  } else if (!RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(value)) {
                    return 'Formato de data inválido (dd/mm/aaaa)';
                  }
                  return null;
                },
                onSaved: (value) => setState(() => _date = value),
              ),
              // Campo de Email
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)) {
                    return 'Formato de email inválido';
                  }
                  return null;
                },
                onSaved: (value) => setState(() => _email = value),
              ),

              //Campo de CPF
              TextFormField(
                decoration: InputDecoration(labelText: 'CPF'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  } else if (!RegExp(r'^\d{11}$').hasMatch(value)) {
                    return 'Formato de CPF inválido';
                  } else if (!isValidCPF(value)) {
                    return 'CPF inválido';
                  }
                  return null;
                },
                onSaved: (value) => setState(() => _cpf = value),
              ),

              //Campo de valor
              TextFormField(
                decoration: InputDecoration(labelText: 'Valor'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  } else if (num.tryParse(value) == null) {
                    return 'Valor inválido';
                  }
                  return null;
                },
                onSaved: (value) => setState(() => _value = value),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Imprimindo dados validados
                    print('Dados validados:');
                    print('Data: $_date');
                    print('Email: $_email');
                    print('CPF: $_cpf');
                    print('Valor: $_value');
                  }
                },
                child: Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}