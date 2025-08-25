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


Links úteis:
* https://docs.flutter.dev/resources/architectural-overview

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

### Códigos Extras (Brinque e aprenda)

No `Scaffold`, além de `appBar` e `body`, você tem vários “slots” e ajustes úteis. Os mais usados:

**Navegação e ações**

* `drawer` / `endDrawer`: menus laterais (esquerda/direita).
* `floatingActionButton`: botão de ação flutuante.
* `floatingActionButtonLocation` / `floatingActionButtonAnimator`: posição e animação do FAB.
* `bottomNavigationBar`: barra de navegação inferior (ex.: `NavigationBar`, `BottomNavigationBar`).
* `bottomSheet`: sheet **persistente** preso ao rodapé (para modal, use `showModalBottomSheet`).
* `persistentFooterButtons`: botões fixos no rodapé (ex.: “Salvar”, “Cancelar”).

**Aparência e layout**

* `backgroundColor`: cor de fundo do conteúdo.
* `extendBody`: estende o corpo por trás da barra inferior (transparências).
* `extendBodyBehindAppBar`: conteúdo por trás da AppBar (útil com imagens hero/cover).
* `resizeToAvoidBottomInset`: controla se o layout “sobe” ao abrir o teclado.

**Gavetas (drawers) – comportamento**

* `drawerScrimColor`: cor do “véu” ao abrir o drawer.
* `drawerEdgeDragWidth`: largura da borda sensível ao gesto de abrir.
* `drawerEnableOpenDragGesture` / `endDrawerEnableOpenDragGesture`: habilita/desabilita gesto.
* `onDrawerChanged` / `onEndDrawerChanged`: callback ao abrir/fechar.

**Restauração/estado**

* `restorationId`: integra com restauração de estado (restoration APIs).

**Métodos úteis (via estado/mensageiro)**

* `ScaffoldMessenger.of(context).showSnackBar(...)`: mostrar SnackBar.
* `Scaffold.of(context).openDrawer()` / `openEndDrawer()`: abrir gavetas por código.
* `Scaffold.of(context).showBottomSheet(...)`: abrir bottom sheet persistente.

Exemplo compacto juntando vários:

```dart
Scaffold(
  appBar: AppBar(title: const Text('My Home Page')),
  body: const Center(child: Text('Conteúdo')),
  drawer: const Drawer(child: Text('Menu')),
  endDrawer: const Drawer(child: Text('Configurações')),
  floatingActionButton: FloatingActionButton(
    onPressed: () {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Olá!')),
      );
    },
    child: const Icon(Icons.add),
  ),
  floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
  bottomNavigationBar: const NavigationBar(
    destinations: [
      NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
      NavigationDestination(icon: Icon(Icons.person), label: 'Perfil'),
    ],
  ),
  bottomSheet: Container(
    height: 48,
    alignment: Alignment.center,
    child: const Text('Sheet persistente'),
  ),
  persistentFooterButtons: [
    TextButton(onPressed: () {}, child: const Text('Cancelar')),
    ElevatedButton(onPressed: () {}, child: const Text('Salvar')),
  ],
  backgroundColor: Colors.white,
  extendBody: true,
  extendBodyBehindAppBar: false,
  resizeToAvoidBottomInset: true,
  drawerScrimColor: Colors.black54,
  onDrawerChanged: (isOpen) => debugPrint('Drawer aberto? $isOpen'),
);
```

O próximo código é um **playground**: dentro do `Scaffold` há uma `Column` com **17 blocos comentados** que mostram padrões comuns de interface no Flutter. A ideia é **descomentar um bloco por vez** para ver o comportamento e entender **quando usar** cada componente.

> Dica importante: muitos blocos contêm widgets **não-const** (`TextField`, `ListView`, etc.). Quando você descomentar algo assim, **remova o `const`** da lista: troque
> `children: const [ ... ]` → `children: [ ... ]`.
> Blocos com rolagem (ListView/Grid/CustomScrollView) **já vêm dentro de `Expanded`** para evitar erro de “unbounded height”.

## Estrutura do app

* `main()` → roda `MyApp`.
* `MyApp` → configura `MaterialApp` (título/tema) e define a tela inicial (`home`).
* `MyHomePage` → constrói o `Scaffold` com `AppBar` e um `body` contendo os **blocos de estudo**.

## Como usar os blocos

1. Descomente **apenas um bloco** (ou alguns compatíveis) por vez.
2. Se o bloco tiver widgets não-const, remova o `const` dos `children`.
3. Para blocos de lista, grid, slivers ou animações em área central, **mantenha o `Expanded`** que já está no exemplo.
4. Para testar SnackBar/Dialog/Navigation, substitua os `onPressed: null` por callbacks reais.

## O que cada seção demonstra (1–17)

1. **Barras de progresso**
   `LinearProgressIndicator` e `CircularProgressIndicator`, em modo **indeterminado** (carregando) ou com **valor** (0.0–1.0).

2. **Entrada + botões**
   `TextField` com `OutlineInputBorder` e `ElevatedButton`. Padrão de **form control + ação**.

3. **Lista rolável (ListView)**
   `ListView` com `ListTile`. Use para **listas verticais** extensas; precisa estar contido (ex.: `Expanded`).

4. **Grade (GridView)**
   `GridView.count` para **grades simples** (ícones, cards). Controle por `crossAxisCount`.

5. **Sobreposição (Stack)**
   `Stack` + `Positioned` para **flutuar elementos** (ex.: botão flutuante sobre imagem).

6. **Layouts utilitários**
   `SizedBox`, `Padding`, `Center`, `Align`, `Spacer`. Tijolinhos de **espaçamento e alinhamento**.

7. **Container/Card + tipografia**
   `Card` com `Padding` e `Column`. Bom para **caixas de conteúdo** com título e descrição.

8. **Botões & menus**
   `ElevatedButton`, `OutlinedButton`, `IconButton`, `PopupMenuButton`. Demonstra **ações primárias/secundárias** e **menus de contexto**.

9. **Formulário (Form + TextFormField)**
   Estrutura base para **validação** e **salvamento** de dados. Ideal para telas de cadastro.

10. **Imagens/Ícones**
    `FlutterLogo`, `Icon`, e espaço para `Image.network(...)`. Mostra **recursos visuais** básicos.

11. **Assíncrono (Future/Stream)**
    `FutureBuilder` (resultado único) e `StreamBuilder` (atualizações contínuas). Essenciais para **dados assíncronos**.

12. **Slivers (CustomScrollView)**
    `SliverAppBar` com `SliverList`. Base para telas com **AppBar colapsável** e listas de alta performance.

13. **Responsividade (LayoutBuilder)**
    Adapta o conteúdo conforme `constraints.maxWidth`. Útil para **layout adaptativo** (mobile/tablet/web).

14. **Gestos**
    `InkWell` com `onTap`. Fornece **feedback visual** e detecção de toques.

15. **Animação simples**
    `AnimatedContainer` (tamanho/cor/borda com `duration`). Porta de entrada para **animações declarativas**.

16. **Navegação (placeholder)**
    `Navigator.of(context).push(...)` para ir a outra página. Mostra o ponto de **integração com rotas**.

17. **Feedback (SnackBar/Dialog)**
    Como exibir `SnackBar` via `ScaffoldMessenger` e `AlertDialog` com `showDialog`. **Mensagens ao usuário**.

## Boas práticas e pegadinhas

* **Unbounded height**: Listas/grades dentro de `Column` **precisam** de `Expanded` (já incluído).
* **`const` na lista**: se descomentar widgets dinâmicos, **remova o `const`** em `children`.
* **Estados**: este exemplo é `StatelessWidget`; para entrada de dados real, troque para `StatefulWidget` (controladores, `setState`).
* **Acessibilidade**: prefira `TextButton/OutlinedButton/ElevatedButton` em vez de `GestureDetector` puro, e sempre defina rótulos claros.
* **Temas**: centralize cores/tipografia em `ThemeData` para consistência.

Com isso, você tem um **catálogo prático** para demonstrar os principais blocos de UI no Flutter e discutir quando e por que escolher cada padrão.

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
          // ---------------------------------------------
          // 1) BARRAS DE PROGRESSO / STATUS
          // ---------------------------------------------
          // LinearProgressIndicator(), // indeterminado
          // LinearProgressIndicator(value: 0.35), // 35%
          // CircularProgressIndicator(), // indeterminado

          // ---------------------------------------------
          // 2) CAMPO DE ENTRADA + BOTÕES
          // ---------------------------------------------
          // Padding(
          //   padding: EdgeInsets.all(12),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: TextField(
          //           decoration: InputDecoration(
          //             labelText: 'Nova tarefa',
          //             border: OutlineInputBorder(),
          //           ),
          //         ),
          //       ),
          //       SizedBox(width: 8),
          //       ElevatedButton(onPressed: null, child: Text('Adicionar')),
          //     ],
          //   ),
          // ),

          // ---------------------------------------------
          // 3) LISTA ROLÁVEL (LISTVIEW)
          // ---------------------------------------------
          // Expanded(
          //   child: ListView(
          //     children: [
          //       ListTile(title: Text('Item 1')),
          //       ListTile(title: Text('Item 2')),
          //     ],
          //   ),
          // ),

          // ---------------------------------------------
          // 4) GRID (GRIDVIEW)
          // ---------------------------------------------
          // Expanded(
          //   child: GridView.count(
          //     crossAxisCount: 2,
          //     children: [
          //       Card(child: Center(child: Text('A'))),
          //       Card(child: Center(child: Text('B'))),
          //     ],
          //   ),
          // ),

          // ---------------------------------------------
          // 5) STACK (SOBREPOSIÇÃO)
          // ---------------------------------------------
          // Expanded(
          //   child: Stack(
          //     children: [
          //       Positioned.fill(child: FlutterLogo()),
          //       Positioned(bottom: 16, right: 16, child: CircleAvatar(child: Icon(Icons.play_arrow))),
          //     ],
          //   ),
          // ),

          // ---------------------------------------------
          // 6) LAYOUTS COMUNS
          // ---------------------------------------------
          // SizedBox(height: 12),
          // Padding(padding: EdgeInsets.all(16), child: Text('Seção')),
          // Center(child: Text('Centralizado')),
          // Align(alignment: Alignment.centerRight, child: Text('À direita')),
          // Spacer(), // empurra os widgets acima para o topo

          // ---------------------------------------------
          // 7) CONTAINER / CARD
          // ---------------------------------------------
          // Card(
          //   margin: EdgeInsets.all(12),
          //   child: Padding(
          //     padding: EdgeInsets.all(16),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text('Título', style: TextStyle(fontWeight: FontWeight.bold)),
          //         SizedBox(height: 8),
          //         Text('Descrição do cartão...'),
          //       ],
          //     ),
          //   ),
          // ),

          // ---------------------------------------------
          // 8) BOTÕES & MENUS
          // ---------------------------------------------
          // Wrap(
          //   spacing: 8,
          //   children: [
          //     ElevatedButton(onPressed: null, child: Text('OK')),
          //     OutlinedButton(onPressed: null, child: Text('Cancelar')),
          //     IconButton(onPressed: null, icon: Icon(Icons.settings)),
          //     PopupMenuButton<String>(
          //       itemBuilder: (context) => [
          //         PopupMenuItem(value: 'a', child: Text('Opção A')),
          //         PopupMenuItem(value: 'b', child: Text('Opção B')),
          //       ],
          //     ),
          //   ],
          // ),

          // ---------------------------------------------
          // 9) FORMULÁRIO (FORM + TEXTFORMFIELD)
          // ---------------------------------------------
          // Form(
          //   child: Padding(
          //     padding: EdgeInsets.all(16),
          //     child: Column(
          //       children: [
          //         TextFormField(decoration: InputDecoration(labelText: 'Nome')),
          //         SizedBox(height: 8),
          //         TextFormField(decoration: InputDecoration(labelText: 'Email')),
          //       ],
          //     ),
          //   ),
          // ),

          // ---------------------------------------------
          // 10) IMAGENS / ÍCONES
          // ---------------------------------------------
          // FlutterLogo(size: 72),
          // Icon(Icons.star, size: 32),
          // // Image.network('https://exemplo.com/imagem.png'),

          // ---------------------------------------------
          // 11) CONTEÚDO ASSÍNCRONO (FUTURE/STREAM)
          // ---------------------------------------------
          // Expanded(
          //   child: FutureBuilder<int>(
          //     future: Future.value(42),
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState != ConnectionState.done) {
          //         return Center(child: CircularProgressIndicator());
          //       }
          //       return Center(child: Text('Resultado: ${snapshot.data}'));
          //     },
          //   ),
          // ),
          // Expanded(
          //   child: StreamBuilder<DateTime>(
          //     stream: Stream<DateTime>.periodic(Duration(seconds: 1), (_) => DateTime.now()),
          //     builder: (context, snapshot) {
          //       return Center(child: Text(snapshot.data?.toIso8601String() ?? '...'));
          //     },
          //   ),
          // ),

          // ---------------------------------------------
          // 12) SLIVERS (CUSTOMSCROLLVIEW)
          // ---------------------------------------------
          // Expanded(
          //   child: CustomScrollView(
          //     slivers: [
          //       SliverAppBar(
          //         pinned: true,
          //         expandedHeight: 120,
          //         flexibleSpace: FlexibleSpaceBar(title: Text('Sliver')),
          //       ),
          //       SliverList(
          //         delegate: SliverChildBuilderDelegate(
          //           (context, index) => ListTile(title: Text('Item #$index')),
          //           childCount: 20,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          // ---------------------------------------------
          // 13) LAYOUT RESPONSIVO (LAYOUTBUILDER)
          // ---------------------------------------------
          // LayoutBuilder(
          //   builder: (context, constraints) {
          //     final w = constraints.maxWidth;
          //     if (w < 400) {
          //       return Text('Layout compacto');
          //     }
          //     return Text('Layout amplo');
          //   },
          // ),

          // ---------------------------------------------
          // 14) GESTOS
          // ---------------------------------------------
          // InkWell(
          //   onTap: null,
          //   child: Padding(
          //     padding: EdgeInsets.all(16),
          //     child: Text('Clique aqui'),
          //   ),
          // ),

          // ---------------------------------------------
          // 15) ANIMAÇÃO SIMPLES
          // ---------------------------------------------
          // Expanded(
          //   child: Center(
          //     child: AnimatedContainer(
          //       duration: Duration(milliseconds: 300),
          //       width: 100,
          //       height: 100,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(16),
          //         color: Colors.blue,
          //       ),
          //     ),
          //   ),
          // ),

          // ---------------------------------------------
          // 16) NAVEGAÇÃO (PLACEHOLDER)
          // ---------------------------------------------
          // ElevatedButton(
          //   onPressed: null, // Navigator.of(context).push(...)
          //   child: Text('Ir para outra página'),
          // ),

          // ---------------------------------------------
          // 17) FEEDBACK (SNACKBAR / DIALOG) - PLACEHOLDERS
          // ---------------------------------------------
          // ElevatedButton(
          //   onPressed: null, // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Olá!')))
          //   child: Text('Mostrar SnackBar'),
          // ),
          // ElevatedButton(
          //   onPressed: null, // showDialog(context: context, builder: (_) => AlertDialog(title: Text('Título'), content: Text('Mensagem')))
          //   child: Text('Mostrar Dialog'),
          // ),
        ],
      ),
    );
  }
}
```

---

## 2) Criando widgets fixos

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
    ),
    ```
  * **Adicione** ao final do arquivo as classes `Progress`, `TaskList` e `TaskItem` (ver passo 2).

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

Agora sim: cada tarefa vai ter uma caixinha de marcar.
Pra isso, precisamos de **estado**.

**O que está rolando aqui:**

* **`StatefulWidget`** → é um widget que muda ao longo do tempo. Ele sempre vem em dupla: a classe do widget (`TaskItem`) e a classe do estado (`_TaskItemState`), onde ficam as variáveis que podem variar.
* **`setState`** → é a forma de avisar o Flutter: *“o valor mudou, preciso redesenhar essa parte da tela”*. Sem chamar `setState`, o Flutter não sabe que tem algo novo para mostrar.
* **`widget.label`** → como o texto vem da classe `TaskItem` (pai), a classe de estado acessa esse valor usando `widget.label`. É assim que o `State` consegue enxergar os dados imutáveis do seu widget.

**Dica rápida:** tente trocar o `Row` por um `ListTile`. O `ListTile` já tem suporte a `leading` (ícone ou checkbox) e `title` (texto), deixando o código mais limpo e visualmente mais organizado.

---

## 4) Passando uma lista dinâmica

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

**O que foi feito neste passo (lista dinâmica):**

* A lista de tarefas deixou de ser **fixa** dentro do `TaskList` e passou a ser criada no **pai** (`MyHomePage.build`) como `tasks`.
* O `TaskList` agora **recebe os dados por construtor** e apenas **renderiza** o que chegar — separando **dados** (no pai) de **apresentação** (no filho).
* Foi necessário **remover o `const`** do `children: [...]` porque `TaskList(tasks: tasks)` depende de um **valor dinâmico** (variável), e listas `const` só aceitam expressões constantes.
* Benefícios: **desacoplamento**, **reuso** do componente, e base pronta para evoluir de `List<String>` para `List<Task>` e, depois, permitir **adicionar/remover** itens quando o pai virar **Stateful** (com `setState`).
* Em resumo: o `TaskList` parou de “saber” as tarefas de antemão; ele virou um **componente declarativo** que recebe dados e mostra.

---

## 5) Criando um objeto `Task`

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

**O que foi feito neste passo (lista dinâmica):**

* A lista de tarefas deixou de ser **fixa** dentro do `TaskList` e passou a ser criada no **pai** (`MyHomePage.build`) como `tasks`.
* O `TaskList` agora **recebe os dados por construtor** e apenas **renderiza** o que chegar — separando **dados** (no pai) de **apresentação** (no filho).
* Foi necessário **remover o `const`** do `children: [...]` porque `TaskList(tasks: tasks)` depende de um **valor dinâmico** (variável), e listas `const` só aceitam expressões constantes.
* Benefícios: **desacoplamento**, **reuso** do componente, e base pronta para evoluir de `List<String>` para `List<Task>` e, depois, permitir **adicionar/remover** itens quando o pai virar **Stateful** (com `setState`).
* Em resumo: o `TaskList` parou de “saber” as tarefas de antemão; ele virou um **componente declarativo** que recebe dados e mostra.


**Notas da evolução (lista dinâmica)**

* A lista de tarefas deixou de ser fixa dentro do `TaskList` e passou a ser criada no pai (`MyHomePage.build`) como `tasks`.
* O `TaskList` passou a receber esses dados pelo construtor e apenas renderizá-los, separando **dados** (no pai) de **apresentação** (no filho).
* Foi necessário remover o `const` do `children: [...]` porque agora há um valor **dinâmico** sendo usado (`tasks`); listas `const` só aceitam expressões constantes, e manter o `const` causaria o erro “Not a constant expression”.
* Benefícios: **desacoplamento**, **reuso** do componente e base pronta para evoluir para `List<Task>` e, depois, para um fluxo interativo (com `StatefulWidget` e `setState` para adicionar/remover itens).
* Em resumo: o `TaskList` deixou de “saber” quais tarefas existem e virou um componente **declarativo**, que recebe dados do pai e os mostra.

---

## 6) Adicionando `Task`

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

## 7) Estado no pai

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
**O que aconteceu neste passo (“Adicionando `Task`”):**

* **`MyHomePage` virou `StatefulWidget`** para **guardar o estado real da tela**: a lista de tarefas (`List<Task>`) e o campo de texto. Assim, o pai passa a ser a **fonte única da verdade** dos dados.
* **Criamos um `TextEditingController`** para ler o texto digitado no `TextField` e **fizemos o ciclo de vida correto**: inicialização implícita no construtor e **descartar em `dispose()`** para evitar vazamento de memória.
* **Entrou o método `_addTask()`**: ele lê o texto, valida (ignora vazio), **cria uma nova `Task`** e adiciona na lista **chamando `setState`** — isso dispara o rebuild e a nova tarefa aparece na hora.
* **O `TaskList` ganhou um callback `onToggle`**: agora ele não altera nada por conta própria; quando o usuário marca/desmarca uma tarefa, ele **pede** ao pai (via `onToggle`) para mudar `isDone`. O pai atualiza o modelo e reconstrói.
* **`TaskItem` passou a ser *declarativo* e `Stateless`**: em vez de ter estado interno, ele **recebe** `label`, `value` e `onChanged`. O item só **exibe** e **emite eventos**; quem decide o novo estado é o pai.
  *Isso é o padrão “**levantar o estado**” (lifting state up): estado no ancestral comum, filhos “burros” e previsíveis.*
* **Fluxo de dados ficou unidirecional e claro**:
  Pai (dados) ➜ Filhos (props) ➜ Usuário interage ➜ Filhos emitem evento ➜ Pai atualiza estado com `setState` ➜ UI reconstrói.
* **Consequências visíveis na UI**:
  1. Apareceu uma **linha de input** (campo + botão) para adicionar novas tarefas.
  2. A **lista** agora reflete o modelo (`List<Task>`) e **reage** às ações do usuário (marcar/desmarcar).

* **Boas práticas reforçadas**:
  * **Separação de responsabilidades**: pai gerencia dados; filhos apenas exibem/acionam callbacks.
  * **Ciclo de vida**: sempre **descartar controllers** em `dispose()`.
  * **Previsibilidade**: com componentes puros (stateless), fica mais fácil **testar** e **manter**.
* **Por que isso importa?**
  Esse desenho facilita crescer o app (prioridade, prazo, filtros, persistência), reduz bugs de sincronização e prepara o terreno para arquiteturas mais robustas (Provider/Riverpod/BLoC) sem mudar a ideia central: **um lugar único com o estado e componentes declarativos em volta**.

---

## 8) Finalizando

**O que conseguimos aprender e praticar até aqui:**

* No Flutter, **tudo é um widget** – desde um texto até a tela inteira do app.
* O **`StatelessWidget`** serve para partes fixas, enquanto o **`StatefulWidget`** lida com dados que mudam.
* O **`setState`** é o gatilho que pede ao Flutter para reconstruir apenas o pedaço necessário da árvore de widgets.
* Construímos o app em etapas: começamos com uma **lista fixa**, depois passamos para uma **lista dinâmica**, e por fim modelamos um **objeto orientado a objetos (`Task`)** que deixou tudo mais organizado e expansível.

**Desafio extra:**
Adicione um campo `priority` na classe `Task`.

Se a prioridade for **alta**, mostre um ícone 🔴; se for **baixa**, mostre um ícone 🟢 ao lado do texto da tarefa.
