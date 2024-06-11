import 'package:flutter/material.dart';
import 'package:rxroute_test/View/events/widgets/eventCardWidget.dart';

import '../../app_colors.dart';

class Events extends StatefulWidget {
  String eventType;
  Events({required this.eventType,super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.arrow_back, color: AppColors.whiteColor),
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          widget.eventType.toString(),
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child:ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.only(left: 10.0,right: 10,top: 10),
            child: EventCardWidget(),
          );
        },)
      ),
    );
  }
}
