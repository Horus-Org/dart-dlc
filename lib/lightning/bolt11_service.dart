import 'dart:convert';
import 'package:http/http.dart' as http;

class Bolt11Service {
  final String baseUrl;

  Bolt11Service(this.baseUrl);

  Future<String> generateInvoice({
    required int satoshis,
    required String description,
    required int expiry,
    required String payeeNodeKey,
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
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['invoice'];
    } else {
      throw Exception('Failed to generate invoice');
    }
  }

  Future<Map<String, dynamic>> decodeInvoice(String bolt11Invoice) async {
    final response = await http.post(
      Uri.parse('$baseUrl/decode_invoice'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'invoice': bolt11Invoice}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to decode invoice');
    }
  }
}
