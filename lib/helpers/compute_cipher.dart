import 'package:Ahteeg/constants/placeholders.dart';
import 'package:Ahteeg/models/enums.dart';
import 'package:Ahteeg/models/timed_output.dart';
import 'package:Ahteeg/models/xy_coordinate.dart';
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
      int keySize;
      int timeTaken;

      switch(cipher) {
        case Ciphers.playfair:
          encrypted = _playfair(input, key, encrypt: true);
          keySize = 25;
          break;
        case Ciphers.vignere:
          encrypted = _vignere(input, key, encrypt: true);
          keySize = input.length > key.length ? key.length : input.length;
          break;
        case Ciphers.caesar:
          encrypted = _caesar(input, shift, encrypt: true);
          keySize = 1;
          break;
        case Ciphers.railfence:
          encrypted = _railfence(input, shift, encrypt: true);
          keySize = int.tryParse(shift) ?? 1;
          break;
      }

      watch.stop();
      timeTaken = watch.elapsedMicroseconds;
      bool isError = ErrorMessages.contains(encrypted);

      computed.add(TimedOutput(title: cipher.toString().split('.').last, duration: isError? null : watch.elapsedMicroseconds, output: encrypted, score: isError ? null : (keySize - (timeTaken/1000))));
    }

    return computed;
  }

  static String decrypt({@required String input, String key, @required Ciphers cipher}) {

    if(input.isEmpty || key.isEmpty)
      return null;
    
    String decrypted;
    switch(cipher) {
      case Ciphers.playfair:
        decrypted = _playfair(input, key);
        break;
      case Ciphers.caesar:
        decrypted = _caesar(input, key);
        break;
      case Ciphers.vignere:
        decrypted = _vignere(input, key);
        break;
      case Ciphers.railfence:
        decrypted = _railfence(input, key);
        break;
    }

    return decrypted;
  }

  static int _offsetFor(int ch) {
    return (ch >= 'a'.codeUnitAt(0) && ch <= 'z'.codeUnitAt(0)) ? 97 : 65;
  }
          
  static String _caesar(String input, String shift, {bool encrypt = false}) {
    
    String output = '';
    if(nonAlphaRegExp.allMatches(input).length != 0)
      return 'Invalid characters in plaintext!';

    int shiftBy = int.tryParse(shift);
    if(shiftBy == null)
      return 'Invalid shift. Must be integer.';
    
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

  static String _vignere(String input, String key, {bool encrypt = false}) {
    String output = '';

    input = input.toUpperCase();
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

        output += String.fromCharCode(
            encrypt
            ? (input.codeUnitAt(i) + key.codeUnitAt(j)) % 26 + 65
            : (input.codeUnitAt(i) - key.codeUnitAt(j) + 26) % 26 + 65
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

  static List<dynamic> _fence(dynamic input, int numRails) {

    List<List<dynamic>> fence = List<List<dynamic>>.generate(numRails, (i) => List<dynamic>.generate(input.length, (j) => null));
    List<int> rails = List.generate(numRails - 1, (i) => i);
    rails.addAll(List<int>.generate(numRails - 1, (i) => (numRails - i - 1)));

    for(int i = 0; i < input.length; i++) {
      fence[rails[i % rails.length]][i] = input[i];
    }

    List<dynamic> output = [];
    for(var rail in fence) {
      for(var c in rail) {
        if(c != null)
          output.add(c);
      }
    }
    return output;
  }

  static String _railfence(String input, String rails, {bool encrypt = false}) {
    
    if(nonAlphaRegExp.allMatches(input).length != 0)
      return 'Invalid characters in plaintext!';

    int key = int.tryParse(rails);
    if(key == null)
      return 'Invalid number of rails. Must be integer.';
    
    var fence = _fence(input, key);
    if(encrypt)
      return fence.join('');
    else {
      List<int> range = List.generate(input.length, (i) => (i));
      var pos = _fence(range, key);
      List<String> deciphered = [];
      
      for(int i in range) {
        deciphered.add(input[pos.indexWhere((element) => element == i)]);
      }
      return deciphered.join('');
    }
  }

  static XYCoordinate _getRowCol(String element, List<String> matrix) {
    int index = matrix.indexOf(element);
    return XYCoordinate((index/5).floor(), index%5);
  }

  static String _findPair(String oldPair, List<String> matrix, bool encrypt) {
    String newPair;
    int direction = encrypt ? 1 : -1;
    
    XYCoordinate one = _getRowCol(oldPair[0], matrix);
    XYCoordinate two = _getRowCol(oldPair[1], matrix);

    // Probably written when high. If it works it works.
    if(one.x == two.x) {
      // same row
      newPair = matrix[(5+(one.y+direction))%5 + (one.x*5)] + matrix[(5+(two.y+direction))%5 + (two.x*5)];
    }
    else if(one.y == two.y) {
      // same column
      newPair = matrix[((one.x*5)+one.y+(5*direction))%25] + matrix[((two.x*5)+two.y+(5*direction))%25];
    }
    else {
      // rectangle, otherwise
      newPair = matrix[(one.x*5)+one.y + (two.y-one.y)] + matrix[(two.x*5)+two.y + (one.y-two.y)];
    }

    return newPair;
  }
  
  static String _playfair(String input, String key, {bool encrypt = false}) {

    if(nonAlphaRegExp.allMatches(input).length != 0)
      return 'Invalid characters in plaintext!';

    input = input.toUpperCase().replaceAll('J', 'I').replaceAll(' ', '');

    if(nonAlphaRegExp.allMatches(key).length != 0)
      return 'Invalid characters in key!';

    key = key.toUpperCase().replaceAll('J', 'I').replaceAll(' ', '');

    if(input.isEmpty || key.isEmpty)
      return 'Invalid input/key. Cannot be blank.';

    List<String> matrix = List<String>.from(key.split('')).toSet().toList();

    for(int i=0; i<26; i++) {
      if(i != 9  && !matrix.contains(String.fromCharCode(i + 65))) {
        // do not put a J (== I)
        matrix.add(String.fromCharCode(i + 65));
      }
    }
    // print(matrix);

    String target = '';
    for(int i = 0; i < input.length; i = i + 2) {
      if(i + 2 > input.length){
        input += (input[i] == 'Z') ? 'X' : 'Z'; // Stick a Z at the end (X if Z already present)
      }
      if(input[i] == input[i+1]) { // If this digraph's letters match, insert an X
        input = input.substring(0, i+1) + 'X' + input.substring(i+1);
      }
      
      target += _findPair(input[i] + input[i+1], matrix, encrypt);
    }
    return target;
  }

}