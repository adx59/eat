
void renderMap(){
  for(int r = px-4; r <= px+4; r++){
    for(int c = py-4; c <= py+4; c++){
      int scX = (r - (px - 4)) * cellWidth, scY = (c - (py - 4)) * cellWidth;
      noStroke();
      if(r < 0 || c < 0 || r > 199 || c > 199){
        
        fill(0, 0, 0);
        rect(scX, scY, cellWidth, cellWidth);
      }
      else if(map[r][c] == 0){
        image(grass, scX, scY);
      }
      else if(map[r][c] == 1){
        if(pFace == 1){
          image(facing[0], scX, scY);
        }
        else if(pFace == 2){
          image(facing[1], scX, scY);
        }
        else if(pFace == 3){
          image(facing[2], scX, scY);
        }
        else if(pFace == 4){
          image(facing[3], scX, scY);
        }
      }
      else if(map[r][c] == 2){
        //draw berries
        int bush = 0;
        for(int b = 0; b < bC; b++){
          if(r == berries[b][0] && c == berries[b][1]){
            bush = berries[b][2];
          }
        }
        
        image(bushes[bush], scX, scY);
      }
      else if(map[r][c] == 3){
        //draw trees
        int wood = 0;
        for(int t = 0; t < tC; t++){
          if(r == trees[t][0] && c == trees[t][1]){
            wood = trees[t][2];
          }
        }
        
        fill(142, 105, 81);
        rect(scX, scY, cellWidth, cellWidth);
        fill(255, 255, 255);
        textSize(42);
        text(str(wood), cellWidth/2 - textWidth(str(wood))/2 + scX, cellWidth/1.65 + scY);
      }
      else if(map[r][c] == 4){
        int wleft = 0;
        
        fill(255, 185, 0);
        rect(scX, scY, cellWidth, cellWidth);
        fill(255, 255, 255);
        textSize(42);
        for(Fire f: fires){
          if(f.posx == r && f.posy == c){
            wleft = f.warmth;
          }
        }
        text(str(wleft), cellWidth/2 - textWidth(str(wleft))/2 + scX, cellWidth/1.65 + scY);
      }
      else if(map[r][c] == 5){
        int liqleft = 0;
        
        fill(131, 181, 255);
        rect(scX, scY, cellWidth, cellWidth);
        fill(255, 255, 255);
        textSize(42);
        for(int w = 0; w < wC; w++){
          if(water[w][0] == r && water[w][1] == c){
            liqleft = water[w][2];
          }
        }
        text(str(liqleft), cellWidth/2 - textWidth(str(liqleft))/2 + scX, cellWidth/1.65 + scY);
      }
    }
  }
  //draw position indicator
  String pos = "(" + str(px) + ", " + str(py) + ")";
  fill(0, 0, 255); textSize(50);
  text(pos, 1008/2 - textWidth(pos)/2, 50);
  
  //draw Berries Collected indicator
  fill(191, 0, 149);
  noStroke();
  rect(20, 20, 100, 100);
  fill(255, 255, 255);
  text(str(pB), (50 - textWidth(str(pB))/2) + 20,  90);
  
  //draw Wood Collected indicator
  fill(142, 105, 81);
  noStroke();
  rect(140, 20, 100, 100);
  fill(255, 255, 255);
  text(str(pW), (50 - textWidth(str(pW))/2) + 140,  90);
  
  stroke(0, 0, 0);
  strokeWeight(2);
  
  //draw HP bar
  fill(255, 0, 0); 
  rect(50, 933, hp/1.5, 50);
  textSize(24);
  fill(255, 255, 255);
  text("HP", 60, 968);
  
  //draw HUNGER bar
  fill(255, 125, 0);
  rect(50, 883, hung/1.5, 50);
  fill(255, 255, 255);
  text("HUNGER", 60, 920);
  
  //draw WARMTH bar
  fill(225, 225, 0);
  rect(50, 833, warm/1.5, 50);
  fill(255, 255, 255);
  text("WARMTH", 60, 870);
  
  //draw THIRST bar
  fill(145, 187, 255);
  rect(50, 783, thirst/1.5, 50);
  fill(255, 255, 255);
  text("THIRST", 60, 820);
}