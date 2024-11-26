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

    if (!body.containsKey('otp') || !body.containsKey('reference')) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {
          'status': 'error',
          'message': 'otp and reference are required',
        },
      );
    }

    final result = await paystack.submitOTP(
      reference: body['reference'] as String,
      otp: body['otp'] as String,
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
