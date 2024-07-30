import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart';
import 'dart:io';

void main() async {
  // Determina o caminho do banco de dados
  final dbPath = join(Directory.current.path, 'alunos.db');

  // Abre o banco de dados
  final database = sqlite3.open(dbPath);

  // Cria a tabela TB_ALUNO se não existir
  database.execute('''
    CREATE TABLE IF NOT EXISTS TB_ALUNO (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL
    );
  ''');

  // Função para gravar dados na tabela TB_ALUNO
  void gravarDados() {
    print('Digite o nome do aluno:');
    final nome = stdin.readLineSync();

    if (nome != null && nome.isNotEmpty) {
      final stmt = database.prepare('INSERT INTO TB_ALUNO (nome) VALUES (?)');
      stmt.execute([nome]);
      stmt.dispose();
      print('Dados gravados com sucesso!');
    } else {
      print('Nome não pode ser vazio!');
    }
  }

  // Função para ler dados da tabela TB_ALUNO
  void lerDados() {
    final ResultSet result = database.select('SELECT id, nome FROM TB_ALUNO');

    print('Lista de Alunos:');
    for (final Row row in result) {
      print('ID: ${row['id']}, Nome: ${row['nome']}');
    }
  }

  // Menu de opções
  void mostrarMenu() {
    print('Menu:');
    print('1. Gravar dados');
    print('2. Ler dados');
    print('3. Sair');
  }

  mostrarMenu();

  while (true) {
    print('Digite a opção:');
    final opcao = stdin.readLineSync();

    switch (opcao) {
      case '1':
        gravarDados();
        mostrarMenu();
        break;
      case '2':
        lerDados();
        mostrarMenu();
        break;
      case '3':
        print('Saindo...');
        database.dispose();
        return;
      default:
        print('Opção inválida!');
        mostrarMenu();
    }
  }
}
