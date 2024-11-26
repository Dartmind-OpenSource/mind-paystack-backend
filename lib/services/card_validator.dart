class CardValidator {
  static bool isValidLuhn(String number) {
    if (number.isEmpty) return false;

    // Remove all non-digits
    number = number.replaceAll(RegExp(r'\D'), '');

    if (number.length < 13 || number.length > 19) return false;

    int sum = 0;
    bool alternate = false;

    // Loop from right to left
    for (int i = number.length - 1; i >= 0; i--) {
      int digit = int.parse(number[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

  static Map<String, dynamic> getCardInfo(String number) {
    // Remove spaces and dashes
    number = number.replaceAll(RegExp(r'[\s-]'), '');

    // Define card patterns
    final cardPatterns = {
      'visa': RegExp(r'^4[0-9]{12}(?:[0-9]{3})?$'),
      'mastercard': RegExp(r'^5[1-5][0-9]{14}$'),
      'amex': RegExp(r'^3[47][0-9]{13}$'),
      'discover': RegExp(r'^6(?:011|5[0-9]{2})[0-9]{12}$'),
      'diners_club': RegExp(r'^3(?:0[0-5]|[68][0-9])[0-9]{11}$'),
      'jcb': RegExp(r'^(?:2131|1800|35\d{3})\d{11}$'),
      'verve': RegExp(r'^(506[0-1]|507[8-9]|6500)\d{12,15}$'),
    };

    // Check each pattern
    for (var entry in cardPatterns.entries) {
      if (entry.value.hasMatch(number)) {
        return {
          'type': entry.key,
          'brand': _formatBrandName(entry.key),
          'length': number.length,
          'cvvLength': _getCVVLength(entry.key),
          'mask': _getCardMask(entry.key),
          'blocks': _getCardBlocks(entry.key),
        };
      }
    }

    // Default for unknown cards
    return {
      'type': 'unknown',
      'brand': 'Unknown',
      'length': number.length,
      'cvvLength': 3,
      'mask': _getCardMask('unknown'),
      'blocks': [4, 4, 4, 4],
    };
  }

  static String _formatBrandName(String brand) {
    switch (brand) {
      case 'visa':
        return 'Visa';
      case 'mastercard':
        return 'Mastercard';
      case 'amex':
        return 'American Express';
      case 'discover':
        return 'Discover';
      case 'diners_club':
        return 'Diners Club';
      case 'jcb':
        return 'JCB';
      case 'verve':
        return 'Verve';
      default:
        return 'Unknown';
    }
  }

  static int _getCVVLength(String cardType) {
    switch (cardType) {
      case 'amex':
        return 4;
      default:
        return 3;
    }
  }

  static String _getCardMask(String cardType) {
    switch (cardType) {
      case 'amex':
        return '0000 000000 00000';
      case 'diners_club':
        return '0000 000000 0000';
      default:
        return '0000 0000 0000 0000';
    }
  }

  static List<int> _getCardBlocks(String cardType) {
    switch (cardType) {
      case 'amex':
        return [4, 6, 5];
      case 'diners_club':
        return [4, 6, 4];
      default:
        return [4, 4, 4, 4];
    }
  }

  static bool isValidExpiryDate(String month, String year) {
    try {
      final currentDate = DateTime.now();
      final cardYear = int.parse(year.length == 2 ? '20$year' : year);
      final cardMonth = int.parse(month);

      if (cardMonth < 1 || cardMonth > 12) return false;

      final cardDate = DateTime(cardYear, cardMonth + 1, 0);
      return cardDate.isAfter(currentDate);
    } catch (e) {
      return false;
    }
  }

  static bool isValidCVV(String cvv, String cardType) {
    final expectedLength = _getCVVLength(cardType);
    return cvv.length == expectedLength && RegExp(r'^\d{3,4}$').hasMatch(cvv);
  }

  static String formatCardNumber(String number, String cardType) {
    number = number.replaceAll(RegExp(r'\D'), '');
    final blocks = _getCardBlocks(cardType);
    final parts = <String>[];
    var currentPosition = 0;

    for (final block in blocks) {
      if (currentPosition + block <= number.length) {
        parts.add(number.substring(currentPosition, currentPosition + block));
        currentPosition += block;
      } else if (currentPosition < number.length) {
        parts.add(number.substring(currentPosition));
        break;
      }
    }

    return parts.join(' ');
  }
}
