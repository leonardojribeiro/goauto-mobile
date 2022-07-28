import 'package:flutter/material.dart';

class DialogConfirmWidget extends StatelessWidget {
  const DialogConfirmWidget({
    Key? key,
    required this.title,
    required this.body,
  }) : super(key: key);

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        OutlinedButton(
          onPressed: Navigator.of(context).pop,
          child: const Text('Não'),
        ),
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red),
          ),
          child: const Text(
            'Sim',
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}

Future<bool?> showConfirmDialog({required BuildContext context, required String title, required String body}) async {
  return showDialog<bool>(
    context: context,
    builder: (context) => DialogConfirmWidget(
      body: body,
      title: title,
    ),
  );
}
