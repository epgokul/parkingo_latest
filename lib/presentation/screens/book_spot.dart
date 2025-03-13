import 'package:flutter/material.dart';
import 'package:new_parkingo/data/model/land_model.dart';
import 'package:intl/intl.dart';
import 'package:new_parkingo/presentation/widgets/buttons/button.dart';
import 'package:new_parkingo/presentation/widgets/price_display.dart';
import 'package:scroll_datetime_picker/scroll_datetime_picker.dart';

import '../widgets/buttons/vehicle_button.dart';
import '../widgets/time_selector.dart';

class BookSpot extends StatefulWidget {
  final LandModel marker;
  const BookSpot({super.key, required this.marker});

  @override
  State<BookSpot> createState() => _BookSpotState();
}

class _BookSpotState extends State<BookSpot> {
  String price = '0';

  bool showStartTimePicker = false;
  bool showEndTimePicker = false;
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  bool car = false;
  bool heavy = false;
  bool auto = false;
  bool bike = false;
  bool bicycle = false;
  int parkingTime = 0;

  String formatTimeToHourAndMinute(DateTime time) {
    String formattedTime = DateFormat('hh:mm a').format(time);
    debugPrint(formattedTime);
    return formattedTime;
  }

  void openDateTimePicker({required bool isStartTime}) {
    showDialog(
      context: context,
      builder: (context) {
        DateTime selectedTime = isStartTime ? startTime : endTime;

        debugPrint("Selected time: $isStartTime");

        return AlertDialog(
          content: SizedBox(
            height: 300,
            width: 200,
            child: ScrollDateTimePicker(
              itemExtent: 54,
              infiniteScroll: false,
              dateOption: DateTimePickerOption(
                dateFormat: DateFormat('hh:mm a'),
                minDate: DateTime(2000, 6),
                maxDate: DateTime(2025, 6),
                initialDate:
                    selectedTime, // Ensure it starts with the correct time
              ),
              onChange: (datetime) {
                selectedTime = datetime; // Update selected time locally
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  if (isStartTime) {
                    startTime = selectedTime;
                  } else {
                    endTime = selectedTime;
                  }

                  // Recalculate price when time is updated
                  String selectedPrice = car
                      ? widget.marker.price.car
                      : heavy
                          ? widget.marker.price.heavy
                          : auto
                              ? widget.marker.price.auto
                              : bike
                                  ? widget.marker.price.bike
                                  : bicycle
                                      ? widget.marker.price.bicycle
                                      : "0";

                  parkingTimeCalculator(startTime, endTime, selectedPrice);
                });

                Navigator.pop(context);
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  void updateColorField(String type) {
    setState(() {
      if (type == "car") {
        car = !car;
        heavy = false;
        auto = false;
        bike = false;
        bicycle = false;
      } else if (type == "heavy") {
        car = false;
        heavy = !heavy;
        auto = false;
        bike = false;
        bicycle = false;
      } else if (type == "auto") {
        car = false;
        heavy = false;
        auto = !auto;
        bike = false;
        bicycle = false;
      } else if (type == "bike") {
        car = false;
        heavy = false;
        auto = false;
        bike = !bike;
        bicycle = false;
      } else if (type == "bicycle") {
        car = false;
        heavy = false;
        auto = false;
        bike = false;
        bicycle = !bicycle;
      }
    });
  }

  void parkingTimeCalculator(
      DateTime start, DateTime end, String pricePerHour) {
    if (end.isBefore(start)) {
      debugPrint("End time should be after start time.");
      return;
    }

    Duration difference = end.difference(start);
    int hours = difference.inHours;
    int minutes = difference.inMinutes.remainder(60);

    int pph = int.tryParse(pricePerHour) ?? 0; // Convert string to int safely
    double totalCost = (pph * hours) + (pph * (minutes / 60));
    int finalPrice = totalCost.round();

    setState(() {
      price = finalPrice.toString();
    });

    debugPrint("Parking Time: $hours hours and $minutes minutes");
  }

  @override
  Widget build(BuildContext context) {
    Widget vehicleButton(String type, String iconPath, String price,
        VoidCallback onTap, bool selected) {
      return VehicleButton(
        image: iconPath,
        vehicleType: type,
        onTap: onTap,
        colorSelector: selected,
      );
    }

    void selectVehicle(String type, String vehiclePrice) {
      setState(() {
        startTime = DateTime.now();
        endTime = DateTime.now();

        updateColorField(type);
        parkingTimeCalculator(startTime, endTime, vehiclePrice);
      });
    }

    Widget buildVehicleButtons() {
      var vehiclePrice = widget.marker.price;
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              vehicleButton("Car", 'assets/icons/car.png', vehiclePrice.car,
                  () {
                selectVehicle("car", vehiclePrice.car);
              }, car),
              vehicleButton(
                  "Bike", 'assets/icons/motorcycle.png', vehiclePrice.bike, () {
                selectVehicle("bike", vehiclePrice.bike);
              }, bike),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              vehicleButton(
                  "Auto", 'assets/icons/auto_rickshaw.png', vehiclePrice.auto,
                  () {
                selectVehicle("auto", vehiclePrice.auto);
              }, auto),
              vehicleButton(
                  "Bicycle", 'assets/icons/bicycle.png', vehiclePrice.bicycle,
                  () {
                selectVehicle("bicycle", vehiclePrice.bicycle);
              }, bicycle),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: vehicleButton(
                "Heavy Vehicles", 'assets/icons/lorry.png', vehiclePrice.heavy,
                () {
              selectVehicle("heavy", vehiclePrice.heavy);
            }, heavy),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    Container(
                      height: 300,
                      width: MediaQuery.sizeOf(context).width * 3 / 4,
                      decoration: const BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 300,
                      width: MediaQuery.sizeOf(context).width * 3 / 4,
                      decoration: const BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                widget.marker.district,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              Text(
                widget.marker.place,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Select your vehicle type",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 10,
              ),
              buildVehicleButtons(),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  TimeSelector(
                      label: "Starting Time",
                      time: startTime,
                      onTap: () {
                        openDateTimePicker(isStartTime: true);
                      }),
                  const SizedBox(height: 10),
                  TimeSelector(
                      label: "Ending Time",
                      time: endTime,
                      onTap: () {
                        openDateTimePicker(isStartTime: false);
                      }),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              PriceDisplay(price: price),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                  text: "Book Now",
                  onTap: () {},
                  color: Colors.green,
                  textColor: Colors.white,
                  width: MediaQuery.sizeOf(context).width)
            ],
          ),
        ),
      ),
    );
  }
}
