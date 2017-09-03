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
//   ---   asset vars   ---   
PImage[] facing = new PImage[4];
PImage[] bushes = new PImage[11];
PImage[] waters = new PImage[5];
PImage grass;
PImage tree;
PImage fire;
PImage deadfire;
//   ----------------------   

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

 //<>//
void setup(){
  frameRate(10);
  size(1008, 1008);
  // --------------  load images  ----------------
  facing[0] = loadImage("assets/f1.png");
  facing[1] = loadImage("assets/f2.png");
  facing[2] = loadImage("assets/f3.png");
  facing[3] = loadImage("assets/f4.png");
  grass = loadImage("assets/grass.png");
  bushes[0] = loadImage("assets/b0.png");
  bushes[1] = loadImage("assets/b1.png");
  bushes[2] = loadImage("assets/b2.png");
  bushes[3] = loadImage("assets/b3.png");
  bushes[4] = loadImage("assets/b4.png");
  bushes[5] = loadImage("assets/b5.png");
  bushes[6] = loadImage("assets/b6.png");
  bushes[7] = loadImage("assets/b7.png");
  bushes[8] = loadImage("assets/b8.png");
  bushes[9] = loadImage("assets/b9.png");
  bushes[10] = loadImage("assets/b10.png");
  tree = loadImage("assets/newtree.png");
  waters[0] = loadImage("assets/w0.png");
  waters[1] = loadImage("assets/w1.png");
  waters[2] = loadImage("assets/w2.png");
  waters[3] = loadImage("assets/w3.png");
  waters[4] = loadImage("assets/w4.png");
  fire = loadImage("assets/fire.png");
  deadfire = loadImage("assets/deadfire.png");
  // ----------------------------------------------
  
  //---------- generate berries, trees, water -------------
  
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
    water[w][2] = int(random(3, 11));
    map[wx][wy] = 5;
  }
  
  //---------------------------------------------------
  
  //put player's original position on map
  for(int r = 0; r < 200; r++){
    for(int c = 0; c < 200; c++){
      if(r == px && c == py){
        map[r][c] = 1;     
      }  
    }
  }
}



void draw(){
  //player original position, before changes
  int ox = px, oy = py;
  //run start screen(if start)
  if(!start){
    startScreen();
    return;
  }
  //run end screen(if end)
  if(end){
    endScreen();
    return;
  }
  //if viewing map, show map
  if(viewingMap){
    viewMap();
    if(keyPressed && (key == 'm' || key == 'M')){viewingMap = false; delay(200);}
    delay(100);
    return;
  }
  //if dead
  if(hp <= 0){
    endtime = hour()*3600 + minute()*60 + second();
    end = true;
    delay(100);
  }
  //decrease stats
  warm -= 0.3; hung -= 0.9; thirst -= 1.5;
  //do health decreasing, if thirst/hunger/warmth is below a certain threshold
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
  
  // --------------  check for keypresses  ---------------
  if(keyPressed){
    if (keyCode >= 37 && keyCode <= 40){
      hung -= 1.2;
    }
    else if(key == ' '){
      hung -= 0.2;
    }
    //left key
    if(keyCode == 37){
      map[px][py] = 0;
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
    //right key
    else if(keyCode == 39){
      map[px][py] = 0;
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
    //up key
    else if(keyCode == 38){
      map[px][py] = 0;
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
    //down key
    else if(keyCode == 40){
      map[px][py] = 0;
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
    //if facing keys are pressed
    if(key == 'w' || key == 'W'){pFace = 1;}
    else if(key == 'a' || key == 'A'){pFace = 4;}
    else if(key == 's' || key == 'S'){pFace = 3;}
    else if(key == 'd' || key == 'D'){pFace = 2;}
    //mining key pressed
    if(key == ' '){
      //target square
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
      //check if target square is berries
      }
      for(int b = 0; b < bC; b++){
        if(berries[b][0] == tpx && berries[b][1] == tpy && berries[b][2] > 0){
          berries[b][2]--;
          pB++;
          delay(600);
        }
      }
      //check if target square is trees
      for(int t = 0; t < tC; t++){
        if(trees[t][0] == tpx && trees[t][1] == tpy && trees[t][2] > 0){
          trees[t][2]--;
          pW++;
          delay(800);
        }
      }
      //check if target square is fire
      for(Fire f : fires){
        if(f.posx == tpx && f.posy == tpy && f.warmth > 0){
          f.warmth--;
          warm += 100;
          delay(200);
        }
      }
      //check if target square is water
      for(int w = 0; w < wC; w++){
        if(water[w][0] == tpx && water[w][1] == tpy && water[w][2] > 0){
          water[w][2]--;
          thirst += 400;
          delay(50);
        }
      }
    }
    //check if consuming berries
    if((key == 'c' || key == 'C') && pB > 0){
      pB--;
      hung += 50;
      delay(200);
    }
    //if crafting fire
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
    //if viewing map
    if(key == 'm' || key == 'M'){
      delay(200);
      if(!viewingMap){viewingMap=true;}
    }
  }
  
  // --------------------------------------------------
  
  //if player attempting to walk on water/bushes/trees
  for(int w = 0; w < wC; w++){
    map[water[w][0]][water[w][1]] = 5;
    if(water[w][0] == px && water[w][1] == py){
      px = ox;
      py = oy;
    }
  }
  for(int t = 0; t < tC; t++){
    map[trees[t][0]][trees[t][1]] = 3;
    if(trees[t][0] == px && trees[t][1] == py && trees[t][2] > 0){
      px = ox;
      py = oy;
    }
  }
  for(int b = 0; b < bC; b++){
    map[berries[b][0]][berries[b][1]] = 2;
    if(berries[b][0] == px && berries[b][1] == py){
      px = ox;
      py = oy;
    }
  }
  for (Fire f : fires){
    map[f.posx][f.posy] = 4; 
    if (px == f.posx && py == f.posy){
      f.warmth = 0;
    }
  }
  //set map to player position
  map[px][py] = 1;
  //handle stat limits
  if (hung > 500){ hung = 500; }
  if (warm > 500){ warm = 500; }
  if (thirst > 500){ thirst = 500; }
  if (hung <= 0){ hung = 0; }
  if (warm <= 0){ warm = 0; }
  if (thirst <= 0){ thirst = 0; }
  
  if(hp <= 0){ hp = 0; }
  
  //render map
  renderMap();

}