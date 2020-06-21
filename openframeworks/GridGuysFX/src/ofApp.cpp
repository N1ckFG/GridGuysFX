#include "ofApp.h"

void ofApp::keyPressed(int key){
  resetAll();
}

void ofApp::initGlobals() {
  numColumns = sW / pixelSize;
  numRows = sH / pixelSize;

  guyWidth = sW / numColumns;
  guyHeight = sH / numRows;

  startX = guyWidth / 2;
  startY = guyHeight / 2;

  // make mainGrid a 2D array
  mainGrid = new GridGuy[numColumns][numRows];
}

void ofApp::rulesHandler(int x, int y) {
  bool[] sw = mainGrid[x][y].switchArray;
  if (sw[0] || sw[1] || sw[2] || sw[3] || sw[4] || sw[5] || sw[6] || sw[7]) return;

  if (mainGrid[x][y].clicked) {
    //these are direction probabilities
    mainGrid[x][y + 1].kaboom = diceHandler(1, odds_X_Yplus1);
    mainGrid[x - 1][y].kaboom = diceHandler(1, odds_Xminus1_Y);
    mainGrid[x][y - 1].kaboom = diceHandler(1, odds_X_Yminus1);
    mainGrid[x + 1][y].kaboom = diceHandler(1, odds_Xplus1_Y);
    mainGrid[x + 1][y + 1].kaboom = diceHandler(1, odds_Xplus1_Yplus1);
    mainGrid[x - 1][y - 1].kaboom = diceHandler(1, odds_Xminus1_YminuX1);
    mainGrid[x + 1][y - 1].kaboom = diceHandler(1, odds_Xplus1_Yminus1);
    mainGrid[x - 1][y + 1].kaboom = diceHandler(1, odds_Xminus1_Yplus1);
  }
}

bool ofApp::diceHandler(float v1, float v2) {
  float rollDice = random(v1);
  if (rollDice < v2) {
    return true;
  } else {
    return false;
  }
}

void ofApp::rulesInit(int x, int y) {
  setRules = "";
  if (x == 0 && y == 0) {
    setRules = "NWcorner";
  } else if (x == numColumns - 1 && y == 0) {
    setRules = "NEcorner";
  } else if (x == 0 && y == numRows - 1) {
    setRules = "SWcorner";
  } else if (x == numColumns - 1 && y == numRows - 1) {
    setRules = "SEcorner";
  } else if (y == 0) {
    setRules = "Nrow";
  } else if (y == numRows - 1) {
    setRules = "Srow";
  } else if (x == 0) {
    setRules = "Wrow";
  } else if (x == numColumns - 1) {
    setRules = "Erow";
  }
}

void ofApp::guysInit(int x, int y) {
  mainGrid[x][y] = new GridGuy(startX, startY, guyWidth, guyHeight, setRules, globalChaos, delayCounter, lifeCounter, respawnCounter);
  if (startX < width - guyWidth) {
    startX += guyWidth;
  } else {
    startX = guyWidth / 2;
    startY += guyHeight;
  }
  println("init " + x + " " + y);
}

void ofApp::resetAll() {
  startX = 0;
  startY = 0;
  //currentFrame = 0;
  for (int y = 0; y < numRows; y++) {
    for (int x = 0; x < numColumns; x++) {
      mainGrid[x][y].hovered = false;
      mainGrid[x][y].clicked = false;
      mainGrid[x][y].kaboom = false;
      mainGrid[x][y].delayCountDown = mainGrid[x][y].delayCountDownOrig;
      mainGrid[x][y].lifeCountDown = mainGrid[x][y].lifeCountDownOrig;
      mainGrid[x][y].respawnCountDown = mainGrid[x][y].respawnCountDownOrig;
      mainGrid[x][y].fillColor = mainGrid[x][y].fillColorOrig;
    }
  }
  
  pixelOddsSetup();
}

// ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

void ofApp::pixelOddsSetup() {
  // temp
  for (int i = 0; i < randomValues.length; i++) {
    randomValues[i] = random(1);
  }

  choose = int(random(maxChoices));
  println("choose: " + choose);
  
  switch (choose) {
  case 0:
    // 0. CROSS | OK
    //delayCounter = 4;
    odds_Xminus1_YminuX1 = 0;//randomValues[0]; // x-1 y-1
    odds_X_Yminus1 = 0.5;//randomValues[1]; // x y-1
    odds_Xplus1_Yminus1 = 0;//randomValues[2]; // x+1 y-1
    odds_Xminus1_Y = 0.5;//randomValues[3]; // x-1 y
    odds_Xplus1_Y = 0.5;//randomValues[4]; // x+1 y
    odds_Xminus1_Yplus1 = 0;//randomValues[5]; // x-1 y+1
    odds_X_Yplus1 = 0.5;//randomValues[6]; // x y+1
    odds_Xplus1_Yplus1 = 0;//randomValues[7]; // x+1 y+1
    break;
  case 1:
    // 1. WOT | ?
    //delayCounter = 4;
    odds_Xminus1_YminuX1 = randomValues[0]; // x-1 y-1
    odds_X_Yminus1 = 1;//randomValues[1]; // x y-1
    odds_Xplus1_Yminus1 = 1;//randomValues[2]; // x+1 y-1
    odds_Xminus1_Y = randomValues[3]; // x-1 y
    odds_Xplus1_Y = 0;//randomValues[4]; // x+1 y
    odds_Xminus1_Yplus1 = 1;//randomValues[5]; // x-1 y+1
    odds_X_Yplus1 = 0;//randomValues[6]; // x y+1
    odds_Xplus1_Yplus1 = randomValues[7]; // x+1 y+1
    break;
  case 2:
    // 2. OCEAN | OK
    //delayCounter = 4;
    odds_Xminus1_YminuX1 = 0;//randomValues[0]; // x-1 y-1
    odds_X_Yminus1 = 0;//randomValues[1]; // x y-1
    odds_Xplus1_Yminus1 = 0.1 * randomValues[2]; // x+1 y-1
    odds_Xminus1_Y = randomValues[3]; // x-1 y
    odds_Xplus1_Y = randomValues[4]; // x+1 y
    odds_Xminus1_Yplus1 = 0.1 * randomValues[5]; // x-1 y+1
    odds_X_Yplus1 = 0;//randomValues[6]; // x y+1
    odds_Xplus1_Yplus1 = 0;//randomValues[7]; // x+1 y+1
    break;
  case 3:
    // 3. MOUNTAINS
    //delayCounter = 4;
    odds_Xminus1_YminuX1 = 0;//randomValues[0]; // x-1 y-1
    odds_X_Yminus1 = 0.1;//randomValues[1]; // x y-1
    odds_Xplus1_Yminus1 = 0;//randomValues[2]; // x+1 y-1
    odds_Xminus1_Y = 0;//randomValues[3]; // x-1 y
    odds_Xplus1_Y = 0;//randomValues[4]; // x+1 y
    odds_Xminus1_Yplus1 = randomValues[5]; // x-1 y+1
    odds_X_Yplus1 = 0.5;//randomValues[6]; // x y+1
    odds_Xplus1_Yplus1 = randomValues[7]; // x+1 y+1
    break;
  case 4:
    // 4. DROPS
    //delayCounter = 4;
    odds_Xminus1_YminuX1 = 0;//randomValues[0]; // x-1 y-1
    odds_X_Yminus1 = 0;//randomValues[1]; // x y-1
    odds_Xplus1_Yminus1 = 0;//randomValues[2]; // x+1 y-1
    odds_Xminus1_Y = 0;//randomValues[3]; // x-1 y
    odds_Xplus1_Y = 0;//randomValues[4]; // x+1 y
    odds_Xminus1_Yplus1 = 0.1 * randomValues[5]; // x-1 y+1
    odds_X_Yplus1 = 1;//randomValues[6]; // x y+1
    odds_Xplus1_Yplus1 = 0.1 * randomValues[7]; // x+1 y+1
    break;
  case 5:
    // 5. DROPS_REVERSE
    //delayCounter = 4;
    odds_Xminus1_YminuX1 = 0.1 * randomValues[0]; // x-1 y-1
    odds_X_Yminus1 = 1;//randomValues[1]; // x y-1
    odds_Xplus1_Yminus1 = 0.1 * randomValues[2]; // x+1 y-1
    odds_Xminus1_Y = 0;//randomValues[3]; // x-1 y
    odds_Xplus1_Y = 0;//randomValues[4]; // x+1 y
    odds_Xminus1_Yplus1 = 0; //randomValues[5]; // x-1 y+1
    odds_X_Yplus1 = 0;//randomValues[6]; // x y+1
    odds_Xplus1_Yplus1 = 0; //randomValues[7]; // x+1 y+1
    break;
  case 6:
    // 6. ALL RANDOM
    //delayCounter = 4;
    odds_Xminus1_YminuX1 = randomValues[0]; // x-1 y-1
    odds_X_Yminus1 = randomValues[1]; // x y-1
    odds_Xplus1_Yminus1 = randomValues[2]; // x+1 y-1
    odds_Xminus1_Y = randomValues[3]; // x-1 y
    odds_Xplus1_Y = randomValues[4]; // x+1 y
    odds_Xminus1_Yplus1 = randomValues[5]; // x-1 y+1
    odds_X_Yplus1 = randomValues[6]; // x y+1
    odds_Xplus1_Yplus1 = randomValues[7]; // x+1 y+1
    break;
  }
}

// ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

void ofApp::setup() {
  size(50, 50, P2D);
  surface.setSize(sW, sH);
  frameRate(fps);

  pixelOddsSetup();
  initGlobals();
  
  for (int y = 0; y < numRows; y++) {
    for (int x = 0; x < numColumns; x++) {
      rulesInit(x, y);
      guysInit(x, y);
    }
  }
}

void ofApp::update() {

}

void ofApp::draw() {
  background(0);

  for (int y = 0; y < numRows; y++) {
    for (int x = 0; x < numColumns; x++) {
      int loc = x + (y * numColumns);

      rulesHandler(x, y);
      mainGrid[x][y].run();
    }
  }
  
  surface.setTitle("" + frameRate);
}
