import 'dart:convert';

import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  //根组件
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Book2',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('主页'),
      ),
      body: const HomePageList(),
    );
  }
}

// 主界面的列表Widget
class HomePageList extends StatelessWidget {
  const HomePageList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(10), children: <Widget>[
      ListTile(
        title: const Text("第四章布局类组件"),
        trailing: const Icon(Icons.featured_play_list_outlined),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AfterLayoutPage(),
            ),
          );
        },
      ),
      ListTile(
        title: const Text("第六章可滚动组件"),
        trailing: const Icon(Icons.interests_rounded),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SingleChildScrollViewDemo()));
        },
      ),
      ListTile(
        title: const Text("第六章可滚动组件2"),
        trailing: const Icon(Icons.alarm_add_outlined),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LazyListPage(),
            ),
          );
        },
      ),
      ListTile(
        title: const Text("文件操作与网络请求"),
        trailing: const Icon(Icons.image_outlined),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ShowImage()));
        },
      ),
    ]);
  }
}

class PointerDownListener extends SingleChildRenderObjectWidget {
  const PointerDownListener({Key? key, this.onPointerDown, Widget? child})
      : super(key: key, child: child);

  final PointerDownEventListener? onPointerDown;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderPointerDownListener()..onPointerDown = onPointerDown;

  @override
  void updateRenderObject(
      BuildContext context, RenderPointerDownListener renderObject) {
    renderObject.onPointerDown = onPointerDown;
  }
}

class RenderPointerDownListener extends RenderProxyBox {
  PointerDownEventListener? onPointerDown;

  @override
  bool hitTestSelf(Offset position) => true; //始终通过命中测试

  @override
  void handleEvent(PointerEvent event, covariant HitTestEntry entry) {
    //事件分发时处理事件
    if (event is PointerDownEvent) onPointerDown?.call(event);
  }
}

//文件操作与网络请求
class ShowImage extends StatelessWidget {
  const ShowImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("文件操作与网络请求"),
      ),
      body: ImagesPage(),
    );
  }
}

class ImagesPage extends StatefulWidget {
  @override
  _ImagesPage createState() => _ImagesPage();
}

class _ImagesPage extends State<ImagesPage> {
  List data = [];
  List imageUrl = [];

  @override
  void initState() {
    super.initState();
    fetchDataOnline();
  }

  Future<String> fetchDataOnline() async {
    var jsonData = await http.get(Uri.parse(
        "https://raw.githubusercontent.com/szh12/flutterbook2/main/static/image_list.json"));
    var fetchData = jsonDecode(jsonData.body);

    print(fetchData);

    setState(() {
      data = fetchData["images"];
      data.forEach((element) {
        imageUrl.add(element);
      });
    });

    return "OK";
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: imageUrl.length,
        itemBuilder: (BuildContext context, int index) {
          return Image.network(imageUrl[index], fit: BoxFit.fitWidth);
        });
  }
}

//第六章可滚动组件
class SingleChildScrollViewDemo extends StatelessWidget {
  const SingleChildScrollViewDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String str = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    return Scaffold(
      appBar: AppBar(
        title: const Text("第六章可滚动组件"),
      ),
      body: Scrollbar(
        // 显示进度条
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              //动态创建一个List<Widget>
              children: str
                  .split("")
                  //每一个字母都用一个Text显示,字体为原来的两倍
                  .map((c) => Text(
                        c,
                        textScaleFactor: 2.0,
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

//第六章可滚动组件2
class LazyListPage extends StatefulWidget {
  const LazyListPage({Key? key}) : super(key: key);

  @override
  _LazyListPageState createState() => _LazyListPageState();
}

class _LazyListPageState extends State<LazyListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('第六章可滚动组件'),
      ),
      body: const InfiniteListView(),
    );
  }
}

class InfiniteListView extends StatefulWidget {
  const InfiniteListView({Key? key}) : super(key: key);

  @override
  _InfiniteListViewState createState() => _InfiniteListViewState();
}

class _InfiniteListViewState extends State<InfiniteListView> {
  @override
  Widget build(BuildContext context) {
    //下划线widget预定义以供复用。
    Widget divider1 = const Divider(
      color: Colors.blue,
    );
    Widget divider2 = const Divider(color: Colors.green);
    return ListView.separated(
      itemCount: 100,
      //列表项构造器
      itemBuilder: (BuildContext context, int index) {
        return ListTile(title: Text("$index"));
      },
      //分割器构造器
      separatorBuilder: (BuildContext context, int index) {
        return index % 2 == 0 ? divider1 : divider2;
      },
    );
  }
}

//第四章布局类组件的实现
class AfterLayoutPage extends StatelessWidget {
  const AfterLayoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('第四章布局类组件'),
      ),
      body: const AfterLayoutRoute(),
    );
  }
}

class AfterLayoutRoute extends StatefulWidget {
  const AfterLayoutRoute({Key? key}) : super(key: key);

  @override
  _AfterLayoutRouteState createState() => _AfterLayoutRouteState();
}

class _AfterLayoutRouteState extends State<AfterLayoutRoute> {
  String _text = 'flutter 实战 ';
  Size _size = Size.zero;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(
            builder: (context) {
              return GestureDetector(
                child: const Text(
                  'Text1: 点我获取我的大小',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blue),
                ),
                onTap: () => print('Text1: ${context.size}'),
              );
            },
          ),
        ),
        AfterLayout(
          callback: (RenderAfterLayout ral) {
            print('Text2: ${ral.size}, ${ral.offset}');
          },
          child: const Text('Text2:flutter@wendux'),
        ),
        Builder(builder: (context) {
          return Container(
            color: Colors.grey.shade200,
            alignment: Alignment.center,
            width: 100,
            height: 100,
            child: AfterLayout(
              callback: (RenderAfterLayout ral) {
                Offset offset = ral.localToGlobal(
                  Offset.zero,
                  ancestor: context.findRenderObject(),
                );
                print('A 在 Container 中占用的空间范围为：${offset & ral.size}');
              },
              child: const Text('A'),
            ),
          );
        }),
        Divider(),
        AfterLayout(
          child: Text(_text),
          callback: (RenderAfterLayout value) {
            setState(() {
              //更新尺寸信息
              _size = value.size;
            });
          },
        ),
        //显示上面 Text 的尺寸
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Text size: $_size ',
            style: const TextStyle(color: Colors.blue),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _text += 'flutter 实战 ';
            });
          },
          child: const Text('追加字符串'),
        ),
      ],
    );
  }
}
