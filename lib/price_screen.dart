import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  var selectedValue = currenciesList.first;

  DropdownButton<String> androidDropdownButton() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var dropItem = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );
      dropdownItems.add(dropItem);
    }
    return DropdownButton<String>(
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(
        color: Colors.deepOrange,
        fontWeight: FontWeight.bold,
      ),
      underline: Container(
        height: 2,
        color: Colors.deepOrangeAccent,
      ),
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedValue = value!;
          getData();
        });
      },
      value: selectedValue,
    );
  }

  CupertinoPicker iosCupertinoPicker() {
    List<Widget> cupertinoItems = [];
    for (String currency in currenciesList) {
      var widgetItem = Center(
        child: Text(
          currency,
          style: const TextStyle(color: Colors.white),
        ),
      );
      cupertinoItems.add(widgetItem);
    }
    return CupertinoPicker(
      itemExtent: 32.0,
      magnification: 1.22,
      squeeze: 1.2,
      onSelectedItemChanged: (int indexSelect) {
        setState(() {
          selectedValue = currenciesList[indexSelect];
          getData();
        });
      },
      children: cupertinoItems,
    );
  }

  Map<String, String> coinValues = {};
  bool isWaiting = false;

  Future<void> getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(selectedValue);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  Column makeCards() {
    List<CryptoCard> cryptoCards = [];
    for (String crypto in cryptoList) {
      cryptoCards.add(
        CryptoCard(
          value: isWaiting ? '?' : coinValues[crypto],
          selectedCurrency: selectedValue,
          cryptoSign: crypto,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          makeCards(),
          Container(
            color: Colors.lightBlue,
            height: 170.0,
            padding: const EdgeInsets.only(bottom: 30.0),
            alignment: Alignment.center,
            //child: iosCupertinoPicker(),
            child:
                Platform.isIOS ? iosCupertinoPicker() : androidDropdownButton(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    super.key,
    required this.value,
    required this.selectedCurrency,
    required this.cryptoSign,
  });

  final String? value;
  final String selectedCurrency;
  final String cryptoSign;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.lightBlueAccent,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 15.0),
          child: Text(
            '1 $cryptoSign = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
