import 'dart:io';
import 'package:Ahteeg/constants/placeholders.dart' as placeholders;
import 'package:Ahteeg/helpers/compute_hash.dart';
import 'package:Ahteeg/models/enums.dart';
import 'package:Ahteeg/widgets/visualizer.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class HashPage extends StatefulWidget {
  @override
  _HashPageState createState() => _HashPageState();
}

class _HashPageState extends State<HashPage> with AutomaticKeepAliveClientMixin<HashPage> {

  TextEditingController _controller = TextEditingController();
  States _state = States.normal;
  File _file;
  var _results;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(border: UnderlineInputBorder(), labelText: 'Enter a string'),
            textInputAction: TextInputAction.done,
            onSubmitted: (text) {
              if(text.isNotEmpty)
                setState(() {
                  _file = null;
                });
            },
            minLines: 1,
            maxLines: 10,
            maxLength: null,
          ),
          FlatButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              
              FilePickerResult result = await FilePicker.platform.pickFiles(type: FileType.any);
              if(result != null) {
                // print(result.files.single.name);
                setState(() {
                  _file = File(result.files.single.path);
                });
                _controller.clear();
              } else {
                // user cancelled the dialog
              }
            }, 
            child: Text('Choose a file instead'),
            color: Theme.of(context).buttonColor,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text('Selected file: ${_file?.path?.split(Platform.pathSeparator)?.last ?? 'No file selected'}', overflow: TextOverflow.visible, style: Theme.of(context).textTheme.bodyText1),
          ),
          FlatButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              setState(() {
                _file = null;
                _state = States.normal;
              });
              _controller.clear();
            }, 
            child: Text('Clear All'), 
            color: Theme.of(context).errorColor
          ),
          FlatButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              setState(() {
                _state = States.processing;
                _results = null;
              });

              var computed = _controller.text.isNotEmpty ? ComputeHash.hashString(_controller.text) : _file != null ? await ComputeHash.hashFile(_file) : null;
              
              setState(() {
                if(computed != null) {
                  _results = computed;
                  _state = States.finished;
                } else {
                  _state = States.normal;
                }
              });
            }, 
            child: Text('Compute Hashes'), 
            color: Theme.of(context).buttonColor
          ),
          Container(
            padding: const EdgeInsets.only(top: 16),
            alignment: Alignment.center,
            child: 
              _state == States.finished
              ? Visualizer(results: _results, title: 'Time taken by various hash functions (μs)',)
              : Text(_state == States.processing ? placeholders.ProcessingMessage : placeholders.NormalMessage, textAlign: TextAlign.center),
          ),
        ]
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}