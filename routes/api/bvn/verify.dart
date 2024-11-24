import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:mind_paystack_backend/services/paystack_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    final body = await context.request.json() as Map<String, dynamic>;

    if (!body.containsKey('bvn')) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {
          'status': 'error',
          'message': 'BVN is required',
        },
      );
    }

    final paystack = context.read<PaystackTransaction>();
    final result = await paystack.verifyBVN(
      bvn: body['bvn'] as String,
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
