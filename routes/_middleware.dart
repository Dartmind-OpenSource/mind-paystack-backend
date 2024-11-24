import 'package:dart_frog/dart_frog.dart';
import 'package:mind_paystack_backend/env.dart';
import 'package:mind_paystack_backend/services/paystack_service.dart';

Handler middleware(Handler handler) {
  return handler.use(
    provider<PaystackTransaction>(
      (context) => PaystackTransaction(
        secretKey: Env.paystackSecretKey,
      ),
    ),
  );
}
