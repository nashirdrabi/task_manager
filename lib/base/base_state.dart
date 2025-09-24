import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:provider/provider.dart';

import '../commons.dart';
import '../constants/constants.dart';
import '../di/service_locator.dart';
import 'base_navigator.dart';
import 'base_view_model.dart';


abstract class BaseState<W extends StatefulWidget, VM extends BaseViewModel,
    N extends BaseNavigator> extends State<W> implements BaseNavigator {
  final VM viewModel = serviceLocator<VM>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  Widget buildBody();

  N getNavigator();
  PreferredSize? buildAppBar() {
    return null;
  }

  // Widget? buildbottomNavBar() {
  //   return null;
  // }

  PageIdentifier getPageIdentifier();

  Widget? buildendDrawerScreen() {
    return null;
  }

  Color? setBackgroundColor() {
    return Colors.white;
  }

  // @override
  // void navigateToOnboarding() {
  //   navigateWithSlideTransitionAndRemoveUntil(
  //     context,
  //     OnboardingPageView(),
  //     (route) => false,
  //   );
  // }

  void loadPageData({dynamic value});
  StreamSubscription? subscription;


  Future<bool> provideOnWillPopScopeCallBack() async {
    return Future.value(true);
  }

  @override
  void initState() {
    viewModel.setNavigator(getNavigator());
    loadPageData();
    super.initState();

  }

  @override
  void didChangeDependencies() async {
    context.dependOnInheritedWidgetOfExactType();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
            // bottomNavigationBar: buildbottomNavBar(),
            resizeToAvoidBottomInset: true,
            key: scaffoldKey,
            endDrawer: buildendDrawerScreen(),
            appBar: buildAppBar(),
            backgroundColor:
                setBackgroundColor() ?? HexColor.fromHex("#FBFBFB"),
            body: ChangeNotifierProvider.value(
                    value: viewModel,
                    child: SafeArea(child: buildBody()),
                  )),
      );

  void push({required Widget widget}) {
    Navigator.of(context)
        .push(
          //   MaterialPageRoute(
          //   builder: (context) => widget,
          // )
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) {
              return widget;
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = const Offset(1.0, 0.0);
              var end = Offset.zero;
              var curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        )
        .then((value) => loadPageData(value: value));
  }

  // void pop({dynamic result}) {
  //   if (Navigator.canPop(context) && mounted) Navigator.of(context).pop();
  // }
  // HexColor.fromHex("#048193")
  Widget showProgressBar({bool? reduceSize}) {
    return Center(
      child: LoadingAnimationWidget.discreteCircle(
        secondRingColor: HexColor.fromHex("#FF9201"),
        thirdRingColor: Colors.black,
        color: HexColor.fromHex("#048193"),
        size: reduceSize == true ? 30 : 40,
      ),
    );
  }

  void navigateWithSlideTransition(BuildContext context, Widget destination) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return destination;
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  void navigateWithSlideTransitionAndRemoveUntil(
      BuildContext context, Widget destination, RoutePredicate? predicate) {
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) {
            return destination;
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ),
        (route) => false);
  }

  void navigateWithSlideTransitionReplacement(
      BuildContext context, Widget destination) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return destination;
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(1.0, 0.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

 

  void navigateToLogin() {
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => const PhoneNumberScreen()),
    //     (route) => false);
  }
// void showTextMessage(String message){
//   Text(message);
// }
  void showMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context)
          .hideCurrentSnackBar(); //for solving multiple snackbar problem
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     duration: const Duration(seconds: 2),
      //     backgroundColor: Theme.of(context).indicatorColor,
      //     content: Text(
      //       message,
      //       style: TextStyle(color: Theme.of(context).primaryColor),
      //     ),
      //   ));
      // }
      // Fluttertoast.cancel();
      // Fluttertoast.cancel();
      // Fluttertoast.showToast(
      //     msg: message,
      //     fontSize: 30,
      //     backgroundColor: Theme.of(context).indicatorColor,
      //     textColor: Theme.of(context).primaryColor,
      //     gravity: ToastGravity.CENTER);
      final snackBar = SnackBar(
        content: Wrap(
          children: [
            const Icon(
              Icons.error,
              size: 18,
              color: Colors.white,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              message,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 120, left: 20, right: 20),
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        backgroundColor: Colors.red.shade700,
        duration: const Duration(seconds: 2),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void showMessageWithoutBorder(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context)
          .hideCurrentSnackBar(); //for solving multiple snackbar problem
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     duration: const Duration(seconds: 2),
      //     backgroundColor: Theme.of(context).indicatorColor,
      //     content: Text(
      //       message,
      //       style: TextStyle(color: Theme.of(context).primaryColor),
      //     ),
      //   ));
      // }
      // Fluttertoast.cancel();
      // Fluttertoast.cancel();
      // Fluttertoast.showToast(
      //     msg: message,
      //     fontSize: 30,
      //     backgroundColor: Theme.of(context).indicatorColor,
      //     textColor: Theme.of(context).primaryColor,
      //     gravity: ToastGravity.CENTER);
      final snackBar = SnackBar(
        content: Wrap(
          children: [
            const Icon(
              Icons.error,
              size: 18,
              color: Colors.red,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              message,
              style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(255, 250, 10, 10)),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 120, left: 20, right: 20),
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        backgroundColor: Colors.white,
        duration: const Duration(seconds: 2),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void showSuccessMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context)
          .hideCurrentSnackBar(); //for solving multiple snackbar problem
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     duration: const Duration(seconds: 2),
      //     backgroundColor: Theme.of(context).indicatorColor,
      //     content: Text(
      //       message,
      //       style: TextStyle(color: Theme.of(context).primaryColor),
      //     ),
      //   ));
      // }
      // Fluttertoast.cancel();
      // Fluttertoast.cancel();
      // Fluttertoast.showToast(
      //     msg: message,
      //     fontSize: 30,
      //     backgroundColor: Theme.of(context).indicatorColor,
      //     textColor: Theme.of(context).primaryColor,
      //     gravity: ToastGravity.CENTER);
      final snackBar = SnackBar(
        content: Wrap(
          alignment: WrapAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              message,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(bottom: 120, left: 20, right: 20),
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        backgroundColor: Colors.green.shade700,
        duration: const Duration(seconds: 2),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  void onNetworkConnected() {}
}
