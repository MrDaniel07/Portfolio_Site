import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://urppgvmqayoektgbeapj.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVycHBndm1xYXlvZWt0Z2JlYXBqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjcxOTQ4NzcsImV4cCI6MjA4Mjc3MDg3N30.h76w6f9PX_zBYSSsaF7v3-98uOkZuc1JDagSmg11NJo';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
