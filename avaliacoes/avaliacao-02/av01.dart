// Agregação e Composição
import 'dart:convert';

class Dependente {
  late String _nome;

  Dependente(String nome) {
    this._nome = nome;
  }

  Map<String, dynamic> toJson() {
  return {
    "nome": _nome,
    };
  }
}

class Funcionario {
  late String _nome;
  late List<Dependente> _dependentes;

  Funcionario(String nome, List<Dependente> dependentes) {
    this._nome = nome;
    this._dependentes = dependentes;
  }

  Map<String, dynamic> toJson() {
  return {
    "nome": _nome,
    "dependentes": _dependentes.map((dep) => dep.toJson()).toList(),
    };
  }
}


class EquipeProjeto {
  late String _nomeProjeto;
  late List<Funcionario> _funcionarios;

  EquipeProjeto(String nomeprojeto, List<Funcionario> funcionarios) {
    _nomeProjeto = nomeprojeto;
    _funcionarios = funcionarios;
    }
    Map<String, dynamic> toJson() {
  return {
    "nomeProjeto": _nomeProjeto,
    "funcionarios": _funcionarios.map((func) => func.toJson()).toList(),
    };
  }
}

void main() {
  // 1. Criar varios objetos Dependentes
  var dependente1 = Dependente("Dependente1");
  var dependente2 = Dependente("Dependente2");
  var dependente3 = Dependente("Dependente3");

  // 2. Criar varios objetos Funcionario 
  // 3. Associar os Dependentes criados aos respectivos funcionarios
  var funcionario1 = Funcionario("Funcionario1", [dependente1]);
  var funcionario2 = Funcionario("Funcionario2", [dependente2]);
  var funcionario3 = Funcionario("Funcionario3", [dependente3]);

  // 4. Criar uma lista de Funcionarios
  var listaFuncionarios = [funcionario1, funcionario2, funcionario3];

  // 5. criar um objeto Equipe Projeto chamando o metodo contrutor que da nome ao projeto e insere uma coleção de funcionario
  var equipeProjeto = EquipeProjeto("GarfoGrau", listaFuncionarios);

  // 6. Printar no formato JSON o objeto Equipe Projeto.
  var equipeProjetoJson = jsonEncode(equipeProjeto.toJson());
  print(equipeProjetoJson);
}