//dimenX = 9, dimenY = 9

//fire class, so we don't have to use a 2d arraylist(if that exists)
class Fire{
  int posx = 0, posy = 0, warmth = 0;
  Fire(int x, int y){
    posx = x;
    posy = y;
    warmth = int(random(5, 10));
  }
}

int bC = 600; //berry count
int tC = 800; //tree count
int wC = 1000; //water count
float hp = 500.0;
float hung = 500.0;
float warm = 500.0;
float thirst = 500.0;
//2d array of the map
int[][] map = new int[200][200];
//2d array of berry tree locations and berry count
int[][] berries = new int[bC][3];
//2d array of tree locations and wood count
int[][] trees = new int[tC][3];
//2d array of water locations and water left
int[][] water = new int[wC][3];
//arraylist of fires the player has set down
ArrayList<Fire> fires = new ArrayList<Fire>();
int pB = 0; //player's berries
int pW = 0; //player's wood
int cellWidth = 112;
int px = 100, py = 100; //player position
int pFace = 4; //player faces which direction
boolean start = false;
boolean end = false; 
boolean viewingMap = false;
int starttime = hour()*3600 + minute()*60 + second();
int endtime;

void startScreen(){
  background(0, 0, 0);
  textSize(200);
  fill(255, 255, 255);
  text("EAT" , 1008/2 - textWidth("EAT")/2, 400);
  textSize(80);
  text("Press any key to start.", 1008/2 - textWidth("Press any key to start.")/2, 600);
  if(keyPressed){start = true;}
}

void endScreen(){
  int score = endtime - starttime;
  background(0, 0, 0);
  textSize(200);
  fill(255, 255, 255);
  text("YOU DIED", 1008/2 - textWidth("YOU DIED")/2, 200);
  textSize(50);
  text("Sadly, all journeys must come to an end.", 1008/2 - textWidth("Sadly, all journeys must come to an end.")/2, 300);
  text("But you played a great game.", 1008/2 - textWidth("But you played a great game.")/2, 370);
  textSize(70);
  text("YOUR JOURNEY LASTED", 1008/2 - textWidth("YOUR JOURNEY LASTED")/2, 600);
  fill(0, 255, 0);
  text(str(score), 1008/2 - textWidth(str(score))/2, 700);
  fill(255, 255, 255);
  text("SECONDS", 1008/2 - textWidth("SECONDS")/2, 800);
}

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

void renderMap(){
  for(int r = px-4; r <= px+4; r++){
    for(int c = py-4; c <= py+4; c++){
      int scX = (r - (px - 4)) * cellWidth, scY = (c - (py - 4)) * cellWidth;
      stroke(255, 255, 255);
      if(r < 0 || c < 0 || r > 199 || c > 199){
        strokeWeight(5);
        fill(0, 0, 0);
        rect(scX, scY, cellWidth, cellWidth);
      }
      else if(map[r][c] == 0){
        strokeWeight(5); //draw grass
        fill(42, 178, 51);
        rect(scX, scY, cellWidth, cellWidth);
      }
      else if(map[r][c] == 1){
        strokeWeight(10); //draw player
        fill(16, 36, 183);
        rect(scX, scY, cellWidth, cellWidth);
        noStroke(); fill(255, 255, 255);
        //draw player facing indicator
        if(pFace == 1){
          rect(scX, scY, cellWidth, cellWidth/6);
        }
        else if(pFace == 2){
          rect(scX + (5*cellWidth)/6 , scY, cellWidth/6, cellWidth );
        }
        else if(pFace == 3){
          rect(scX, scY + (5*cellWidth)/6, cellWidth, cellWidth/6);
        }
        else if(pFace == 4){
          rect(scX, scY, cellWidth/6, cellWidth);
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
        strokeWeight(7);
        fill(int(random(90, 120)), 0, int(random(100, 114)));
        rect(scX, scY, cellWidth, cellWidth);
        fill(255, 255, 255);
        textSize(42);
        text(str(bush), cellWidth/2 - textWidth(str(bush))/2 + scX, cellWidth/1.65 + scY);
      }
      else if(map[r][c] == 3){
        //draw trees
        int wood = 0;
        for(int t = 0; t < tC; t++){
          if(r == trees[t][0] && c == trees[t][1]){
            wood = trees[t][2];
          }
        }
        strokeWeight(7);
        fill(142, 105, 81);
        rect(scX, scY, cellWidth, cellWidth);
        fill(255, 255, 255);
        textSize(42);
        text(str(wood), cellWidth/2 - textWidth(str(wood))/2 + scX, cellWidth/1.65 + scY);
      }
      else if(map[r][c] == 4){
        int wleft = 0;
        strokeWeight(7);
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
        strokeWeight(7);
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
  text(pos, 1008/2 - textWidth(pos)/2, 50); //<>//
  
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

void setup(){
  size(1008, 1008);
  for(int b = 0; b < bC; b++){
    int rx = int(random(200)), ry = int(random(200));
    for(int pBs = 0; pBs < b; pBs++){
      while(rx == berries[pBs][0] && ry == berries[pBs][1]){
        rx = int(random(200));
        ry = int(random(200));
      }
    }
    berries[b][0] = rx;
    berries[b][1] = ry;
    berries[b][2] = int(random(3, 10));
    map[rx][ry] = 2;
  }
  for(int t = 0; t < tC; t++){
    int tx = int(random(200)), ty = int(random(200));
    for(int b = 0; b < bC; b++){
      while(tx == berries[b][0] && ty == berries[b][1]){
        tx = int(random(200));
        ty = int(random(200));
      }
    }
    for(int tr = 0; tr < t; tr++){
      while(trees[tr][0] == tx && trees[tr][1] == ty){
        tx = int(random(200));
        ty = int(random(200));
      }
    }
    trees[t][0] = tx;
    trees[t][1] = ty;
    trees[t][2] = int(random(3, 15));
    map[tx][ty] = 3;
  }
  for(int w = 0; w < wC; w++){
    int wx = int(random(200)), wy = int(random(200));
    for(int b = 0; b < bC; b++){
      while(wx == berries[b][0] && wy == berries[b][1]){
        wx = int(random(200));
        wy = int(random(200));
      }
    }
    for(int tr = 0; tr < tC; tr++){
      while(trees[tr][0] == wx && trees[tr][1] == wy){
        wx = int(random(200));
        wy = int(random(200));
      }
    }
    for(int wa = 0; wa < w; wa++){
      while(water[wa][0] == wx && water[wa][1] == wy){
        wx = int(random(200));
        wy = int(random(200));
      }
    }
    water[w][0] = wx;
    water[w][1] = wy;
    water[w][2] = int(random(3, 10));
    map[wx][wy] = 5;
  }
  for(int r = 0; r < 200; r++){
    for(int c = 0; c < 200; c++){
      if(r == px && c == py){
        map[r][c] = 1;     
      }  
    }
  }
}

void draw(){
  int ox = px, oy = py;
  if(!start){
    startScreen();
    return;
  }
  if(end){
    endScreen();
    return;
  }
  if(viewingMap){
    viewMap();
    if(keyPressed && (key == 'm' || key == 'M')){viewingMap = false; delay(200);}
    delay(100);
    return;
  }
  if(hp <= 0){
    endtime = hour()*3600 + minute()*60 + second();
    end = true;
    delay(100);
  }
  
  warm -= 0.5; hung -= 1.0; thirst -= 1.5;
  
  if (hung < 50){
    hp -= 0.9;
  }
  else if (hung < 200){
    hp -= 0.3;
  }
  
  if (warm < 50){
    hp -= 1.2;
  }
  else if(warm < 200){
    hp -= 0.8;
  }
  if(thirst < 20){
    hp -= 2.0;
  }
  else if(thirst < 100){
    hp -= 1.3;
  }
  
  if(keyPressed){
    if (keyCode >= 37 && keyCode <= 40){
      hung -= 1.75;
    }
    else if(key == ' '){
      hung -= 0.25;
    }
    
    if(keyCode == 37){
      map[px][py] = 0;
      for(int b = 0; b < bC; b++){
        if(berries[b][0] == px && berries[b][1] == py){
          map[px][py] = 2;        
        }
      }
      for(int t = 0; t < tC; t++){
        if(trees[t][0] == px && trees[t][1] == py){
          map[px][py] = 3;        
        }
      }
      px--;
      if(px < 0){
        px = 0;
      }
      if(py < 0){
        py = 0;
      }
      if(px > 199){
        px = 199;
      }
      if(py > 199){
        py = 199;
      }
      pFace = 4;
      
    }
    else if(keyCode == 39){
      map[px][py] = 0;
      for(int b = 0; b < bC; b++){
        if(berries[b][0] == px && berries[b][1] == py){
          map[px][py] = 2;        
        }
      }
      for(int t = 0; t < tC; t++){
        if(trees[t][0] == px && trees[t][1] == py){
          map[px][py] = 3;        
        }
      }
      px++;
      if(px < 0){
        px = 0;
       }
      if(py < 0){
        py = 0;
      }
      if(px > 199){
        px = 199;
      }
      if(py > 199){
        py = 199;
      }
      pFace = 2;
      
    }
    else if(keyCode == 38){
      map[px][py] = 0;
      for(int b = 0; b < bC; b++){
        if(berries[b][0] == px && berries[b][1] == py){
          map[px][py] = 2;        
        }
      }
      for(int t = 0; t < tC; t++){
        if(trees[t][0] == px && trees[t][1] == py){
          map[px][py] = 3;        
        }
      }
      py--;
      if(px < 0){
        px = 0;
      }
      if(py < 0){
        py = 0;
      }
      if(px > 199){
        px = 199;
      }
      if(py > 199){
        py = 199;
      }
      pFace = 1;
      
    }
    else if(keyCode == 40){
      map[px][py] = 0;
      for(int b = 0; b < bC; b++){
        if(berries[b][0] == px && berries[b][1] == py){
          map[px][py] = 2;        
        }
      }
      for(int t = 0; t < tC; t++){
        if(trees[t][0] == px && trees[t][1] == py){
          map[px][py] = 3;        
        }
      }
      py++;
      if(px < 0){
        px = 0;
      }
      if(py < 0){
        py = 0;
      }
      if(px > 199){
        px = 199;
      }
      if(py > 199){
        py = 199;
      }
      pFace = 3;
      
    }
    
    if(key == 'w' || key == 'W'){pFace = 1;}
    else if(key == 'a' || key == 'A'){pFace = 4;}
    else if(key == 's' || key == 'S'){pFace = 3;}
    else if(key == 'd' || key == 'D'){pFace = 2;}
    
    if(key == ' '){
      int tpx = 0, tpy = 0;
      if(pFace == 1){
        tpx = px; tpy = py-1;
      }
      else if (pFace == 2){
        tpx = px+1; tpy = py;
      }
      else if (pFace == 3){
        tpx = px; tpy = py+1;
      }
      else if(pFace == 4){
        tpx = px-1; tpy = py;
      }
      for(int b = 0; b < bC; b++){
        if(berries[b][0] == tpx && berries[b][1] == tpy && berries[b][2] > 0){
          berries[b][2]--;
          pB++;
          delay(600);
        }
      }
      for(int t = 0; t < tC; t++){
        if(trees[t][0] == tpx && trees[t][1] == tpy && trees[t][2] > 0){
          trees[t][2]--;
          pW++;
          delay(800);
        }
      }
      for(Fire f : fires){
        if(f.posx == tpx && f.posy == tpy){
          f.warmth--;
          warm += 100;
          delay(200);
        }
      }
      for(int w = 0; w < wC; w++){
        if(water[w][0] == tpx && water[w][1] == tpy && water[w][2] > 0){
          water[w][2]--;
          thirst += 400;
          delay(50);
        }
      }
    }
    if((key == 'c' || key == 'C') && pB > 0){
      pB--;
      hung += 50;
      delay(200);
    }
    if((key == 'f' || key == 'F') && pW >= 30){
      int fx = 0; int fy = 0;
      if(pFace == 1){
        fx = px; fy = py-1;
      }
      else if (pFace == 2){
        fx = px+1; fy = py;
      }
      else if (pFace == 3){
        fx = px; fy = py+1;
      }
      else if(pFace == 4){
        fx = px-1; fy = py;
      }
      pW -= 30;
      Fire f = new Fire(fx, fy);
      fires.add(f);
      map[fx][fy] = 4;
    }
    if(key == 'm' || key == 'M'){
      delay(200);
      if(!viewingMap){viewingMap=true;}
    }
  }
  
  for(int w = 0; w < wC; w++){
    if(water[w][0] == px && water[w][1] == py){
      px = ox;
      py = oy;
    }
  }
  
  map[px][py] = 1;
  
  if (hung > 500){ hung = 500; }
  if (warm > 500){ warm = 500; }
  if (thirst > 500){ thirst = 500; }
  if (hung <= 0){ hung = 0; }
  if (warm <= 0){ warm = 0; }
  if (thirst <= 0){ thirst = 0; }
  
  
  if(hp <= 0){ hp = 0; }
  
  renderMap();
  delay(100);
}