import 'dart:convert';
import 'dart:io';
import 'package:Ahteeg/models/enums.dart';
import 'package:Ahteeg/models/timed_output.dart';
import 'package:crypto/crypto.dart';

class ComputeHash {

  static List<TimedOutput> hashString(String input) {

    Stopwatch watch = Stopwatch();
    var encoded = utf8.encode(input);
    List<TimedOutput> computed = [];

    for(var hash in Hashes.values) {

      watch.reset();
      watch.start();

      Digest digest;
      int blockSize;
      int timeTaken;

      switch(hash){
        case Hashes.md5:
          digest = md5.convert(encoded);
          blockSize = md5.blockSize;
          break;
        case Hashes.sha1:
          digest = sha1.convert(encoded);
          blockSize = sha1.blockSize;
          break;
        case Hashes.sha224:
          digest = sha224.convert(encoded);
          blockSize = sha224.blockSize;
          break;
        case Hashes.sha256:
          digest = sha256.convert(encoded);
          blockSize = sha256.blockSize;
          break;
        case Hashes.sha384:
          digest = sha384.convert(encoded);
          blockSize = sha384.blockSize;
          break;
        case Hashes.sha512:
          digest = sha512.convert(encoded);
          blockSize = sha512.blockSize;
          break;
      }

      watch.stop();
      timeTaken = watch.elapsedMicroseconds;

      computed.add(TimedOutput(title: hash.toString().split('.').last, duration: watch.elapsedMicroseconds, output: digest.toString(), score: (digest.bytes.length)*0.5 + (blockSize*0.5) - (timeTaken/1000)*0.1));
    }

    return computed;
  }

  static Future<List<TimedOutput>> hashFile(File file) async {
    
    Stopwatch watch = Stopwatch();    
    List<TimedOutput> computed = [];

    for(var hash in Hashes.values) {

      watch.reset();
      watch.start();

      Digest digest;
      int blockSize;
      int timeTaken;

      switch(hash){
        case Hashes.md5:
          digest = await md5.bind(file.openRead()).first;
          blockSize = md5.blockSize;
          break;
        case Hashes.sha1:
          digest = await sha1.bind(file.openRead()).first;
          blockSize = sha1.blockSize;
          break;
        case Hashes.sha224:
          digest = await sha224.bind(file.openRead()).first;
          blockSize = sha224.blockSize;
          break;
        case Hashes.sha256:
          digest = await sha256.bind(file.openRead()).first;
          blockSize = sha256.blockSize;
          break;
        case Hashes.sha384:
          digest = await sha384.bind(file.openRead()).first;
          blockSize = sha384.blockSize;
          break;
        case Hashes.sha512:
          digest = await sha512.bind(file.openRead()).first;
          blockSize = sha512.blockSize;
          break;
      }

      watch.stop();
      timeTaken = watch.elapsedMicroseconds;

      computed.add(TimedOutput(title: hash.toString().split('.').last, duration: timeTaken, output: digest.toString(), score: (digest.bytes.length)*0.5 + (blockSize*0.5) - (timeTaken/10000)));
    }

    return computed;    
  }

}