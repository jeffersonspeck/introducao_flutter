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

### ➜ Evolução (passo 1 → 2): o que sai / entra / onde mudar

* **Onde:** `MyHomePage.build`.
* **Sai:** nada (vamos apenas **adicionar** widgets).
* **Entra:** `Progress` e `TaskList` no `body`.
* **Ação:**

  * Se a lista `children` estiver diferente, **substitua** por:

    ```dart
    body: Column(
      children: const [
        Progress(),
        TaskList(),
      ],
    );
    ```
  * **Adicione** ao final do arquivo as classes `Progress`, `TaskList` e `TaskItem` (ver passo 2).

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

### ➜ Evolução (passo 2 → 3): o que sai / entra / onde mudar

* **Onde:** fim do arquivo (criação do `TaskItem`).
* **Sai:** nada.
* **Entra:** `TaskItem` como **Stateful** (com checkbox).
* **Ação:** **cole** abaixo de `TaskList`:

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

---

## 3) Criando um item com estado

Agora sim: cada tarefa vai ter uma caixinha de marcar.
Pra isso, precisamos de **estado**.

**O que está rolando aqui:**

* **`StatefulWidget`** → é um widget que muda ao longo do tempo. Ele sempre vem em dupla: a classe do widget (`TaskItem`) e a classe do estado (`_TaskItemState`), onde ficam as variáveis que podem variar.
* **`setState`** → é a forma de avisar o Flutter: *“o valor mudou, preciso redesenhar essa parte da tela”*. Sem chamar `setState`, o Flutter não sabe que tem algo novo para mostrar.
* **`widget.label`** → como o texto vem da classe `TaskItem` (pai), a classe de estado acessa esse valor usando `widget.label`. É assim que o `State` consegue enxergar os dados imutáveis do seu widget.

**Dica rápida:** tente trocar o `Row` por um `ListTile`. O `ListTile` já tem suporte a `leading` (ícone ou checkbox) e `title` (texto), deixando o código mais limpo e visualmente mais organizado.

### ➜ Evolução (passo 3 → 4): o que sai / entra / onde mudar

* **Onde:** `MyHomePage.build`.
* **Sai:** lista fixa dentro de `TaskList`.
* **Entra:** `List<String> tasks` criada no `build` e passada para `TaskList`.
* **Ação:**

  1. **Declare** no topo do `build`:

  ```dart
  final tasks = <String>[
    'Printar piadas',
    'Enviar memes',
  ];
  ```

  2. **Troque** o `children: const [...]` por:

  ```dart
  children: [
    const Progress(),
    TaskList(tasks: tasks),
  ],
  ```

  3. **Atualize** `TaskList` para receber `List<String>`:

  ```dart
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

---

## 4) Passando uma lista dinâmica

### ➜ Evolução (passo 4 → 5): o que sai / entra / onde mudar

* **Onde:** criar modelo OO e trocar tipos.
* **Sai:** `List<String>`.
* **Entra:** classe `Task` + `List<Task>`.
* **Ação:**

  1. **Adicione** a classe:

  ```dart
  class Task {
    final String label;
    bool isDone;
    Task({required this.label, this.isDone = false});
  }
  ```

  2. **Substitua** no `build`:

  ```dart
  final tasks = <Task>[
    Task(label: 'Printar piadocas'),
    Task(label: 'enviar memes'),
    Task(label: 'Adicionar'),
  ];
  ```

  3. **Atualize** `TaskList` para aceitar `List<Task>`:

  ```dart
  class TaskList extends StatelessWidget {
    final List<Task> tasks;
    const TaskList({super.key, required this.tasks});

    @override
    Widget build(BuildContext context) {
      return Column(
        children: tasks.map((t) => TaskItem(label: t.label)).toList(),
      );
    }
  }
  ```

---

## 5) Criando um objeto `Task`

* **Onde:** `MyHomePage` vira **Stateful** e ganha `TextEditingController` + `_addTask`.
* **Sai:** `MyHomePage extends StatelessWidget`.
* **Entra:** `MyHomePage extends StatefulWidget` + `_MyHomePageState`.
* **Ação (substituição completa do widget):**

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
      _controller.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Planejador')),
        body: Column(
          children: [
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

* **Atualize `TaskList`** para aceitar `onToggle` (vamos centralizar o estado no próximo passo):

  ```dart
  class TaskList extends StatelessWidget {
    final List<Task> tasks;
    final void Function(Task, bool?) onToggle;
    const TaskList({super.key, required this.tasks, required this.onToggle});

    @override
    Widget build(BuildContext context) {
      return Column(
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
  ```

* **Troque `TaskItem`** para **Stateless** e declarativo:

  ```dart
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
        onTap: () => onChanged(!value),
      );
    }
  }
  ```

---

## 6) Estado no pai

### ➜ Evolução (6 final): progresso dinâmico, `ListView`, FAB “Ver marcadas” e polimentos

* **Onde:** `_MyHomePageState`, `Progress`, `TaskList`.
* **Sai:** `TaskList` com `Column`.
* **Entra:** `TaskList` com `ListView.builder`, `Progress(value)`, cálculo de `progress`, `_showChecked`, FAB estendido.
* **Ação (trocas pontuais):**

  1. **Em `_MyHomePageState`**, adicione:

     ```dart
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
     ```
  2. **No `build`**, antes do input:

     ```dart
     Progress(value: progress),
     const SizedBox(height: 12),
     ```
  3. **No `Scaffold`**, adicione o FAB:

     ```dart
     floatingActionButton: FloatingActionButton.extended(
       onPressed: _showChecked,
       icon: const Icon(Icons.list),
       label: const Text('Ver marcadas'),
     ),
     ```
  4. **Troque `TaskList`** para `ListView.builder`:

     ```dart
     class TaskList extends StatelessWidget {
       final List<Task> tasks;
       final void Function(Task, bool?) onToggle;
       const TaskList({super.key, required this.tasks, required this.onToggle});

       @override
       Widget build(BuildContext context) {
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
     ```
  5. **Substitua `Progress`** por uma versão com percentual:

     ```dart
     class Progress extends StatelessWidget {
       final double value;
       const Progress({super.key, required this.value});

       @override
       Widget build(BuildContext context) {
         return Padding(
           padding: const EdgeInsets.all(16.0),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               const Text('Percentual concluído:'),
               const SizedBox(height: 8),
               LinearProgressIndicator(value: value.clamp(0.0, 1.0)),
               const SizedBox(height: 4),
               Text('${(value * 100).toStringAsFixed(0)}% concluído'),
             ],
           ),
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
