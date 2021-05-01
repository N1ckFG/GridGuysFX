//import processing.opengl.*;
//turn renderQuality on for pixel-level processing.  Cool but not realtime.
boolean renderQuality = true;

//---   MAIN CONTROLS   ---
//if you want to avoid chain reactions, try 0, 20, 100, 0.2
int delayCounter = 0;  // delays start of spread
int lifeCounter = 20;  // how long spread lasts
int respawnCounter = 100; // how long until retrigger
float globalChaos = 0.2;  // 0 = min, 1 = max
//-------------------------
int numFrames = 9;
int renderCounterMax = 48;
//----
int width=960;
int height=540;
int fps=24;
int currentFrame = 0;
int renderCounter=0;
PImage[] mapImg = new PImage[numFrames];
PImage[] scaleImg = new PImage[numFrames];
int numColumns, numRows;
float guyWidth, guyHeight, startX, startY;
GridGuy[][] bob;
String setRules="";

void initGlobals() {
  if(renderQuality) {
    numColumns = width;
    numRows = height;
  } 
  else {
    numColumns = width/5;
    numRows = height/5;
  }
  guyWidth = width/numColumns;
  guyHeight = height/numRows;
  bob = new GridGuy[numColumns][numRows];
  startX = guyWidth/2;
  startY = guyHeight/2;
}

void setup() {
  size(50, 50, P2D);

  initGlobals();
  surface.setSize(width, height);

  noCursor();
  frameRate(fps);
  for(int y = 0; y<numRows; y++) {
    for(int x=0; x<numColumns; x++) {
      rulesInit(x,y);
      guysInit(x,y);
    }
  }
  for(int i=0;i<mapImg.length;i++){
    mapImg[i] = loadImage("cellosback_"+(i+1)+".png");
    scaleImg[i] = createImage(numColumns,numRows,RGB);
  }
  background(0);
}

void draw() {
  image(mapImg[currentFrame],0,0,numColumns,numRows);
  scaleImg[currentFrame] = get(0,0,numColumns,numRows);
  //image(scaleImg,0,0,width,height);
  for(int y = 0; y<numRows; y++) {
    for(int x=0; x<numColumns; x++) {
      int loc = x + (y*numColumns);
      if(scaleImg[currentFrame].pixels[loc]!=color(0)) {
        bob[x][y].mainFire();
      }
      rulesHandler(x,y);
      bob[x][y].update();
    }
  }
  if(currentFrame<numFrames-1){
  currentFrame++;
  }
  if(renderQuality){
  if(renderCounter<renderCounterMax){
    saveFrame("render/render####.png");
    println("rendered frame: " + (renderCounter+1) + " / " + renderCounterMax);
    renderCounter++;
  }else{
  exit();
  }
  }
  
}

void keyPressed() {
  resetAll();
}

void rulesHandler(int x, int y) {
  if(bob[x][y].switchArray[0]) {  // NWcorner
  } 
  else if(bob[x][y].switchArray[1]) {  // NEcorner
  } 
  else if(bob[x][y].switchArray[2]) {  // SWcorner
  } 
  else if(bob[x][y].switchArray[3]) {   // SEcorner
  } 
  else if(bob[x][y].switchArray[4]) {  //Nrow
  } 
  else if(bob[x][y].switchArray[5]) {  //Srow
  } 
  else if(bob[x][y].switchArray[6]) {  //Wrow
  } 
  else if(bob[x][y].switchArray[7]) {  //Erow
  } 
  else { // everything else
    if(bob[x][y].clicked) {
      //these are direction probabilities
      bob[x][y+1].kaboom = diceHandler(1, 1);
      bob[x-1][y].kaboom = diceHandler(1, 0.09);
      bob[x][y-1].kaboom = diceHandler(1, 0.2);
      bob[x+1][y].kaboom = diceHandler(1, 0.1);
      bob[x+1][y+1].kaboom = diceHandler(1, 0.5);
      bob[x-1][y-1].kaboom = diceHandler(1, 0.2);
      bob[x+1][y-1].kaboom = diceHandler(1, 0.1);
      bob[x-1][y+1].kaboom = diceHandler(1, 0.5);
    }
  }
}

boolean diceHandler(float v1, float v2) {
  float rollDice;
  rollDice = random(v1);
  if(rollDice<v2) {
    return true;
  }
  else {
    return false;
  }
}

void rulesInit(int x, int y) {
  setRules = "";
  if(x==0&&y==0) {
    setRules="NWcorner";
  } 
  else if(x==numColumns-1&&y==0) {
    setRules="NEcorner";
  } 
  else if(x==0&&y==numRows-1) {
    setRules="SWcorner";
  } 
  else if(x==numColumns-1&&y==numRows-1) {
    setRules="SEcorner";
  } 
  else if(y==0) {
    setRules="Nrow";
  } 
  else if(y==numRows-1) {
    setRules="Srow";
  } 
  else if(x==0) {
    setRules="Wrow";
  } 
  else if(x==numColumns-1) {
    setRules="Erow";
  }
}

void guysInit(int x, int y) {
  bob[x][y] = new GridGuy(startX,startY,guyWidth,guyHeight,setRules,globalChaos,delayCounter,lifeCounter,respawnCounter);
  if(startX<width-guyWidth) {
    startX += guyWidth;
  } 
  else {
    startX = guyWidth/2;
    startY += guyHeight;
  }
}

void resetAll() {
  startX = 0;
  startY = 0;
  currentFrame=0;
  for(int y = 0; y<numRows; y++) {
    for(int x=0; x<numColumns; x++) {
      bob[x][y].hovered = false;
      bob[x][y].clicked = false;
      bob[x][y].kaboom = false;
      bob[x][y].delayCountDown = bob[x][y].delayCountDownOrig;
      bob[x][y].lifeCountDown = bob[x][y].lifeCountDownOrig;
      bob[x][y].respawnCountDown = bob[x][y].respawnCountDownOrig;
      bob[x][y].fillColor = bob[x][y].fillColorOrig;
    }
  }
}


//--  END
