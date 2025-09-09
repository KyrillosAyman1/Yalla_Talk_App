import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SupabaseHelper {
  static const String projectUrl = "https://ruuqdrmyofgfpyjvwsht.supabase.co";
  static const String apiKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ1dXFkcm15b2ZnZnB5anZ3c2h0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY2Nzk2NzksImV4cCI6MjA3MjI1NTY3OX0.fxBJwDzS1fo0TFeDEdykiZ3faTUFKiRquye_6AE0MxI";

static  Future  init() async {
    await Supabase.initialize(
    url: projectUrl,
    anonKey: apiKey
  );
  }
}
