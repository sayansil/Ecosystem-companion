
import 'package:ecosystem/utility/simulation_helpers.dart';

class SampleSpecies {
  KingdomName kingdom;
  String name;

  String baseUrl;
  String modifyUrl;

  SampleSpecies(this.kingdom, this.name, this.baseUrl, this.modifyUrl);
}

var sampleSpeciesList = [
  SampleSpecies(
      KingdomName.animal,
      "deer",
      "https://raw.githubusercontent.com/sayansil/Ecosystem/master/data/json/animal/deer/base.json",
      "https://raw.githubusercontent.com/sayansil/Ecosystem/master/data/json/animal/deer/modify.json",
  ),
  SampleSpecies(
    KingdomName.plant,
    "bamboo",
    "https://raw.githubusercontent.com/sayansil/Ecosystem/master/data/json/plant/bamboo/base.json",
    "https://raw.githubusercontent.com/sayansil/Ecosystem/master/data/json/plant/bamboo/modify.json",
  ),
];