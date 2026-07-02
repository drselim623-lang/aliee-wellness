import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/role_selection_screen.dart';
import '../../features/auth/doctor_login_screen.dart';
import '../../features/auth/admin_login_screen.dart';
import '../../features/guest/guest_home_screen.dart';
import '../../features/guest/services/services_screen.dart';
import '../../features/guest/services/service_detail_screen.dart';
import '../../features/guest/anamnesis/anamnesis_screen.dart';
import '../../features/guest/program/program_screen.dart';
import '../../features/guest/ask_doctor/conversations_list_screen.dart';
import '../../features/doctor/doctor_home_screen.dart';
import '../../features/admin/admin_home_screen.dart';
import '../../features/shared/chat/chat_screen.dart';

class AppRoutes {
  static const root = '/';
  static const doctorLogin = '/doctor-login';
  static const adminLogin = '/admin-login';
  static const guestHome = '/guest';
  static const guestServices = '/guest/services';
  static const guestServiceDetail = '/guest/services/detail/:serviceId';
  static const guestAnamnesis = '/guest/anamnesis';
  static const guestProgram = '/guest/program';
  static const guestAskDoctor = '/guest/ask-doctor';
  static const guestChat = '/guest/ask-doctor/chat/:questionId';
  static const doctorHome = '/doctor';
  static const doctorChat = '/doctor/chat/:questionId';
  static const adminHome = '/admin';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.root,
  routes: [
    GoRoute(
      path: AppRoutes.root,
      builder: (_, __) => const RoleSelectionScreen(),
    ),
    GoRoute(
      path: AppRoutes.doctorLogin,
      builder: (_, __) => const DoctorLoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.adminLogin,
      builder: (_, __) => const AdminLoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.guestHome,
      builder: (_, __) => const GuestHomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.guestServices,
      builder: (_, __) => const ServicesScreen(),
    ),
    GoRoute(
      path: AppRoutes.guestServiceDetail,
      builder: (_, state) => ServiceDetailScreen(
        serviceId: state.pathParameters['serviceId']!,
      ),
    ),
    GoRoute(
      path: AppRoutes.guestAnamnesis,
      builder: (_, __) => const AnamnesisScreen(),
    ),
    GoRoute(
      path: AppRoutes.guestProgram,
      builder: (_, __) => const ProgramScreen(),
    ),
    GoRoute(
      path: AppRoutes.guestAskDoctor,
      builder: (_, __) => const ConversationsListScreen(),
    ),
    GoRoute(
      path: AppRoutes.guestChat,
      builder: (_, state) => ChatScreen(
        questionIdOrNew: state.pathParameters['questionId']!,
      ),
    ),
    GoRoute(
      path: AppRoutes.doctorHome,
      builder: (_, __) => const DoctorHomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.doctorChat,
      builder: (_, state) => ChatScreen(
        questionIdOrNew: state.pathParameters['questionId']!,
      ),
    ),
    GoRoute(
      path: AppRoutes.adminHome,
      builder: (_, __) => const AdminHomeScreen(),
    ),
  ],
  errorBuilder: (_, state) => Scaffold(
    body: Center(child: Text('Route not found: ${state.uri}')),
  ),
);
