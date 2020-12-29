import 'package:Ahteeg/models/timed_output.dart';
import 'package:flutter/material.dart';

class Visualizer extends StatelessWidget {

  final List<TimedOutput> results;

  const Visualizer({Key key, @required this.results}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: List.generate(results.length, (i) => ListTile(title: Text(results[i].title), subtitle: Text(results[i].output),)),
    );
  }
}