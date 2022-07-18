import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:goauto/config/setup_dependencies.dart';
import 'package:goauto/firebase_options.dart';
import 'package:goauto/modules/clients/use_cases/create_client/create_client_widget.dart';
import 'package:goauto/modules/orders/use_cases/create_order/create_order_widget.dart';
import 'package:goauto/modules/orders/use_cases/list_orders/list_orders_widget.dart';
import 'package:goauto/modules/providers/use_cases/create_provider/create_provider_widget.dart';
import 'package:goauto/modules/vehicles/use_cases/create_vehicle/create_vehicle_widget.dart';

void main() async {
  setupDependencies();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oficina'),
      ),
      body: Column(
        children: [
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CreateClientWidget(),
              ));
            },
            child: const Text('Cadastrar cliente'),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CreateProviderWidget(),
              ));
            },
            child: const Text('Cadastrar fornecedores'),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CreateVehicleWidget(),
              ));
            },
            child: const Text('Cadastrar veículo'),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CreateOrderWidget(),
              ));
            },
            child: const Text('Cadastrar ordens de serviço'),
          ),
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ListOrdersWidget(),
              ));
            },
            child: const Text('Listar ordens de serviço'),
          ),
        ],
      ),
    );
  }
}
