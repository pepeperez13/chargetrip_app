import 'package:chargetrip_app/routes/route_map.dart';
import 'package:flutter/material.dart';

import 'car.dart';

/// Esta clase cotiene y gestiona todas las acciones que se hacen en la parte de configuración del vehiculo

class CarSettings extends StatefulWidget {
  const CarSettings({Key? key}) : super(key: key);

  @override
  State<CarSettings> createState() => CarSettingsState();
}

class CarSettingsState extends State<CarSettings> with AutomaticKeepAliveClientMixin{
// Definimos los valores que aparecerán en el dropdown
List<String> carNames = ['Tesla Model 3 LR', 'Tesla Model 3 Performance', 'Audi e-tron GT', 'Tesla Model S Plaid', 'Volkswagen ID.3', 'Renault ZOE', 'Nissan Leaf'];
// String que cotendrá el vehiculo seleccionado en cualquier momento
String?  selectedCar;

Car c1 = Car('Tesla Model 3 LR', 602, const AssetImage('assets/Model3_LongRange.png'));
Car c2 = Car('Tesla Model 3 Performance', 547, const AssetImage('assets/Model3_Performance.png'));
Car c3 = Car('Audi e-tron GT', 458, const AssetImage('assets/AudiEtron-GT.png'));
Car c4 = Car('Tesla Model S Plaid', 600, const AssetImage('assets/ModelS_Plaid.png'));
Car c5 = Car('Volkswagen ID.3', 545, const AssetImage('assets/VW-ID3.png'));
Car c6 = Car('Renault ZOE', 250, const AssetImage('assets/Renault_ZOE.png'));
Car c7 = Car('Nissan Leaf', 355, const AssetImage('assets/Nissan_Leaf.png'));
Car defaultCar = Car('No Car selected', 0, const AssetImage('assets/default.png'));

// Car seleccionado, lo inicializamos al default (coche vacío)
late Car currentCar = defaultCar;

  @override
  Widget build(BuildContext context) {
    super.build(context); //Mantiene el estado aunque cambiemos de pagina
    return  Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children:  [
          const SizedBox(height: 80),
          const Center(
            child: Text('Your car', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
          ),
          // DropdownButton para escoger el coche
          DropdownButton<String>(
            disabledHint: null,
              hint: const Text('Select your car'),
              value: selectedCar,
              items: carNames.map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, style: const TextStyle(fontSize: 20)),
              )).toList(),
              onChanged: (item) {
              super.setState(() {
                selectedCar = item!;
                updateCar();
              });
              },
          ),
          const SizedBox(height: 30),
          // Mostramos imagen del coche seleccionado
          ClipRect(child:
            Image.asset(currentCar.image.assetName),
          ),
          const SizedBox(height: 20),
          // Mostramos autonomia del coche actual
          Container(
            //color: Colors.green,
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
                color: Colors.green,
                border: Border.all(color: Colors.black),
                borderRadius: const BorderRadius.all(Radius.circular(30))
            ),
            child: Text('Available range: ${currentCar.range} KM', style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(height:20,),
          // Añadimos texto explicando qué funcionalidades tiene la app
          Row(
            children: [
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration: BoxDecoration(
                  color: Colors.blue[800]?.withOpacity(0.7),
                  border: Border.all(color: Colors.black),
                  borderRadius: const BorderRadius.all(Radius.circular(30))
                ),
                child: const Text(
                'Go to the map and check out if this \ncar has enough range for your route.\nRemember that you can check \nnearby chargers by tapping anywhere \nin the map.',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
                )
                ),
              const SizedBox(width: 10)
            ],
          )
        ],
      ),
    );
  }

  // Segun el nombre del coche seleccionado, nos guardamos toda la info de ese coche
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
      case   'Renault ZOE': car = c6;
        break;
      case   'Nissan Leaf': car = c7;
      break;
    }
    setState(() {
      currentCar = car;
      // Enviamos el coche seleccionado a la pagina de rutas
      MapSampleState().callback(car);
    });

  }

  //Queremos que se mantenga el estado
  @override
  bool get wantKeepAlive => true;

}