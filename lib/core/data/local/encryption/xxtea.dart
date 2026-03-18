import 'dart:convert';

import 'package:sembast/sembast.dart';
import 'package:xxtea/xxtea.dart';

SembastCodec getXXTeaCodec({required String password}) => SembastCodec(
      codec: XXTeaCodec(password: password),
      signature: 'xxtea',
    );

class XXTeaCodec extends Codec<Object?, String> {
  final String password;
  late XXTeaEncoder _encoder;
  late XXTeaDecoder _decoder;

  XXTeaCodec({required this.password}) {
    _encoder = XXTeaEncoder(password);
    _decoder = XXTeaDecoder(password);
  }

  @override
  Converter<String, Object?> get decoder => _decoder;

  @override
  Converter<Object?, String> get encoder => _encoder;
}

class XXTeaEncoder extends Converter<Object?, String> {
  final String password;

  XXTeaEncoder(this.password);

  @override
  String convert(Object? input) {
    final encoded = jsonEncode(input);
    final encrypted = xxtea.encryptToString(encoded, password);
    return encrypted!;
  }
}

class XXTeaDecoder extends Converter<String, Object?> {
  final String password;

  XXTeaDecoder(this.password);

  @override
  Object? convert(String input) {
    final decrypted = xxtea.decryptToString(input, password);
    return jsonDecode(decrypted!);
  }
}
