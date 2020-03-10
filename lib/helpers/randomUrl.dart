import 'dart:math';

List<String> urls = [
  'https://en.m.wikipedia.org/wiki/Main_Page',
  'https://en.m.wikipedia.org/wiki/Kenora_Thistles',
  'https://en.m.wikipedia.org/wiki/Ice_hockey',
  'https://en.m.wikipedia.org/wiki/Team_sport',
  'https://en.m.wikipedia.org/wiki/Ancient_Olympic_Games'
  'https://en.m.wikipedia.org/wiki/Olympic_Games',
  'https://en.m.wikipedia.org/wiki/French_language',
  'https://en.m.wikipedia.org/wiki/Official_language',
  'https://en.m.wikipedia.org/wiki/United_States',
  'https://en.m.wikipedia.org/wiki/List_of_countries_by_GDP_(nominal)',
  'https://en.m.wikipedia.org/wiki/International_trade',
  'https://en.m.wikipedia.org/wiki/Capital_(economics)',
  'https://en.m.wikipedia.org/wiki/Capital_city',
  'https://en.m.wikipedia.org/wiki/Latin',
  'https://en.m.wikipedia.org/wiki/English_language',
  'https://en.m.wikipedia.org/wiki/Australia',
  'https://en.m.wikipedia.org/wiki/Vanuatu',
  'https://en.m.wikipedia.org/wiki/Solomon_Islands',
  'https://en.m.wikipedia.org/wiki/Papua_New_Guinea',
  'https://en.m.wikipedia.org/wiki/Oceania'
];

String randomUrl(){
  Random random = Random();
  return urls[random.nextInt(19)];
}
