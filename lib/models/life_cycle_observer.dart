// import 'package:flutter/material.dart';
// import 'app_lifecycle_manager.dart';
// import 'package:flutter/services.dart';


// import 'package:flutter/material.dart';
// import 'app_lifecycle_manager.dart'; // Import the AppLifecycleManager class

// class AppLifecycleObserver extends StatefulWidget {
//   final Widget child;

//   AppLifecycleObserver({required this.child});

//   @override
//   _AppLifecycleObserverState createState() => _AppLifecycleObserverState();
// }

// class _AppLifecycleObserverState extends State<AppLifecycleObserver> with WidgetsBindingObserver {
//   final AppLifecycleManager _appLifecycleManager = AppLifecycleManager();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance?.addObserver(this);
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance?.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);

//     if (state == AppLifecycleState.paused) {
//       _appLifecycleManager.isExiting = false;
//     } else if (state == AppLifecycleState.detached) {
//       _appLifecycleManager.isExiting = true;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return widget.child;
//   }
// }
