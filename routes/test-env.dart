// routes/api/test-env.dart
import 'package:dart_frog/dart_frog.dart';
import 'package:mind_paystack_backend/env.dart';

Response onRequest(RequestContext context) {
  return Response.json(
    body: {
      'hasKey': Env.paystackSecretKey.isNotEmpty,
      'keyLength': Env.paystackSecretKey.length,
    },
  );
}
