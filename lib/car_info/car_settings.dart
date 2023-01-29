import 'package:flutter/material.dart';

import 'car.dart';


class CarSettings extends StatefulWidget {
  const CarSettings({Key? key}) : super(key: key);

  @override
  State<CarSettings> createState() => CarSettingsState();
}

class CarSettingsState extends State<CarSettings> with AutomaticKeepAliveClientMixin{
late List<Car> carList;
List<String> carNames = ['Tesla Model 3 LR', 'Tesla Model 3 Performance', 'Audi e-tron GT', 'Tesla Model S Plaid', 'Volkswagen ID.3'];
String?  selectedCar;


Car c1 = Car('Tesla Model 3 LR', 602, const AssetImage('assets/Model3_LongRange.png'));
Car c2 = Car('Tesla Model 3 Performance', 547, const AssetImage('assets/Model3_Performance.png'));
Car c3 = Car('Audi e-tron GT', 458, const AssetImage('assets/AudiEtron-GT.png'));
Car c4 = Car('Tesla Model S Plaid', 600, const AssetImage('assets/ModelS_Plaid.png'));
Car c5 = Car('Volkswagen ID.3', 545, const AssetImage('assets/VW-ID3.png'));
Car defaultCar = Car('No Car selected', 0, const AssetImage('assets/default.png'));

late Car currentCar = defaultCar;


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return  Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children:  [
          const SizedBox(height: 80),
          const Center(
            child: Text('Your car', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
          ),
          DropdownButton<String>(
            disabledHint: null,
              hint: const Text('Select your car'),
              value: selectedCar,
              items: carNames.map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: const TextStyle(fontSize: 20)),
              )).toList(),
              onChanged: (item) {
                setState(() {
                  selectedCar = item!;
                  updateCar();
                });
              },
          ),
          const SizedBox(height: 80),
          ClipRect(child:
            Image.asset(currentCar.image.assetName),
          )


        ],

      ),
      //backgroundColor: Colors.grey,
    );

  }

  void updateCar() {
    Car car = c1;
    switch (selectedCar) {
      case 'Tesla Model 3 LR': car = c1;
        break;
      case 'Tesla Model 3 Performance': car = c2;
        break;
      case  'Audi e-tron GT': car = c3;
        break;
      case   'Tesla Model S Plaid': car = c4;
        break;
      case   'Volkswagen ID.3': car = c5;
        break;
    }
    setState(() {
      currentCar = car;
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;


}