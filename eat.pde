//dimenX = 9, dimenY = 9

int bC = 600;
int hp = 500;
int hung = 500;
int[][] map = new int[200][200];
int[][] berries = new int[bC][3];
int pB = 0; //player's berries
int cellWidth = 112;
int px = 100, py = 100;
int pFace = 4;
boolean invenOpen = false;

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
        strokeWeight(5);
        fill(42, 178, 51);
        rect(scX, scY, cellWidth, cellWidth);
      }
      else if(map[r][c] == 1){
        strokeWeight(10);
        fill(16, 36, 183);
        rect(scX, scY, cellWidth, cellWidth);
        noStroke(); fill(255, 255, 255);
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
    }
  }
  String pos = "(" + str(px) + ", " + str(py) + ")";
  fill(0, 0, 255); textSize(50);
  text(pos, 1008/2 - textWidth(pos)/2, 50); //<>//
  
  fill(191, 0, 149);
  noStroke();
  rect(20, 20, 100, 100);
  fill(255, 255, 255);
  text(str(pB), (50 - textWidth(str(pB))/2) + 20,  90);
  
  fill(255, 0, 0); noStroke();
  rect(50, 933, hp/1.5, 50);
  textSize(24);
  fill(255, 255, 255);
  text("HP", 60, 968);
  
  fill(255, 125, 0);
  rect(625, 933, hung/1.5, 50);
  fill(255, 255, 255);
  text("HUNGER", 635, 965);
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
  for(int r = 0; r < 200; r++){
    for(int c = 0; c < 200; c++){
      if(r == px && c == py){
        map[r][c] = 1;     
      }  
      else if(map[r][c] != 2){
        map[r][c] = 0;
      }
    }
  }
}

void draw(){
  if (hung < 50){
    hp -= 0.9;
  }
  else if (hung < 125){
    hp -= 0.3;
  }
    
  if (hung > 500){ hung = 500; }
  
  if(keyPressed){
    if (keyCode >= 37 && keyCode <= 40){
      hung -= 2;
    }
    else if(key == ' '){
      hung -= 0.5;
    }
    
    if(hung <= 0){
      hung = 0;
    }
    if(keyCode == 37){
      map[px][py] = 0;
      for(int b = 0; b < bC; b++){
        if(berries[b][0] == px && berries[b][1] == py){
          map[px][py] = 2;        
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
      map[px][py] = 1;
    }
    else if(keyCode == 39){
      map[px][py] = 0;
      for(int b = 0; b < bC; b++){
        if(berries[b][0] == px && berries[b][1] == py){
          map[px][py] = 2;        
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
      map[px][py] = 1;
    }
    else if(keyCode == 38){
      map[px][py] = 0;
      for(int b = 0; b < bC; b++){
        if(berries[b][0] == px && berries[b][1] == py){
          map[px][py] = 2;        
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
      map[px][py] = 1;
    }
    else if(keyCode == 40){
      map[px][py] = 0;
      for(int b = 0; b < bC; b++){
        if(berries[b][0] == px && berries[b][1] == py){
          map[px][py] = 2;        
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
      map[px][py] = 1;
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
    }
    if(key == 'c' || key == 'C'){
      pB--;
      hung += 15;
      delay(200);
    }
  }
  renderMap();
  delay(100);
}