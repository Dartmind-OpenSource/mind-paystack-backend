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

    // Validate required fields
    final requiredFields = [
      'card_number',
      'expiry_month',
      'expiry_year',
      'cvv',
      'email',
      'amount'
    ];
    for (final field in requiredFields) {
      if (!body.containsKey(field)) {
        return Response.json(
          statusCode: HttpStatus.badRequest,
          body: {
            'status': 'error',
            'message': '$field is required',
          },
        );
      }
    }

    final cardData = {
      'number': body['card_number'],
      'cvv': body['cvv'],
      'expiry_month': body['expiry_month'],
      'expiry_year': body['expiry_year'],
    };

    final result = await paystack.chargeCard(
      card: cardData,
      email: body['email'] as String,
      amount: body['amount'] as int,
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
