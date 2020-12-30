import 'package:Ahteeg/helpers/compute_cipher.dart';
import 'package:Ahteeg/models/enums.dart';
import 'package:Ahteeg/widgets/visualizer.dart';
import 'package:Ahteeg/constants/placeholders.dart' as placeholders;
import 'package:flutter/material.dart';

class EncryptPage extends StatefulWidget {
  @override
  _EncryptPageState createState() => _EncryptPageState();
}

class _EncryptPageState extends State<EncryptPage> with AutomaticKeepAliveClientMixin<EncryptPage> {

  TextEditingController _stringController = TextEditingController();
  TextEditingController _keyController = TextEditingController();
  TextEditingController _shiftController = TextEditingController();
  States _state = States.normal;
  var _results;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextField(
            controller: _stringController,
            decoration: InputDecoration(border: UnderlineInputBorder(), labelText: 'Enter a string'),
            textInputAction: TextInputAction.done,
            minLines: 1,
            maxLines: 10,
            maxLength: null,
          ),
          TextField(
            controller: _keyController,
            decoration: InputDecoration(border: UnderlineInputBorder(), labelText: 'Enter key (if applicable)'),
            textInputAction: TextInputAction.done,
          ),
          TextField(
            controller: _shiftController,
            decoration: InputDecoration(border: UnderlineInputBorder(), labelText: 'Enter shift/rails (if applicable)'),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FlatButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                setState(() {
                  _results = null;
                  _state = States.normal;
                });
                _stringController.clear();
                _keyController.clear();
                _shiftController.clear();
              }, 
              child: Text('Clear All'), 
              color: Theme.of(context).errorColor
            ),
          ),
          FlatButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();
              setState(() {
                _state = States.processing;
              });
              
              var computed = ComputeCipher.encrypt(
                input: _stringController.text,
                key: _keyController.text,
                shift: _shiftController.text
              );
              
              setState(() {
                if(computed != null) {
                  _results = computed;
                  _state = States.finished;
                } else {
                  _state = States.normal;
                }
              });

            }, 
            child: Text('Encrypt'), 
            color: Theme.of(context).buttonColor
          ),
          Container(
            padding: const EdgeInsets.only(top: 16),
            alignment: Alignment.center,
            child: 
              _state == States.finished
              ? Visualizer(results: _results, chartTitle: 'Time taken by various encryption algorithms (μs)',)
              : Text(_state == States.processing ? placeholders.ProcessingMessage : placeholders.NormalMessage, textAlign: TextAlign.center),
          ),
        ]
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
