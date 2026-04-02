import 'package:go_router/go_router.dart';
import 'package:campus_clash/features/matches/view/match_list_screen.dart';
import 'package:campus_clash/features/admin/view/admin_dashboard_screen.dart';
import 'package:campus_clash/features/admin/view/add_match_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MatchListScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardScreen(),
        routes: [
          GoRoute(
            path: 'add-match',
            builder: (context, state) => const AddMatchScreen(),
          ),
        ],
      ),
    ],
  );
}
