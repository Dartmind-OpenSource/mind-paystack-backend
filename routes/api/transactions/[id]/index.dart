import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:mind_paystack_backend/services/paystack_service.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    final paystack = context.read<PaystackTransaction>();
    final result = await paystack.fetchTransaction(int.parse(id));
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
