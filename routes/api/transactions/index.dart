import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:mind_paystack_backend/services/paystack_service.dart';

Future<Response> onRequest(RequestContext context) async {
  final paystack = context.read<PaystackTransaction>();

  switch (context.request.method) {
    case HttpMethod.post:
      return _handleInitializeTransaction(context, paystack);
    case HttpMethod.get:
      return _handleListTransactions(context, paystack);
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _handleInitializeTransaction(
  RequestContext context,
  PaystackTransaction paystack,
) async {
  try {
    final body = await context.request.json() as Map<String, dynamic>;

    // Validate required fields
    if (!body.containsKey('email') || !body.containsKey('amount')) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {
          'status': 'error',
          'message': 'email and amount are required fields',
        },
      );
    }

    final result = await paystack.initializeTransaction(
      email: body['email'] as String,
      amount: body['amount'] as int,
      reference: body['reference'] as String?,
      currency: body['currency'] as String?,
      metadata: body['metadata'] as Map<String, dynamic>?,
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

Future<Response> _handleListTransactions(
  RequestContext context,
  PaystackTransaction paystack,
) async {
  try {
    final params = context.request.uri.queryParameters;

    final result = await paystack.listTransactions(
      perPage: int.tryParse(params['perPage'] ?? ''),
      page: int.tryParse(params['page'] ?? ''),
      from: DateTime.tryParse(params['from'] ?? ''),
      to: DateTime.tryParse(params['to'] ?? ''),
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
