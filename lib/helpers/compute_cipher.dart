import 'package:Ahteeg/models/enums.dart';
import 'package:Ahteeg/models/timed_output.dart';
import 'package:flutter/foundation.dart';

class ComputeCipher {

  static final RegExp nonAlphaRegExp = RegExp('[^a-zA-Z ]'); 
  
  static List<TimedOutput> encrypt({@required String input, String key, String shift}) {

    if(input.isEmpty || (key.isEmpty && shift.isEmpty))
      return null;

    Stopwatch watch = Stopwatch();

    List<TimedOutput> computed = [];

    for(var cipher in Ciphers.values) {
      watch.reset();
      watch.start();

      String encrypted;

      switch(cipher) {
        case Ciphers.caesar:
          encrypted = _caesar(input, shift, encrypt: true);
          break;
        case Ciphers.vignere:
          encrypted = _vignere(input, key, encrypt: true);
          break;
        case Ciphers.railfence:
          encrypted = _railfence(input, shift, encrypt: true);
          break;
        case Ciphers.hill:
          encrypted = 'yet to implement.';
          break;
        case Ciphers.playfair:
          encrypted = 'no eta';
          break;
        
      }

      watch.stop();
      computed.add(TimedOutput(title: cipher.toString().split('.').last, duration: watch.elapsedMicroseconds, output: encrypted));
    }

    return computed;
  }

  static int _offsetFor(int ch) {
    return ch >= 'a'.codeUnitAt(0) && ch <= 'z'.codeUnitAt(0) ? 97 : 65;
  }
          
  static String _caesar(String input, String shift, {bool encrypt}) {
    
    String output = '';
    if(nonAlphaRegExp.allMatches(input).length != 0)
      return 'Invalid characters in plaintext!';

    int shiftBy = int.tryParse(shift);
    if(shiftBy == null)
      return 'Invalid key. Must be integer.';
    
    for (int i = 0; i < input.length; i++) {
      if (input[i] != ' ') {
        int offset = _offsetFor(input.codeUnitAt(i));
        
        output += String.fromCharCode(
            encrypt
            ? (input.codeUnitAt(i) + shiftBy - offset) % 26 + offset
            : (input.codeUnitAt(i) - shiftBy - offset) % 26 + offset
          );
      } else {
        output += input[i];
      }
    }

    return output;
  }

  static String _vignere(String input, String key, {bool encrypt}) {
    String output = '';
    if(nonAlphaRegExp.allMatches(input).length != 0)
      return 'Invalid characters in plaintext!';

    key = key.replaceAll(' ', '').toUpperCase();

    if(key.isEmpty)
      return 'Invalid key. Cannot be blank.';
    
    if(nonAlphaRegExp.allMatches(key).length != 0)
      return 'Invalid characters in key!';
    
    int j = 0;
    for (int i = 0; i < input.length; i++) {
      if (input[i] != ' ') {
        int offset = _offsetFor(input.codeUnitAt(i));

        output += String.fromCharCode(
            encrypt
            ? (input.codeUnitAt(i) + key.codeUnitAt(j)) % 26 + offset
            : (input.codeUnitAt(i) - key.codeUnitAt(j) + 26) % 26 + offset
          );
        if (j < key.length - 1) {
          j++;
        } else {
          j = 0;
        }
      } else {
        output += input[i];
      }
    }

    return output;
  }

  static String _railfence(String input, String rails, {bool encrypt}) {
    
    String output = '';
    if(nonAlphaRegExp.allMatches(input).length != 0)
      return 'Invalid characters in plaintext!';

    int key = int.tryParse(rails);
    if(key == null)
      return 'Invalid key. Must be integer.';
    
    List<List<String>> enc = List<List<String>>.generate(key, (i) => List<String>.generate(input.length, (j) => ''));

    int row = 0;
    int flag = 0;
    for(int i = 0; i < input.length; i++) {
      enc[row][i] = input[i];

      if(row == 0)
        flag = 0;
      else if(row == key - 1)
        flag = 1;
      
      if(flag == 0)
        row += 1;
      else
        row -= 1;
    }
    for(var rail in enc) {
      for(var char in rail) {
        if(char != '')
          output += char;
      }
    }
    return output;
  }
}