# Meu Primeiro Código em Flutter com OO e Widgets

---

## 0) Antes de começar

O que vamos construir juntos:

* Um aplicativo simples chamado **“Planejador (TO-DO)”**, que será a nossa base para aprender os principais conceitos do Flutter.
* Ao longo do caminho, vamos descobrir como o Flutter organiza tudo em **classes** e como cada parte da interface é representada por um **widget**.
* Vamos aprender a diferença entre widgets que não mudam (**StatelessWidget**) e widgets que podem reagir às ações do usuário (**StatefulWidget**).
* Também vamos entender como o Flutter mantém uma **árvore de widgets**, ou seja, uma hierarquia onde cada widget pode conter outros widgets, formando toda a tela.
* Por fim, vamos aplicar um pouco de **orientação a objetos** criando uma classe própria (`Task`) para representar cada tarefa, mostrando como o Flutter combina programação orientada a objetos com construção de interfaces.

**Dica importante**: no Flutter, tudo é um **widget**. Um botão, um texto, uma imagem, uma barra de progresso, até mesmo o aplicativo inteiro!
A tela do app nada mais é do que uma grande árvore de widgets que o Flutter monta e reconstrói conforme o estado muda.

Nosso plano é começar pequeno e ir passo a passo: primeiro com uma **lista fixa**, depois uma **lista dinâmica** e, por fim, evoluindo para um **modelo orientado a objetos**, deixando o app mais organizado e realista.

---

## 1) Estrutura básica do app

Esse é o mínimo para um app Flutter rodar:

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TO-DO!',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Planejador!')),
      body: Column(
        children: const [
          Progress(),
          TaskList(),
        ],
      ),
    );
  }
}
```

**O que esse código faz:**

* **`main`** → é o ponto de entrada do app Flutter. Sempre que você roda o app, a execução começa por aqui.
* **`runApp`** → inicializa o Flutter e coloca o widget que você passar como raiz da aplicação. No nosso caso, ele está recebendo o `MyApp`.
* **`MaterialApp`** → é o widget que configura o aplicativo inteiro. Ele define coisas como o tema visual (cores, estilos), o título e qual será a primeira tela exibida.
* **`Scaffold`** → funciona como um “esqueleto” da tela, fornecendo estrutura pronta para AppBar (barra superior), body (conteúdo principal), botões flutuantes etc.

**Hora do teste:** rode o código e você deve ver uma tela com a barra de título azul na parte superior e o texto do AppBar. O resto da tela ainda está vazio — e é aí que vamos começar a colocar nossos widgets.

---

## 2) Criando widgets fixos

Agora dá pra adicionar duas partes:

1. Uma barra de progresso.
2. Uma lista de tarefas, ainda fixa.

```dart
class Progress extends StatelessWidget {
  const Progress({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text('Percentual concuído:'),
        LinearProgressIndicator(value: 0.0),
      ],
    );
  }
}

class TaskList extends StatelessWidget {
  const TaskList({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        TaskItem(label: 'Lavar as roupas'),
        TaskItem(label: 'Levar o cachorro para passear'),
        TaskItem(label: 'Chegar antes das 19:20'),
      ],
    );
  }
}
```

**O que dá pra tirar dessa parte do código:**

* **`StatelessWidget`** → é um widget “parado”, que não muda depois de criado. Ele serve só para exibir algo na tela com base nos dados que recebeu. Um exemplo clássico: um texto fixo ou um ícone.
* **`LinearProgressIndicator`** → é a barrinha de progresso que anda de 0 a 100%. Aqui ela está com valor fixo em `0.0`, ou seja, sempre vai aparecer vazia. Mais pra frente podemos ligar isso ao progresso real das tarefas.
* **`Column`** → é um widget de layout. Ele coloca seus filhos **um abaixo do outro**, criando uma pilha vertical. Se quisesse organizar na horizontal, usaríamos o `Row`.

Essa parte é importante porque mostra como o Flutter mistura **conteúdo** (`Text`, `ProgressBar`) com **layout** (`Column`) para montar a interface.

---

## 3) Criando um item com estado

Agora sim: cada tarefa vai ter uma caixinha de marcar.
Pra isso, precisamos de **estado**.

```dart
class TaskItem extends StatefulWidget {
  final String label;
  const TaskItem({super.key, required this.label});
  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  bool? _value = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _value,
          onChanged: (newValue) => setState(() => _value = newValue),
        ),
        Text(widget.label),
      ],
    );
  }
}
```

**O que está rolando aqui:**

* **`StatefulWidget`** → é um widget que muda ao longo do tempo. Ele sempre vem em dupla: a classe do widget (`TaskItem`) e a classe do estado (`_TaskItemState`), onde ficam as variáveis que podem variar.
* **`setState`** → é a forma de avisar o Flutter: *“o valor mudou, preciso redesenhar essa parte da tela”*. Sem chamar `setState`, o Flutter não sabe que tem algo novo para mostrar.
* **`widget.label`** → como o texto vem da classe `TaskItem` (pai), a classe de estado acessa esse valor usando `widget.label`. É assim que o `State` consegue enxergar os dados imutáveis do seu widget.

**Dica rápida:** tente trocar o `Row` por um `ListTile`. O `ListTile` já tem suporte a `leading` (ícone ou checkbox) e `title` (texto), deixando o código mais limpo e visualmente mais organizado.

---

## 4) Passando uma lista dinâmica

Ao invés de escrever tarefa por tarefa na mão, bora criar uma lista e passar pro `TaskList`.

```dart
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = <String>[
      'Printar piadas',
      'Enviar memes',
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Planejador!')),
      body: Column(
        children: [
          const Progress(),
          TaskList(tasks: tasks),
        ],
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  final List<String> tasks;
  const TaskList({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: tasks.map((label) => TaskItem(label: label)).toList(),
    );
  }
}
```

**O que mudou nesse passo:**

* Agora temos uma lista chamada **`tasks`** dentro do `MyHomePage`. Em vez de escrever cada tarefa na mão, colocamos todas dentro dessa lista.
* Essa lista é enviada para o **`TaskList`** pelo construtor. Ou seja, o `TaskList` não sabe mais “de cor” quais tarefas existem, ele recebe os dados prontos de fora.
* Dentro do **`TaskList`**, cada string da lista é transformada em um **`TaskItem`** usando o `.map()`. Isso faz com que o widget crie automaticamente os itens da tela com base nos dados.

Com essa mudança, a lista deixou de ser fixa e virou **flexível**: se você adicionar ou remover um item da lista `tasks`, a interface se adapta sozinha, sem precisar mexer no layout manualmente.

---

## 5) Criando um objeto `Task`

Hora de trazer **Orientação a Objetos** pra cena: vamos modelar uma tarefa como classe.

```dart
class Task {
  final String label;
  bool isDone;
  Task({required this.label, this.isDone = false});
}
```

E no `MyHomePage`:

```dart
final tasks = <Task>[
  Task(label: 'Printar piadocas'),
  Task(label: 'enviar memes'),
  Task(label: 'Adicionar'),
];
```

**Por que isso é legal:**

* Antes cada tarefa era só um **texto**. Agora, com a classe `Task`, cada item tem também um **estado** (`isDone`) que diz se está concluído ou não.
* Com um objeto próprio, fica muito mais fácil **evoluir**: podemos adicionar campos como `priority` (prioridade da tarefa), `deadline` (prazo), `notes` (observações) ou até `assignedTo` (quem vai executar).
* Essa é a parte de **Orientação a Objetos** entrando em cena: em vez de espalhar dados soltos, criamos uma **estrutura organizada** que representa melhor a realidade.

Em outras palavras: agora nossas tarefas não são apenas “strings” jogadas, mas **objetos completos** que carregam informação e podem crescer conforme a necessidade do app.


Boa! 🚀 O **input de texto** que adiciona uma nova tarefa dinamicamente se encaixa **logo depois do passo 5 (criando objeto `Task`)**.

Isso porque:

* No passo 5 você já tem o modelo de objeto (`Task`).
* O próximo passo natural é deixar de ter só a lista fixa no código e permitir que o usuário **digite uma nova tarefa**, que entra nessa lista como um novo objeto.
* Depois disso, você já pode evoluir para o passo 6 (centralizando o estado e progresso).

---

**5.1) – Adicionando tarefas pelo usuário**

```dart
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Task> tasks = [
    Task(label: 'Teste item objeto'),
    Task(label: 'Coisas'),
  ];

  final TextEditingController _controller = TextEditingController();

  void _addTask() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      tasks.add(Task(label: text));
      _controller.clear();
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // boa prática: descartar o controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Planejador')),
      body: Column(
        children: [
          // input + botão
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Nova tarefa',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addTask,
                  child: const Text('Adicionar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: TaskList(
              tasks: tasks,
              onToggle: (task, v) => setState(() => task.isDone = v ?? false),
            ),
          ),
        ],
      ),
    );
  }
}
```

**O que mudou agora:**

* Adicionamos um **TextField** para que o usuário possa digitar o nome da nova tarefa.
* Criamos um botão **Adicionar**, que chama o método `_addTask()` sempre que clicado (ou quando o usuário aperta *Enter* no campo).
* Esse método lê o texto digitado, cria um **novo objeto `Task`** e insere dentro da lista de tarefas.
* Chamamos `setState` para avisar o Flutter que houve mudança; assim, a interface é reconstruída e a nova tarefa aparece imediatamente na tela.
* Também incluímos a chamada a `dispose()` para descartar o controller quando a tela for destruída — uma boa prática que evita vazamentos de memória.

Com isso, o app deixa de depender de uma lista fixa no código e passa a ser **interativo**: o próprio usuário pode criar quantas tarefas quiser, tornando a aplicação dinâmica e realista.

---

## 6) Estado no pai (versão mais organizada)

**Pra fechar, a gente centraliza tudo:**

* O **`MyHomePage`** agora vira um **`StatefulWidget`**, porque é nele que vamos guardar o estado de verdade.
* A **lista de tarefas** e também o **cálculo do progresso** ficam dentro dele — ou seja, o pai é o dono dos dados.
* O **`TaskItem`** deixa de cuidar do próprio estado: ele só mostra o que recebeu (`value`) e avisa quando algo muda (`onChanged`). Assim, cada alteração volta para o pai, que atualiza a lista.
* No fim, colocamos um **botão flutuante** para mostrar quais tarefas foram marcadas, deixando o app mais interativo.

Com isso, o fluxo fica claro:
**Estado no pai → Pai passa dados pros filhos → Filhos avisam quando algo muda → Pai atualiza e reconstrói a tela.**

É exatamente assim que o Flutter recomenda organizar os apps: simples, previsível e fácil de manter.

```dart
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final tasks = <Task>[
    Task(label: 'Teste de aula'),
    Task(label: 'limpar banheiro'),
  ];

  // controller do input
  final TextEditingController _controller = TextEditingController();

  // adiciona nova Task usando o texto digitado
  void _addTask() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      tasks.add(Task(label: text));
      _controller.clear();
    });
  }

  // progresso com proteção para lista vazia
  double get progress {
    if (tasks.isEmpty) return 0.0;
    return tasks.where((t) => t.isDone).length / tasks.length;
  }

  void _showChecked() {
    final checked = tasks.where((t) => t.isDone).map((t) => t.label).toList();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tarefas marcadas'),
        content: Text(checked.isEmpty ? 'Nenhuma' : checked.join('\n')),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // boa prática
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Space Exploration Planner!')),
      body: Column(
        children: [
          // barra de progresso dinâmica
          Progress(value: progress),

          // input + botão adicionar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
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
          ),

          // lista de tarefas rolável
          Expanded(
            child: TaskList(
              tasks: tasks,
              onToggle: (task, v) => setState(() => task.isDone = v ?? false),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showChecked,
        child: const Icon(Icons.list),
      ),
    );
  }
}

class Progress extends StatelessWidget {
  final double value;
  const Progress({super.key, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: LinearProgressIndicator(value: value),
    );
  }
}

class TaskList extends StatelessWidget {
  final List<Task> tasks;
  final void Function(Task, bool?) onToggle;
  const TaskList({super.key, required this.tasks, required this.onToggle});
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: tasks
          .map((t) => TaskItem(
                label: t.label,
                value: t.isDone,
                onChanged: (v) => onToggle(t, v),
              ))
          .toList(),
    );
  }
}

class TaskItem extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;
  const TaskItem({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(value: value, onChanged: onChanged),
      title: Text(label),
      onTap: () => onChanged(!value), // toque alterna o status
    );
  }
}
```

---

## 7) Finalizando

**O que conseguimos aprender e praticar até aqui:**

* No Flutter, **tudo é um widget** – desde um texto até a tela inteira do app.
* O **`StatelessWidget`** serve para partes fixas, enquanto o **`StatefulWidget`** lida com dados que mudam.
* O **`setState`** é o gatilho que pede ao Flutter para reconstruir apenas o pedaço necessário da árvore de widgets.
* Construímos o app em etapas: começamos com uma **lista fixa**, depois passamos para uma **lista dinâmica**, e por fim modelamos um **objeto orientado a objetos (`Task`)** que deixou tudo mais organizado e expansível.

**Desafio extra:**
Adicione um campo `priority` na classe `Task`.
Se a prioridade for **alta**, mostre um ícone 🔴; se for **baixa**, mostre um ícone 🟢 ao lado do texto da tarefa.