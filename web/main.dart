import 'dart:html';
import 'dart:convert';
import 'package:dialog/dialog.dart';
import 'package:http/http.dart' as http;

void main() {

  var cities = [];
  cities.add('Santos');
  cities.add('Campinas');
  cities.add('São Paulo');
  cities.add('Londres');
  cities.add('Paris');

  loadData(cities);

  querySelector('#searchCity').onClick.listen((a) async {
    var myDialog = await prompt('Qual cidade buscar?');

    if(myDialog.toString().isNotEmpty){
        loadData([myDialog.toString()]);
    }else{
      alert('Nenhuma Cidade informada!');
    }
   });
}

Future getWeather(String city){
  const API_KEY = '';
  var url = 'https://api.hgbrasil.com/weather?format=json-cors&locale-pt&key=$API_KEY&city_name=$city';
  return http.get(url);
}

void loadData(List cities){
  var empty = querySelector('#empty');

  if(empty != null){
    empty.remove();
  }
  cities.forEach((city) {
    insertData(getWeather(city));
  });
}

void insertData(Future data) async{
  var insertData = await data;
  var body = json.decode(insertData.body);

  if(body['results']['forecast'].length > 0){
      var html = '<div class="row">';
      html +=  formatedHTML(body['results']['city_name']);
      html +=  formatedHTML(body['results']['temp']);
      html +=  formatedHTML(body['results']['description']);
      html +=  formatedHTML(body['results']['wind_speedy']);
      html +=  formatedHTML(body['results']['sunrise']);
      html +=  formatedHTML(body['results']['sunset']);
      html += '</div>';
      querySelector('.table').innerHtml += html;
  }
}

String formatedHTML(var data){
  return '<div class="cell">$data</div>';
}
