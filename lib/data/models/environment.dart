import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get fileName {
    if (kReleaseMode) {
      return '.env.production';
    }
    return '.env.development';
  }

  static String get supabaseProjectUrl {
    return dotenv.env['SUPABASE_PROJECT_URL'] ??
        'SUPABASE_PROJECT_URL not specified';
  }

  static String get supabaseApiKey {
    return dotenv.env['SUPABASE_API_KEY'] ?? 'SUPABASE_API_KEY not specified';
  }
}
