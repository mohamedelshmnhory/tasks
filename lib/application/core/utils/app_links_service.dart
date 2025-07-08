// import 'package:app_links/app_links.dart';
// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
//
// import 'auto_router_setup/app_router.dart';
//
// class AppLinksService {
//   final AppLinks _appLinks = AppLinks();
//   Stream<Uri>? _linkStream;
//
//   void init(BuildContext context) {
//     // Listen for incoming links while the app is running
//     _linkStream = _appLinks.uriLinkStream;
//     _linkStream?.listen((uri) {
//       _handleUri(context, uri);
//     });
//
//     // Handle the app being opened with a link
//     _appLinks.getInitialLink().then((uri) {
//       if (uri != null) {
//         _handleUri(context, uri);
//       }
//     });
//   }
//
//   void _handleUri(BuildContext context, Uri uri) {
//     // Example: Navigate based on the path
//     if (uri.pathSegments.isNotEmpty) {
//       if (uri.pathSegments.first == 'project' && uri.pathSegments.length > 1) {
//         final projectId = uri.pathSegments[1];
//         debugPrint('Navigating to project details: $projectId');
//         // TODO: Use your router to navigate to project details
//         context.router.push(ProjectDetailsRoute(projectId: int.parse(projectId)));
//       }
//       // Add more cases as needed
//     }
//   }
// }
