import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:mind_paystack_backend/services/card_validator.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  try {
    final body = await context.request.json() as Map<String, dynamic>;

    if (!body.containsKey('card_number')) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {
          'status': 'error',
          'message': 'card_number is required',
        },
      );
    }

    // Basic card validation
    final cardNumber = (body['card_number'] as String).replaceAll(' ', '');

    // Luhn algorithm check
    if (!CardValidator.isValidLuhn(cardNumber)) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {
          'status': 'error',
          'message': 'Invalid card number',
        },
      );
    }

    // Get card type and additional info
    final cardInfo = CardValidator.getCardInfo(cardNumber);

    return Response.json(
      body: {
        'status': 'success',
        'data': {
          'valid': true,
          'card_type': cardInfo['type'],
          'card_brand': cardInfo['brand'],
        },
      },
    );
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
