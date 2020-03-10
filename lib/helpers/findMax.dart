int findMax(Map<dynamic,dynamic> map) {
  int res = 0;
  map.forEach((key, value){
    if (value > res) {
      res = value;
    }
  });
  return res;
}
