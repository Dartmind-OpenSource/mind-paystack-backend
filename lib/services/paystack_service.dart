import 'dart:convert';
import 'package:http/http.dart' as http;

///
class PaystackTransaction {
  ///
  PaystackTransaction({
    required this.secretKey,
  });

  ///
  final String secretKey;

  ///
  final String baseUrl = 'https://api.paystack.co';

  ///
  Map<String, String> get headers => {
        'Authorization': 'Bearer $secretKey',
        'Content-Type': 'application/json',
      };

  /// Initialize a transaction
  Future<Map<String, dynamic>> initializeTransaction({
    required String email,
    required int amount, // amount in kobo (Nigerian currency)
    String? reference,
    String? currency,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/transaction/initialize'),
        headers: headers,
        body: jsonEncode({
          'email': email,
          'amount': amount,
          if (reference != null) 'reference': reference,
          if (currency != null) 'currency': currency,
          if (metadata != null) 'metadata': metadata,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw PaystackException(
          'Failed to initialize transaction: ${response.statusCode}',
          response.body,
        );
      }
    } catch (e) {
      throw PaystackException('Error initializing transaction', e.toString());
    }
  }

  /// Verify a transaction
  Future<Map<String, dynamic>> verifyTransaction(String reference) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/transaction/verify/$reference'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw const PaystackException(
            'Failed to verify transaction',
            'Empty response',
          );
        }
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw PaystackException(
          'Failed to verify transaction: ${response.statusCode}',
          response.body,
        );
      }
    } catch (e) {
      throw PaystackException('Error verifying transaction', e.toString());
    }
  }

  /// List transactions
  Future<Map<String, dynamic>> listTransactions({
    int? perPage,
    int? page,
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      final queryParameters = <String, String>{
        if (perPage != null) 'perPage': perPage.toString(),
        if (page != null) 'page': page.toString(),
        if (from != null) 'from': from.toIso8601String(),
        if (to != null) 'to': to.toIso8601String(),
      };

      final uri = Uri.parse('$baseUrl/transaction').replace(
        queryParameters: queryParameters,
      );

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw const PaystackException(
            'Failed to list transactions',
            'Empty response',
          );
        }
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw PaystackException(
          'Failed to list transactions: ${response.statusCode}',
          response.body,
        );
      }
    } catch (e) {
      throw PaystackException('Error listing transactions', e.toString());
    }
  }

  // Fetch a transaction
  Future<Map<String, dynamic>> fetchTransaction(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/transaction/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw const PaystackException(
            'Failed to fetch transaction',
            'Empty response',
          );
        }
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw PaystackException(
          'Failed to fetch transaction: ${response.statusCode}',
          response.body,
        );
      }
    } catch (e) {
      throw PaystackException('Error fetching transaction', e.toString());
    }
  }

  /// Charge authorization
  Future<Map<String, dynamic>> chargeAuthorization({
    required String email,
    required int amount,
    required String authorizationCode,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/transaction/charge_authorization'),
        headers: headers,
        body: jsonEncode({
          'email': email,
          'amount': amount,
          'authorization_code': authorizationCode,
        }),
      );

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw const PaystackException(
            'Failed to list transactions',
            'Empty response',
          );
        }
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw PaystackException(
          'Failed to charge authorization: ${response.statusCode}',
          response.body,
        );
      }
    } catch (e) {
      throw PaystackException('Error charging authorization', e.toString());
    }
  }

  Future<Map<String, dynamic>> createPlan({
    required String name,
    required int amount,
    required String interval, // 'daily', 'weekly', 'monthly', 'annually'
    String? description,
    int? invoiceLimit,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/plan'),
        headers: headers,
        body: jsonEncode({
          'name': name,
          'amount': amount,
          'interval': interval,
          if (description != null) 'description': description,
          if (invoiceLimit != null) 'invoice_limit': invoiceLimit,
        }),
      );

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw const PaystackException(
            'Failed to create plan',
            'Empty response',
          );
        }
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw PaystackException(
          'Failed to create plan: ${response.statusCode}',
          response.body,
        );
      }
    } catch (e) {
      throw PaystackException('Error creating plan', e.toString());
    }
  }

  // Create a subscription
  Future<Map<String, dynamic>> createSubscription({
    required String customer,
    required String plan,
    String? startDate,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/subscription'),
        headers: headers,
        body: jsonEncode({
          'customer': customer,
          'plan': plan,
          if (startDate != null) 'start_date': startDate,
        }),
      );

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw const PaystackException(
            'Failed to create subscription',
            'Empty response',
          );
        }
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw PaystackException(
          'Failed to create subscription: ${response.statusCode}',
          response.body,
        );
      }
    } catch (e) {
      throw PaystackException('Error creating subscription', e.toString());
    }
  }

  // Create a customer
  Future<Map<String, dynamic>> createCustomer({
    required String email,
    String? firstName,
    String? lastName,
    String? phone,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/customer'),
        headers: headers,
        body: jsonEncode({
          'email': email,
          if (firstName != null) 'first_name': firstName,
          if (lastName != null) 'last_name': lastName,
          if (phone != null) 'phone': phone,
          if (metadata != null) 'metadata': metadata,
        }),
      );

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw const PaystackException(
            'Failed to create customer',
            'Empty response',
          );
        }
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw PaystackException(
          'Failed to create customer: ${response.statusCode}',
          response.body,
        );
      }
    } catch (e) {
      throw PaystackException('Error creating customer', e.toString());
    }
  }

  // Get banks list
  Future<List<Map<String, dynamic>>> getBanks() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bank'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['data'] as List);
      } else {
        throw PaystackException(
          'Failed to get banks: ${response.statusCode}',
          response.body,
        );
      }
    } catch (e) {
      throw PaystackException('Error getting banks', e.toString());
    }
  }

  // Verify BVN
  Future<Map<String, dynamic>> verifyBVN({
    required String bvn,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/bvn/verify/$bvn'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw const PaystackException(
            'Failed to verify BVN',
            'Empty response',
          );
        }
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw PaystackException(
          'Failed to verify BVN: ${response.statusCode}',
          response.body,
        );
      }
    } catch (e) {
      throw PaystackException('Error verifying BVN', e.toString());
    }
  }

  // Export transactions
  Future<Map<String, dynamic>> exportTransactions({
    String? from,
    String? to,
    String? settled,
    String? payment_page,
  }) async {
    try {
      final queryParams = <String, String>{
        if (from != null) 'from': from,
        if (to != null) 'to': to,
        if (settled != null) 'settled': settled,
        if (payment_page != null) 'payment_page': payment_page,
      };

      final uri = Uri.parse('$baseUrl/transaction/export')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: headers,
      );

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw const PaystackException(
            'Failed to export transactions',
            'Empty response',
          );
        }
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw PaystackException(
          'Failed to export transactions: ${response.statusCode}',
          response.body,
        );
      }
    } catch (e) {
      throw PaystackException('Error exporting transactions', e.toString());
    }
  }

  Future<Map<String, dynamic>> chargeCard({
    required Map<String, dynamic> card,
    required String email,
    required int amount,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/charge'),
        headers: headers,
        body: jsonEncode({
          'email': email,
          'amount': amount,
          'card': card,
          if (metadata != null) 'metadata': metadata,
        }),
      );

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw const PaystackException(
            'Failed to charge card',
            'Empty response',
          );
        }
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw PaystackException(
          'Failed to charge card: ${response.statusCode}',
          response.body,
        );
      }
    } catch (e) {
      throw PaystackException('Error charging card', e.toString());
    }
  }

  Future<Map<String, dynamic>> submitPin({
    required String reference,
    required String pin,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/submit-pin'),
        headers: headers,
        body: jsonEncode({
          'reference': reference,
          'pin': pin,
        }),
      );

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw const PaystackException(
            'Failed to submit PIN',
            'Empty response',
          );
        }
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw PaystackException(
          'Failed to submit PIN: ${response.statusCode}',
          response.body,
        );
      }
    } catch (e) {
      throw PaystackException('Error submitting PIN', e.toString());
    }
  }

  Future<Map<String, dynamic>> submitOTP({
    required String reference,
    required String otp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/submit-otp'),
        headers: headers,
        body: jsonEncode({
          'reference': reference,
          'otp': otp,
        }),
      );

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          throw const PaystackException(
            'Failed to submit OTP',
            'Empty response',
          );
        }
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw PaystackException(
          'Failed to submit OTP: ${response.statusCode}',
          response.body,
        );
      }
    } catch (e) {
      throw PaystackException('Error submitting OTP', e.toString());
    }
  }
}

///
class PaystackException implements Exception {
  ///
  const PaystackException(
    this.message,
    this.details,
  );
  final String message;
  final String details;

  @override
  String toString() => 'PaystackException: $message\nDetails: $details';
}
