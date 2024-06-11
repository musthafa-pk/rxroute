import 'package:flutter/material.dart';
import 'package:rxroute_test/Splash/splashscreen.dart';
import 'package:rxroute_test/Splash/successfully_added.dart';
import 'package:rxroute_test/Util/Routes/routes_name.dart';
import 'package:rxroute_test/View/MarkasVisited/markasVisited.dart';
import 'package:rxroute_test/View/authView/loginView.dart';
import 'package:rxroute_test/View/homeView/Doctor/add_doctor.dart';
import 'package:rxroute_test/View/homeView/Employee/add_rep.dart';
import 'package:rxroute_test/View/homeView/chemist/add_chemist.dart';
import 'package:rxroute_test/View/homeView/home_view.dart';
import 'package:rxroute_test/View/homeView/home_view_rep.dart';
import 'package:rxroute_test/constants/styles.dart';

class Routes{

  static Route<dynamic> generateRoute(RouteSettings settings,{Object? arguments}){

    switch (settings.name){

      case RoutesName.splash:
        return MaterialPageRoute(builder: (BuildContext context)=>const SplashScreen());

      case RoutesName.successsplash:
        return MaterialPageRoute(builder: (BuildContext context) =>const SuccessfullyAdded() ,);

      case RoutesName.home_rep:
        return MaterialPageRoute(builder: (BuildContext context)=>const HomeViewRep());

      case RoutesName.home_manager:
        return MaterialPageRoute(builder: (BuildContext context)=>const HomeView());

      case RoutesName.login:
        return MaterialPageRoute(builder: (BuildContext context)=>const LoginView());

      case RoutesName.add_doctor:
        return MaterialPageRoute(builder: (BuildContext context)=>const AddDoctor());

      case RoutesName.add_employee:
        return MaterialPageRoute(builder: (BuildContext context)=>const AddRep());

      case RoutesName.add_chemist:
        return MaterialPageRoute(builder: (BuildContext context)=>const AddChemist());


      default:
        return MaterialPageRoute(builder: (_){
          return const Scaffold(
            body: Center(child: Text('No Route defined',style: text60024black,),
            ),
          );
        });
    }
  }
}