// ------------------------------------------------------------
// MEU PRIMEIRO APP FLUTTER: Tarefas + OO + Estado Centralizado
// ------------------------------------------------------------
//
// Objetivos pedagógicos deste código:
// 1) Mostrar a estrutura mínima de um app Flutter (main, runApp, MaterialApp).
// 2) Ilustrar StatelessWidget x StatefulWidget e o papel do método build.
// 3) Evoluir de uma lista fixa para uma dinâmica usando um modelo (classe Task).
// 4) Centralizar o estado no widget pai (MyHomePage) e propagar dados/eventos
//    para filhos (TaskList / TaskItem), calculando progresso e listando marcadas.
//
// Observações importantes para a aula:
// - Tudo que aparece na tela é um Widget (Text, Row, Column, AppBar, etc.).
// - StatelessWidget: não guarda estado interno (apenas recebe dados).
// - StatefulWidget: possui um objeto State associado, onde o estado mutável vive.
// - setState: avisa o framework que o estado mudou e é necessário rebuild na subárvore.
//
// ------------------------------------------------------------

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

/// MyApp é o widget raiz do aplicativo.
/// - É um StatelessWidget porque ele apenas configura o app (tema, home),
///   sem guardar estado próprio.
/// - O nome da classe (MyApp) é livre; o que é "fixo" é a herança e o método build.
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exploration!',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(), // sem const
      debugShowCheckedModeBanner: false,
    );
  }
}

/// Modelo de domínio (Orientação a Objetos):
/// - Representa uma Tarefa com rótulo (label) e status (isDone).
/// - Evoluir de List<String> para List<Task> dá clareza e facilita futuras extensões
///   (ex.: prioridade, prazo, responsável, etc.).
class Task {
  final String label; // dado imutável após construção
  bool isDone;        // estado mutável (marcada ou não)

  Task({required this.label, this.isDone = false});
}

/// MyHomePage controla o ESTADO da tela:
/// - Torna-se StatefulWidget para guardar a lista de tarefas (List<Task>).
/// - Calcula progresso com base nas tarefas concluídas.
/// - Fornece callbacks para filhos alterarem o estado.
/// - Mostra um botão (FAB) para listar as tarefas marcadas.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  /// createState é "fixo" em StatefulWidgets: cria o objeto de estado associado.
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

/// _MyHomePageState é a classe que guarda o estado mutável.
/// - O sublinhado (_) torna a classe privada ao arquivo (escopo de biblioteca em Dart).
class _MyHomePageState extends State<MyHomePage> {
  final List<Task> tasks = <Task>[
    // Task(label: 'Teste de aula'),
    // Task(label: 'aow potência'),
    // Task(label: 'aqui jacaré'),
    // Task(label: 'sai de mim ticotico'),
    // Task(label: 'vai aguentar'),
  ];

  // 1) declare sem 'late' e sem inicializar aqui
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // 2) inicialize no initState
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    // 3) descarte corretamente
    _controller.dispose();
    super.dispose();
  }

  void _addTask() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      tasks.add(Task(label: text));
      _controller.clear();
    });
  }

  double get progress {
    if (tasks.isEmpty) return 0.0;
    return tasks.where((t) => t.isDone).length / tasks.length;
  }

  void _showChecked() {
    final checked = tasks.where((t) => t.isDone).map((t) => '• ${t.label}').toList();
    final content = checked.isEmpty ? 'Nenhuma tarefa marcada.' : checked.join('\n');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tarefas marcadas'),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Planejador!')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Progress(value: progress),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller, // 4) garante que não é null/undefined
                    decoration: const InputDecoration(
                      labelText: 'Nova tarefa',
                      hintText: 'Digite a descrição...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _addTask,
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TaskList(
                tasks: tasks,
                onToggle: (task, v) => setState(() => task.isDone = v ?? false),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showChecked,
        icon: const Icon(Icons.list),
        label: const Text('Ver marcadas'),
      ),
    );
  }
}
/// Widget de progresso (Stateless):
/// - Recebe apenas um valor (0.0..1.0) e exibe a barra.
/// - Não guarda estado; é derivado do estado do pai.
class Progress extends StatelessWidget {
  final double value; // 0.0 a 1.0

  const Progress({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Padding apenas para arejar a UI
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Percentual concluído:'),
          const SizedBox(height: 8),
          // LinearProgressIndicator aceita null (anima indeterminado) ou 0..1
          LinearProgressIndicator(value: value.clamp(0.0, 1.0)),
          const SizedBox(height: 4),
          // Exibe a porcentagem ao lado para reforçar o conceito
          Text('${(value * 100).toStringAsFixed(0)}% concluído'),
        ],
      ),
    );
  }
}

/// Lista de tarefas (Stateless):
/// - Recebe os dados (List<Task>) e a função de toggle.
/// - Usa ListView.builder para performance (renderiza só o visível).
class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final void Function(Task, bool?) onToggle;

  const TaskList({super.key, required this.tasks, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    // Em listas pequenas, Column funcionaria; porém ListView.builder
    // é a abordagem correta para listas potencialmente grandes/roláveis.
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final t = tasks[index];
        return TaskItem(
          label: t.label,
          value: t.isDone,
          onChanged: (v) => onToggle(t, v),
        );
      },
    );
  }
}

/// Item de tarefa (Stateless):
/// - Note que NÃO guarda estado próprio; recebe `value` e `onChanged`.
/// - Essa decisão didática mostra “estado levantado” no pai (boa prática).
class TaskItem extends StatelessWidget {
  final String label;                 // texto a exibir
  final bool value;                   // se está marcada
  final ValueChanged<bool?> onChanged; // callback quando o usuário clica

  const TaskItem({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // ListTile dá uma linha padrão com leading/title/trailing
    return ListTile(
      leading: Checkbox(
        value: value,
        onChanged: onChanged, // ao clicar, chama a função recebida do pai
      ),
      title: Text(label),
      // Visual feedback simples: risco no texto quando marcado
      subtitle: value ? const Text('Concluída', style: TextStyle(color: Colors.green)) : null,
      // Alternativamente, poderíamos permitir toque na linha inteira:
      onTap: () => onChanged(!value),
    );
  }
}