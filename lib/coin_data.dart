import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinBaseURL = "https://rest.coinapi.io/v1/exchangerate";
const apiKey = "C631B04A-C927-4A3A-A9B1-18926A53BA3B";

class CoinData {
  Future getCoinData(String currency) async {
    Map<String, String> cryptoPrices = {};
    for (String cryptoSign in cryptoList) {
      var requestUrl = Uri.https('rest.coinapi.io',
          'v1/exchangerate/$cryptoSign/$currency', {'apikey': '$apiKey'});
      //String requestUrl = "$coinBaseURL/$cryptoSign/$currency?apiKey=$apiKey";

      var response = await http.get(requestUrl);
      if (response.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        double priceRate = jsonResponse['rate'];
        cryptoPrices[cryptoSign] = priceRate.toStringAsFixed(0);
      } else {
        print('Request failed with status code: ${response.statusCode}.');
      }
    }
    return cryptoPrices;
  }
}
