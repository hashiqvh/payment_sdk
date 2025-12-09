import 'package:flutter/material.dart';
import 'package:flutter_mospaymentsdk_3_plugin/flutter_mospaymentsdk_3_plugin.dart';
import 'package:flutter_mospaymentsdk_3_plugin/event/success_event.dart';
import 'package:flutter_mospaymentsdk_3_plugin/event/failed_event.dart';
import 'package:flutter_mospaymentsdk_3_plugin/event/command_event.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final FlutterMospaymentsdk3Plugin _paymentPlugin = FlutterMospaymentsdk3Plugin();
  String _statusMessage = 'Ready';

  @override
  void initState() {
    super.initState();
    _setupPaymentListeners();
  }

  void _setupPaymentListeners() {
    // Listen to success events
    _paymentPlugin.onSuccess.listen((SuccessEvent event) {
      setState(() {
        _statusMessage = 'Success: ${event.action} - ${event.result}';
      });
    });

    // Listen to failed events
    _paymentPlugin.onFailed.listen((FailedEvent event) {
      setState(() {
        _statusMessage = 'Failed: ${event.action} - ${event.reason ?? event.reasonCode}';
      });
    });

    // Listen to command events
    _paymentPlugin.onCommand.listen((CommandEvent event) {
      setState(() {
        _statusMessage = 'Command: ${event.action}';
      });
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<void> _initializePayment() async {
    try {
      setState(() {
        _statusMessage = 'Initializing payment SDK...';
      });
      
      await _paymentPlugin.processAction(
        ActionEnum.APP_INIT.name,
        {
          UserRequestParam.USER: 'your_username',
          UserRequestParam.PASSWORD: 'your_password',
        },
      );
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
      });
    }
  }

  Future<void> _processSale() async {
    try {
      setState(() {
        _statusMessage = 'Processing sale...';
      });
      
      await _paymentPlugin.processAction(
        ActionEnum.SALE.name,
        {
          UserRequestParam.AMOUNT: '100.00',
          UserRequestParam.BILL_NUMBER: 'BILL${DateTime.now().millisecondsSinceEpoch}',
        },
      );
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Payment SDK Example',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Status:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _statusMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _initializePayment,
                icon: const Icon(Icons.settings),
                label: const Text('Initialize Payment SDK'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _processSale,
                icon: const Icon(Icons.payment),
                label: const Text('Process Sale'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 20),
              const Text('You have pushed the button this many times:'),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
