//---     MAIN CONTROLS     ---
boolean firstRun = false;

//if you want to avoid chain reactions, try 0, 20, 100, 0.2
int delayCounter = 0;    // delays start of spread
int lifeCounter = 20;    // how long spread lasts
int respawnCounter = 50; // how long until retrigger
float globalChaos = 0.3;    // 0 = min, 1 = max
//-------------------------
int choose = 0;
int maxChoices = 7;
int numFrames = 50;
int renderCounterMax = 1000;
//----
int lowQualityReduceBy = 6; //5;
int sW = 140 * lowQualityReduceBy;
int sH = 42 * lowQualityReduceBy;
int fps = 60; //24;
int currentFrame = 0;
int renderCounter = 0;
int numColumns, numRows;
float guyWidth, guyHeight, startX, startY;
GridGuy[][] mainGrid;
String setRules = "";
float odds_X_Yplus1, odds_Xminus1_Y, odds_X_Yminus1, odds_Xplus1_Y, odds_Xplus1_Yplus1, odds_Xminus1_YminuX1, odds_Xplus1_Yminus1, odds_Xminus1_Yplus1;

void initGlobals() {
    numColumns = sW / lowQualityReduceBy;
    numRows = sH / lowQualityReduceBy;

    guyWidth = sW / numColumns;
    guyHeight = sH / numRows;

    startX = guyWidth / 2;
    startY = guyHeight / 2;

    // make mainGrid a 2D array
    mainGrid = new GridGuy[numColumns][numRows];
}

void keyPressed() {
    resetAll();
}

void rulesHandler(int x, int y) {
    if (mainGrid[x][y].switchArray[0]) {    // NWcorner
      //
    } else if (mainGrid[x][y].switchArray[1]) {    // NEcorner
      //
    } else if (mainGrid[x][y].switchArray[2]) {    // SWcorner
      //
    } else if (mainGrid[x][y].switchArray[3]) {     // SEcorner
      //
    } else if (mainGrid[x][y].switchArray[4]) {    //Nrow
      //
    } else if (mainGrid[x][y].switchArray[5]) {    //Srow
      //
    } else if (mainGrid[x][y].switchArray[6]) {    //Wrow
      //
    } else if (mainGrid[x][y].switchArray[7]) {    //Erow
      //
    } else { // everything else
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
}

boolean diceHandler(float v1, float v2) { 
    float rollDice = random(v1);
    if (rollDice < v2) {
        return true;
    } else {
        return false;
    }
}

void rulesInit(int x, int y) {
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

void guysInit(int x, int y) { 
    mainGrid[x][y] = new GridGuy(startX, startY, guyWidth, guyHeight, setRules, globalChaos, delayCounter, lifeCounter, respawnCounter);
    if (startX < width - guyWidth) {
        startX += guyWidth;
    } else {
        startX = guyWidth / 2;
        startY += guyHeight;
    }
    println("init " + x + " " + y);
}

void resetAll() {
    startX = 0;
    startY = 0;
    currentFrame = 0;
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
}

// ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

int buttonSize = 80;
float centerPointX = sW / 2;
float centerPointY = sH / 2;
boolean doubleClickedGlobal = false;

float[] randomValues = new float[8];

void fillBoxSetup() {
    // temp
    for (int i = 0; i < randomValues.length; i++) {
      randomValues[i] = random(1);
    }

    choose = int(random(maxChoices));
    println("choose: " + choose);
    
    if (choose == 0) { 
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
    } else if (choose == 1) { 
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
    } else if (choose == 1) { 
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
    } else if (choose == 2) { 
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
    } else if (choose == 3) { 
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
    } else if (choose == 4) { 
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
    } else {
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
    }
}

// ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~

void setup() {
    size(50, 50, P2D);
    surface.setSize(sW, sH);
    fillBoxSetup();
    initGlobals();
    
    for (int y = 0; y < numRows; y++) {
        for (int x = 0; x < numColumns; x++) {
            rulesInit(x, y);
            guysInit(x, y);
        }
    }
}


void draw() {
    background(0);
    if (firstRun) {
        //
    } else {
        for (int y = 0; y < numRows; y++) {
            for (int x = 0; x < numColumns; x++) {
                int loc = x + (y * numColumns);

                rulesHandler(x, y);
                mainGrid[x][y].run();
            }
        }
    }
}

//--    END
