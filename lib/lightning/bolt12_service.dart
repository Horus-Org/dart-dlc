import 'dart:convert';
import 'package:http/http.dart' as http;

class Bolt12Service {
  final String baseUrl;

  Bolt12Service(this.baseUrl);

  Future<String> generateInvoice({
    required int satoshis,
    required String description,
    required int expiry,
    required String payeeNodeKey,
    required String payeeNodeAddress,
    required String payeeNodeAlias,
    required String payeeNodePubkey,
    required String onionMessage,
    required String payeeBase64,
    required String jsonEncode,
    required String jsonDecode,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/generate_invoice'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'satoshis': satoshis,
        'description': description,
        'expiry': expiry,
        'payeeNodeKey': payeeNodeKey,
        'onionMessage': onionMessage,
        'payeeBase64': payeeBase64,
        'payeeNodeAddress': payeeNodeAddress,
        'payeeNodeAlias': payeeNodeAlias,
        'payeeNodePubkey': payeeNodePubkey,
        'jsonEncode': jsonEncode,
        'jsonDecode': jsonDecode,
        'bolt12': '
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['invoice'];
    } else {
      throw Exception('Failed to generate invoice');
    }
  }

  Future<Map<String, dynamic>> decodeInvoice(String bolt12Invoice) async {
    final response = await http.post(
      Uri.parse('$baseUrl/decode_invoice'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'invoice': bolt12Invoice}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to decode invoice');
    }
  }
}