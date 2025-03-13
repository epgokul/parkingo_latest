import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:new_parkingo/domain/blocs/add_spot/add_spot_bloc.dart';
import 'package:new_parkingo/domain/blocs/add_spot/add_spot_event.dart';
import 'package:new_parkingo/domain/blocs/add_spot/add_spot_state.dart';
import 'package:new_parkingo/presentation/widgets/buttons/button.dart';
import 'package:new_parkingo/presentation/widgets/location_selector.dart';
import 'package:new_parkingo/presentation/widgets/radio_row.dart';
import 'package:new_parkingo/presentation/widgets/textfield.dart';

import '../../domain/entities/user_entity.dart';

class AddLandPage extends StatefulWidget {
  const AddLandPage({super.key, required this.user});
  final UserEntity user;

  @override
  State<AddLandPage> createState() => _AddLandPageState();
}

class _AddLandPageState extends State<AddLandPage> {
  Position? position;
  LatLng? selectedLocation;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController placeController = TextEditingController();
  TextEditingController carPriceController = TextEditingController();
  TextEditingController motorCyclePriceController = TextEditingController();
  TextEditingController autoRickshawpriceController = TextEditingController();
  TextEditingController heavyVehiclePriceController = TextEditingController();
  TextEditingController bicyclePriceController = TextEditingController();
  Map<String, String> price = {};
  static const List<String> list = [
    'Select your district',
    'Kasargode',
    'Kannur',
    'Wayanad',
    'Kozhikode',
    'Malappuram',
    'Trissur',
    'Palakkad',
    'Kottayam',
    'Alappuzha',
    'Idukki',
    'Eranakulam',
    'Pathanamthitta',
    'Kollam',
    'Trivandrum'
  ];
  String dropdownValue = list.first;
  bool ischeckedCar = false;
  bool ischeckedMotorCycle = false;
  bool ischeckedAuto = false;
  bool ischeckedHeavy = false;
  bool ischeckedCycle = false;

  Future<void> getCurrentPosition() async {
    try {
      Position currentPosition = await Geolocator.getCurrentPosition();

      if (!mounted) return;

      setState(() {
        position = currentPosition;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  void deleteControllerValues() {
    motorCyclePriceController.text = '';
    carPriceController.text = '';
    motorCyclePriceController.text = '';
    heavyVehiclePriceController.text = '';
    bicyclePriceController.text = '';
    autoRickshawpriceController.text = '';
  }

  Future<void> openLocationSelector() async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            child: LocationSelector(position),
          ),
        );
      },
    );

    if (result != null && result is LatLng) {
      setState(() {
        selectedLocation = result;
      });
    }
  }

  bool validateFields() {
    if (nameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        numberController.text.isEmpty ||
        placeController.text.isEmpty ||
        carPriceController.text.isEmpty ||
        motorCyclePriceController.text.isEmpty ||
        autoRickshawpriceController.text.isEmpty ||
        heavyVehiclePriceController.text.isEmpty ||
        dropdownValue == 'Select your district' ||
        bicyclePriceController.text.isEmpty) {
      return false;
    }

    if ((ischeckedCar && carPriceController.text.isEmpty) ||
        (ischeckedMotorCycle && motorCyclePriceController.text.isEmpty) ||
        (ischeckedAuto && autoRickshawpriceController.text.isEmpty) ||
        (ischeckedHeavy && heavyVehiclePriceController.text.isEmpty) ||
        (ischeckedCycle && bicyclePriceController.text.isEmpty)) {
      return false;
    }
    if (price.containsValue('') || price.isEmpty) {
      return false;
    }

    return true;
  }

  Map<String, String> updatePrices() {
    Map<String, String> prices = {
      "car": carPriceController.text,
      "bike": motorCyclePriceController.text,
      "auto": autoRickshawpriceController.text,
      "heavy": heavyVehiclePriceController.text,
      "bicycle": bicyclePriceController.text
    };
    price.addAll(prices);

    return price;
  }

  @override
  void initState() {
    super.initState();
    getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: BlocListener<AddSpotBloc, AddSpotState>(
          listener: (context, state) {
            if (state is AddSpotSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      "Request sent successfully to add your parking spot!")));
              Navigator.pop(context);
            } else if (state is AddSpotFailState) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Failed to send request"),
              ));
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Owner Name"),
                  CustomTextfield(
                      obscureText: false,
                      normalBorderColor: Colors.black,
                      focusedBorderColor: Colors.amber,
                      controller: nameController,
                      keyboardType: TextInputType.text),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("Description"),
                  CustomTextfield(
                      obscureText: false,
                      normalBorderColor: Colors.black,
                      focusedBorderColor: Colors.amber,
                      controller: descriptionController,
                      keyboardType: TextInputType.text),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("Place Name"),
                  CustomTextfield(
                      obscureText: false,
                      normalBorderColor: Colors.black,
                      focusedBorderColor: Colors.amber,
                      controller: placeController,
                      keyboardType: TextInputType.text),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButton(
                    value: dropdownValue,
                    items: list.map<DropdownMenuItem>(
                      (String value) {
                        return DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      setState(() {
                        dropdownValue = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("Contact number"),
                  CustomTextfield(
                      obscureText: false,
                      normalBorderColor: Colors.black,
                      focusedBorderColor: Colors.amber,
                      controller: numberController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true)),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("Vehicles that can park"),
                  const SizedBox(
                    height: 20,
                  ),
                  RadioRow(
                    value: ischeckedCar,
                    controller: carPriceController,
                    vehicleType: 'Cars',
                    onChanged: (bool? value) {
                      setState(() {
                        ischeckedCar = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  RadioRow(
                    value: ischeckedMotorCycle,
                    controller: motorCyclePriceController,
                    vehicleType: 'Motor Cycle',
                    onChanged: (bool? value) {
                      setState(() {
                        ischeckedMotorCycle = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  RadioRow(
                    value: ischeckedAuto,
                    controller: autoRickshawpriceController,
                    vehicleType: 'Auto Rickshaw',
                    onChanged: (bool? value) {
                      setState(() {
                        ischeckedAuto = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  RadioRow(
                    value: ischeckedHeavy,
                    controller: heavyVehiclePriceController,
                    vehicleType: 'Heavy Vehicles',
                    onChanged: (bool? value) {
                      setState(() {
                        ischeckedHeavy = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  RadioRow(
                    value: ischeckedCycle,
                    controller: bicyclePriceController,
                    vehicleType: 'Bicycle',
                    onChanged: (bool? value) {
                      setState(() {
                        ischeckedCycle = value!;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: CustomButton(
                        width: 300,
                        text: "Tap to select location",
                        onTap: openLocationSelector,
                        color: Colors.amber,
                        textColor: Colors.black),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(selectedLocation == null
                      ? "No location selected: "
                      : selectedLocation.toString()),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: CustomButton(
                        width: 300,
                        text: "Send Request",
                        onTap: () {
                          updatePrices();
                          if (validateFields()) {
                            var latitude = selectedLocation!.latitude;
                            var longitude = selectedLocation!.longitude;
                            var contactNumber = numberController.text;
                            var ownerName = nameController.text;
                            var userId = widget.user.uid;
                            var place = placeController.text;
                            var district = dropdownValue;
                            var description = descriptionController.text;

                            context.read<AddSpotBloc>().add(AddSpotSuccess(
                                latitude: latitude,
                                longitude: longitude,
                                description: description,
                                price: updatePrices(),
                                contactNumber: contactNumber,
                                ownerName: ownerName,
                                userId: userId,
                                place: place,
                                district: district));
                            deleteControllerValues();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Fill all fields properly")));

                            debugPrint(dropdownValue);
                          }
                        },
                        color: Colors.black,
                        textColor: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
