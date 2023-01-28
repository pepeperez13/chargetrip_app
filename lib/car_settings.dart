import 'package:flutter/material.dart';

import 'car.dart';


class CarSettings extends StatefulWidget {
  const CarSettings({Key? key}) : super(key: key);

  @override
  State<CarSettings> createState() => CarSettingsState();
}

class CarSettingsState extends State<CarSettings> {
late List<Car> carList;
List<String> carNames = ['Tesla Model 3 LR', 'Tesla Model 3 Performance', 'Audi e-tron GT', 'Tesla Model S Plaid', 'Volkswagen ID.3'];
String  selectedCar= 'Tesla Model 3 LR';

Car c1 = Car('Tesla Model 3 LR', 602, const AssetImage('assets/Model3_LongRange.png'));
Car c2 = Car('Tesla Model 3 Performance', 547, const AssetImage('assets/Model3_Performance.png'));
Car c3 = Car('Audi e-tron GT', 458, const AssetImage('assets/AudiEtron-GT.png'));
Car c4 = Car('Tesla Model S Plaid', 600, const AssetImage('assets/Model3_Plaid.png'));
Car c5 = Car('Volkswagen ID.3', 545, const AssetImage('assets/VW-ID.3'));





  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children:  [
          const SizedBox(height: 80),
          const Center(
            child: Text('Your car', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
          ),
          DropdownButton<String>(
              value: selectedCar,
              items: carNames.map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: TextStyle(fontSize: 20)),
              )).toList(),
              onChanged: (item) => setState (() => selectedCar = item!),
      ),






        ],

      )

    );


  }


}