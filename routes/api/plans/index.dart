import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:mind_paystack_backend/services/paystack_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    final paystack = context.read<PaystackTransaction>();
    final body = await context.request.json() as Map<String, dynamic>;

    if (!body.containsKey('name') ||
        !body.containsKey('amount') ||
        !body.containsKey('interval')) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {
          'status': 'error',
          'message': 'name, amount, and interval are required fields',
        },
      );
    }

    final result = await paystack.createPlan(
      name: body['name'] as String,
      amount: body['amount'] as int,
      interval: body['interval'] as String,
      description: body['description'] as String?,
      invoiceLimit: body['invoice_limit'] as int?,
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
