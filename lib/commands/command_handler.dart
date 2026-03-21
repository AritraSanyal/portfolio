import 'package:flutter/widgets.dart';

abstract class CommandHandler {
  Future<List<Widget>> execute(List<String> args);
}
