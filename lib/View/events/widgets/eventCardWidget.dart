
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app_colors.dart';
import '../../../main.dart';

class EventCardWidget extends StatelessWidget {
  const EventCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 25.0,
              top: 10,
              bottom: 10,
              right: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hey !',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.whiteColor,
                    fontSize: 12,
                  ),
                ),
                const Text(
                  'Its Heleena Hills Birthday !',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.whiteColor,
                    fontSize: 12,
                  ),
                ),
                const Text(
                  'Wish her all the Best',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.whiteColor,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 30),
                const Row(
                  children: [
                    CircleAvatar(radius: 25),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dr.Helena Hills',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.whiteColor,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'Pediatrition',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColors.whiteColor,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: ()async{

                  },
                  child: SizedBox(
                    width: 130,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor2,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Notify me',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColors.whiteColor,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.notifications_active,
                              color: AppColors.whiteColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            height: 70,
            width: 100,
            decoration: const BoxDecoration(
              color: AppColors.primaryColor2,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(21),
                topRight: Radius.circular(6),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image.asset('assets/icons/cake.png'),
            ),
          ),
        )
      ],
    );
  }

  // void _setAlarm(BuildContext context) async {
  //   // Set the alarm using AndroidAlarmManager
  //   await AndroidAlarmManager.oneShot(
  //     const Duration(seconds: 5), // Set the alarm to trigger after 5 seconds
  //     0, // Alarm ID
  //     _onAlarm, // Callback function to execute when the alarm triggers
  //     exact: true, // Specify exact timing for the alarm
  //     wakeup: true, // Wake up the device when the alarm triggers
  //   );
  //
  //   // Show a snackbar to indicate that the alarm has been set
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text('Alarm set successfully')),
  //   );
  // }


}
