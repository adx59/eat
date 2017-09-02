
void viewMap(){
  noStroke();
  float csize = 1008.0/200.0;
  for(float r = 0.0; r < 200; r += 1.0){
    for(float c = 0.0; c < 200; c += 1.0){
      float pxx = r * csize, pxy = c * csize;
      if(map[int(r)][int(c)] == 0){
        fill(42, 178, 51);
      }
      else if(map[int(r)][int(c)] == 1){
        fill(255, 255, 255);
      }
      else if(map[int(r)][int(c)] == 2){
        fill(105, 0, 107);
      }
      else if(map[int(r)][int(c)] == 3){
        fill(142, 105, 81);
      }
      else if(map[int(r)][int(c)] == 4){
        fill(255, 185, 0);
      }
      else if(map[int(r)][int(c)] == 5){
        fill(131, 181, 255);
      }
      rect(pxx, pxy, csize, csize);
    }
  }
}