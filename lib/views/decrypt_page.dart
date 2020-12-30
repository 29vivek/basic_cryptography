import 'package:Ahteeg/helpers/compute_cipher.dart';
import 'package:Ahteeg/constants/placeholders.dart' as placeholders;
import 'package:Ahteeg/models/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DecryptPage extends StatefulWidget {
  @override
  _DecryptPageState createState() => _DecryptPageState();
}

class _DecryptPageState extends State<DecryptPage> with AutomaticKeepAliveClientMixin<DecryptPage> {
  
  TextEditingController _stringController = TextEditingController();
  TextEditingController _keyController = TextEditingController();
  States _state = States.normal;
  var _result;
  Ciphers _selectedCipher = Ciphers.playfair;

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
            decoration: InputDecoration(border: UnderlineInputBorder(), labelText: 'Enter key/shift/rails'),
            textInputAction: TextInputAction.done,
          ),
          ...List.generate(
            Ciphers.values.length, 
            (i) => RadioListTile<Ciphers>(
                value: Ciphers.values[i], 
                groupValue: _selectedCipher, 
                title: Text(Ciphers.values[i].toString().split('.').last),
                onChanged: (Ciphers cipher) {
                  setState(() {
                    _selectedCipher = cipher;
                  });
                }
              )
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FlatButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                setState(() {
                  _result = null;
                  _state = States.normal;
                });
                _stringController.clear();
                _keyController.clear();
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
              
              var computed = ComputeCipher.decrypt(
                cipher: _selectedCipher,
                input: _stringController.text,
                key: _keyController.text,
              );
              
              setState(() {
                if(computed != null) {
                  _result = computed;
                  _state = States.finished;
                } else {
                  _state = States.normal;
                }
              });

            }, 
            child: Text('Decrypt'), 
            color: Theme.of(context).buttonColor
          ),
          Container(
            padding: const EdgeInsets.only(top: 16),
            alignment: Alignment.center,
            child: 
              _state == States.finished
              ? GestureDetector(
                onLongPress: () { Clipboard.setData(ClipboardData(text: _result.output)); },
                child: Text('Decrypted Message: ${_result.output}', style: Theme.of(context).textTheme.bodyText1)
              )
              : Text(_state == States.processing ? placeholders.ProcessingMessage : placeholders.NormalMessage, textAlign: TextAlign.center),
          ),
        ]
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}