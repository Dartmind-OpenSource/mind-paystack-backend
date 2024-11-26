import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:mind_paystack_backend/services/paystack_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    final body = await context.request.json() as Map<String, dynamic>;

    // Validate required fields
    if (!body.containsKey('email') ||
        !body.containsKey('amount') ||
        !body.containsKey('authorization_code')) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {
          'status': 'error',
          'message':
              'email, amount, and authorization_code are required fields',
        },
      );
    }

    final paystack = context.read<PaystackTransaction>();
    final result = await paystack.chargeAuthorization(
      email: body['email'] as String,
      amount: body['amount'] as int,
      authorizationCode: body['authorization_code'] as String,
    );

    return Response.json(body: result);
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {
        'status': 'error',
        'message': e.toString(),
      },
    );
  }
}
