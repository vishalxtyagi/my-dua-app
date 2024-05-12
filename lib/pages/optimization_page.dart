import 'package:dua/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';

class OptimizationSetting {
  final String title;
  bool? isEnable;
  final Function? onTap;

  OptimizationSetting(this.title, {this.isEnable, this.onTap});
}

class OptimizationPage extends StatefulWidget {
  @override
  _OptimizationPageState createState() => _OptimizationPageState();
}

class _OptimizationPageState extends State<OptimizationPage> {
  List<OptimizationSetting> listData = [];

  void addOptimizationData() async {
    final options = [
      OptimizationSetting(
          "Enable Auto Start",
          isEnable: await DisableBatteryOptimization.isAutoStartEnabled,
          onTap: () async {
            await DisableBatteryOptimization.showEnableAutoStartSettings(
                "Enable Auto Start",
                "Follow the steps and enable the auto start of this app");

            bool? autoStartEnabled = await DisableBatteryOptimization.isAutoStartEnabled;
            setState(() {
              listData[0].isEnable = autoStartEnabled;
            });
          }
      ),
      OptimizationSetting(
          "Disable Battery Optimization",
          isEnable: await DisableBatteryOptimization.isBatteryOptimizationDisabled,
          onTap: () async {
            await DisableBatteryOptimization
                .showDisableBatteryOptimizationSettings();

            bool? batteryOptimizationDisabled = await DisableBatteryOptimization.isBatteryOptimizationDisabled;
            setState(() {
              listData[1].isEnable = batteryOptimizationDisabled;
            });
          }
      ),
      OptimizationSetting(
          "Disable Manufacturer Battery Optimization",
          isEnable: await DisableBatteryOptimization.isManufacturerBatteryOptimizationDisabled,
          onTap: () async {
            await DisableBatteryOptimization
                .showDisableManufacturerBatteryOptimizationSettings(
                "Your device has additional battery optimization",
                "Follow the steps and disable the optimizations to allow smooth functioning of this app");

            bool? manufacturerBatteryOptimizationDisabled = await DisableBatteryOptimization.isManufacturerBatteryOptimizationDisabled;
            setState(() {
              listData[2].isEnable = manufacturerBatteryOptimizationDisabled;
            });
          }
      ),
      OptimizationSetting(
          "Disable All Battery Optimization",
          isEnable: await DisableBatteryOptimization.isAllBatteryOptimizationDisabled,
          onTap: () async {
            await DisableBatteryOptimization.showDisableAllOptimizationsSettings(
                "Enable Auto Start",
                "Follow the steps and enable the auto start of this app",
                "Your device has additional battery optimization",
                "Follow the steps and disable the optimizations to allow smooth functioning of this app");

            bool? allBatteryOptimizationDisabled = await DisableBatteryOptimization.isAllBatteryOptimizationDisabled;
            setState(() {
              listData[3].isEnable = allBatteryOptimizationDisabled;
            });
          }
      ),
    ];

    // Add your data to the list
    setState(() {
      listData.clear();
      listData.addAll(options);
    });
  }

  @override
  void initState() {
    super.initState();
    addOptimizationData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
            'assets/images/logoi.png',
            width: 225
        ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: listData.length,
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.only(bottom: 15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(
                color: AppColors.blackColor,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              title: Text(listData[index].title, style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              tileColor: Colors.white,
              leading: listData[index].isEnable ?? false ? Icon(Icons.check_circle_outline_rounded, color: AppColors.primaryColor) : Icon(Icons.cancel_rounded, color: Colors.red),
              onTap: () {
                if (listData[index].isEnable ?? false) {
                  // show message that it is already enabled
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(listData[index].title),
                        content: Text("This feature is already enabled on your device"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("OK"),
                          )
                        ],
                      );
                    }
                  );
                  return;
                }

                if (listData[index].onTap != null) {
                  listData[index].onTap!();
                }
              },
            ),
          );
        },
      )
    );
  }
}