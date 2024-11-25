# mind-paystack-backend

A robust Dart Frog backend implementation for Paystack payment integration, providing a comprehensive set of APIs for payment processing, subscriptions and more.

## Table of Contents
- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Local Development Setup](#local-development-setup)
  - [Environment Configuration](#environment-configuration)
  - [Running the Server](#running-the-server)
  - [Common Issues and Solutions](#common-issues-and-solutions)
- [API Documentation](#api-documentation)
- [Engineering Documentation](#engineering-documentation)
- [Contributing](#contributing)
- [Testing](#testing)
- [Deployment](#deployment)
- [Security](#security)
- [License](#license)

## Features

### Core Features
- 💳 Complete payment processing
- 📅 Subscription management
- 👤 Customer management
- 🔄 Transaction handling
- 📊 Payment plans
- 🏦 Bank integration
- 🔒 Secure API endpoints

### Technical Features
- ⚡ Built with Dart Frog
- 🔐 Environment-based configuration
- 🧩 Modular architecture
- 📝 Comprehensive logging
- ✅ Input validation
- 🔄 Error handling
- 📊 Response formatting

## Getting Started

### Prerequisites

- Dart SDK: ">=3.0.0 <4.0.0"
- dart_frog_cli
- Paystack account and API keys
- Git (for version control)

### Installation

1. Install dart_frog_cli globally:
```bash
dart pub global activate dart_frog_cli
```

2. Clone the repository:
```bash
git clone https://github.com/yourusername/mind-paystack-backend.git
cd mind-paystack-backend
```

### Local Development Setup


1. Set up environment files:
```bash
# Create .env and .env.example files
touch .env
touch .env.example

# Create env.dart for environment configuration
touch lib/env.dart
```

2. Add the following content to `lib/env.dart`:
```dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'PAYSTACK_SECRET_KEY')
  static const paystackSecretKey = _Env.paystackSecretKey;
}
```


### Environment Configuration

1. Create `.env` file with your configuration:
```bash
# Paystack Configuration
PAYSTACK_SECRET_KEY=your_secret_key_here

# Server Configuration (optional)
PORT=8080
ENVIRONMENT=development

# Rate Limiting (optional)
RATE_LIMIT_WINDOW=15m
RATE_LIMIT_MAX_REQUESTS=100

# Logging Configuration (optional)
LOG_LEVEL=info
LOG_FORMAT=json

# CORS Configuration (optional)
ALLOWED_ORIGINS=http://localhost:3000,https://yourdomain.com
```

2. Add to `.gitignore`:
```bash
echo ".env" >> .gitignore
echo "*.g.dart" >> .gitignore
```

### Running the Server

1. Install dependencies:
```bash
dart pub get
```

2. Generate environment configuration:
```bash
dart run build_runner build
```

3. Run the development server:
```bash
dart_frog dev
```

4. Verify the installation:
```bash
# Test transaction initialization
curl -X POST http://localhost:8080/api/transactions \
  -H "Content-Type: application/json" \
  -d '{
    "email": "customer@example.com",
    "amount": 5000,
    "currency": "NGN"
  }'
```

### Common Issues and Solutions

1. **Environment Variables Not Loading**
   ```bash
   # Check if .env file exists
   ls -la .env
   
   # Verify .env content
   cat .env
   
   # Regenerate environment files
   dart run build_runner clean
   dart run build_runner build
   ```

2. **Port Already in Use**
   ```bash
   # Kill process using port 8080
   lsof -i :8080
   kill -9 <PID>
   
   # Or run on different port
   PORT=8081 dart_frog dev
   ```

3. **Permission Issues**
   ```bash
   # Fix directory permissions
   chmod -R 755 .
   
   # Fix file permissions
   chmod 644 .env
   ```
   
## API Documentation

### Transactions

#### Initialize Transaction
```http
POST /api/transactions
Content-Type: application/json

{
  "email": "customer@example.com",
  "amount": 5000,
  "currency": "NGN",
  "reference": "unique_reference",
  "metadata": {
    "custom_field": "custom_value"
  }
}
```

#### Verify Transaction
```http
GET /api/transactions/{reference}/verify
```

#### List Transactions
```http
GET /api/transactions?page=1&perPage=20
```

### Subscriptions

#### Create Subscription
```http
POST /api/subscriptions
Content-Type: application/json

{
  "customer": "CUS_xyz",
  "plan": "PLN_xyz",
  "start_date": "2024-12-01"
}
```

#### List Subscriptions
```http
GET /api/subscriptions?customer=CUS_xyz&perPage=20
```

#### Enable/Disable Subscription
```http
POST /api/subscriptions/{code}/enable
POST /api/subscriptions/{code}/disable
Content-Type: application/json

{
  "token": "subscription_token"
}
```


## Engineering Documentation

### Project Structure
```
mind-paystack-backend/
├── lib/
│   ├── paystack_service.dart
│   └── env.dart
├── routes/
│   ├── _middleware.dart
│   └── api/
│       ├── transactions/
│       ├── subscriptions/
│       ├── plans/
│       ├── customers/
│       ├── banks/
├── test/
├── .env
└── pubspec.yaml
```

### Core Components

#### PaystackTransaction Service
The `PaystackTransaction` class handles all Paystack API interactions:
- Transaction management
- Subscription handling
- Customer management
- Payment plans

#### Middleware
- Authentication middleware
- Error handling middleware
- Logging middleware
- CORS middleware

### Error Handling
```dart
class PaystackException implements Exception {
  final String message;
  final String details;

  PaystackException(this.message, this.details);
}
```

### Response Format
```json
{
  "status": "success/error",
  "message": "Operation successful/Error message",
  "data": {}
}
```

## Contributing

### Setup Development Environment
1. Fork the repository
2. Create a feature branch
3. Write tests
4. Implement changes
5. Submit PR

### Code Style
- Follow Dart style guide
- Use meaningful variable names
- Add comments for complex logic
- Format code using `dart format`

### Commit Messages
```
feat: Add new feature
fix: Fix bug
docs: Update documentation
test: Add tests
refactor: Refactor code
```

### Pull Request Process
1. Update documentation
2. Add tests
3. Update CHANGELOG
4. Request review

## Testing

### Running Tests
```bash
# Run all tests
dart test

# Run specific test
dart test test/path/to/test.dart
```

### Test Structure
```dart
void main() {
  group('PaystackTransaction', () {
    test('should initialize transaction', () async {
      // Test code
    });
  });
}
```

## Deployment

### Production Build
```bash
dart_frog build
```

### Docker Deployment
```bash
docker build -t mind-paystack-backend .
docker run -p 8080:8080 mind-paystack-backend
```

### Environment Configuration
- Use production Paystack keys
- Configure proper security headers
- Set up monitoring
- Configure logging

## Security

### Best Practices
- Never commit API keys
- Validate all inputs
- Use HTTPS
- Implement rate limiting
- Log security events
- Regular dependency updates

### API Security
- Authentication required
- Input validation
- Rate limiting
- CORS configuration
- Secure headers

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, email czar@dartmind.io or create an issue in the repository.

---

Made with ❤️ by Your Dartmind
