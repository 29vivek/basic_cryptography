import 'package:Ahteeg/helpers/axis_themes.dart';
import 'package:Ahteeg/models/timed_output.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Visualizer extends StatefulWidget {

  final List<TimedOutput> results;
  final String chartTitle;

  const Visualizer({Key key, @required this.results, @required this.chartTitle}) : super(key: key);

  @override
  _VisualizerState createState() => _VisualizerState();
}

class _VisualizerState extends State<Visualizer> {

  List<charts.Series<TimedOutput, String>> series;


  @override
  void initState() {
    super.initState();

    series = [
      charts.Series(
        id: "Time",
        data: widget.results,
        domainFn: (TimedOutput output, _) => output.title,
        measureFn: (TimedOutput output, _) => output.duration,
      ),
    ];
  }


  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        if(series != null) // indicator to whether visualize results or not 
          Container(
            height: 400,
            child: Card(
              elevation: 0.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(widget.chartTitle, style: Theme.of(context).textTheme.bodyText1),
                    Expanded(
                      child: charts.BarChart(
                        series, 
                        animate: true, 
                        domainAxis: AxisTheme.domainSpec(),
                        primaryMeasureAxis: AxisTheme.numericAxisSpec(),
                      )
                    )
                  ],
                ),
              ),
            ),
          ),
        ...List.generate(widget.results.length, (i) => ListTile(title: Text(widget.results[i].title), subtitle: Text(widget.results[i].output), onLongPress: () { Clipboard.setData(ClipboardData(text: widget.results[i].output)); })),
      ]
    );
  }
}