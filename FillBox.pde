//int sW = 640;
//int sH = 480;
int buttonSize = 80;
float centerPointX = sW/2;
float centerPointY = sH/2;
boolean doubleClickedGlobal=false;

int numFillBoxButtons = 8;
FillBoxButton[] fillBoxButtons = new FillBoxButton[numFillBoxButtons];
Button goButton;
float[] randomValues = new float[numFillBoxButtons];

void fillBoxSetup() {
  //size(sW,sH);
  goButton = new Button(sW/2, sH/2, buttonSize*0.75, color(0, 200, 0), 16, "GO");
  for (int i=0;i<numFillBoxButtons;i++) {
    fillBoxButtons[i] = new FillBoxButton(0, 0, buttonSize, color(200, 100, 0), 18, ""+randomValues[i]);
    randomValues[i] = 0;
  }
  fillBoxButtons[0].posX = (sW/2)-buttonSize;
  fillBoxButtons[0].posY = (sH/2)-buttonSize;
  fillBoxButtons[1].posX = (sW/2);
  fillBoxButtons[1].posY = (sH/2)-buttonSize;
  fillBoxButtons[2].posX = (sW/2)+buttonSize;
  fillBoxButtons[2].posY = (sH/2)-buttonSize;
  fillBoxButtons[3].posX = (sW/2)-buttonSize;
  fillBoxButtons[3].posY = (sH/2);
  fillBoxButtons[4].posX = (sW/2)+buttonSize;
  fillBoxButtons[4].posY = (sH/2);
  fillBoxButtons[5].posX = (sW/2)-buttonSize;
  fillBoxButtons[5].posY = (sH/2)+buttonSize;
  fillBoxButtons[6].posX = (sW/2);
  fillBoxButtons[6].posY = (sH/2)+buttonSize;
  fillBoxButtons[7].posX = (sW/2)+buttonSize;
  fillBoxButtons[7].posY = (sH/2)+buttonSize;
}

void fillBoxDraw() {
  goButton.update();
  if (goButton.clicked) {
    firstRun=false;
  }
  for (int i=0;i<numFillBoxButtons;i++) {
    fillBoxButtons[i].update();
    randomValues[i] = fillBoxButtons[i].internalRandomValue;
    //println(randomValues);
  }
  odds_Xminus1_YminuX1 = randomValues[0]; // x-1 y-1
  odds_X_Yminus1 = randomValues[1]; // x y-1
  odds_Xplus1_Yminus1 = randomValues[2]; // x+1 y-1
  odds_Xminus1_Y = randomValues[3]; // x-1 y
  odds_Xplus1_Y = randomValues[4]; // x+1 y
  odds_Xminus1_Yplus1 = randomValues[5]; // x-1 y+1
  odds_X_Yplus1 = randomValues[6]; // x y+1
  odds_Xplus1_Yplus1 = randomValues[7]; // x+1 y+1
}

void mousePressed() {
  // mouseEvent variable contains the current event information
  if (mouseEvent.getClickCount()==2) {
    doubleClickedGlobal=true; 
    //println("<double click>");
  }
}

