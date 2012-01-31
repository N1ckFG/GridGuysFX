
class GridGuy {
  boolean debugColors = false;
  boolean strokeLines = false;

  float posX, posY, guyWidth, guyHeight;
  String applyRule;
  String[] rulesArray = { 
    "NWcorner","NEcorner","SWcorner","SEcorner","Nrow","Srow","Wrow","Erow"
  };
  boolean[] switchArray = { 
    false,false,false,false,false,false,false,false
  };
  color strokeColor = color(0);
  color fillColorOrig = color(0);
  color fillColor = fillColorOrig;
  color[] fillColorArray = { 
    color(255,0,0),color(0,255,0),color(0,0,255),color(255,0,255),color(50),color(60),color(70),color(80)
  };
  color hoveredColor = color(255,0,0);
  color clickedColor = color(255,255,0);

  boolean hovered = false;
  boolean clicked = false;
  boolean kaboom = false;

  int delayCountDownOrig, delayCountDown, lifeCountDownOrig, lifeCountDown, respawnCountDownOrig, respawnCountDown;
  float chaos;

  GridGuy(float x, float y, float w, float h, String s, float cc, int dc, int lc, int rc) {
    posX = x;
    posY = y;
    guyWidth = w;
    guyHeight = h;
    applyRule = s;
    chaos = abs(1.0-cc);
    delayCountDownOrig = int(random(dc*chaos,dc));
    delayCountDown = delayCountDownOrig;
    lifeCountDownOrig = int(random(lc*chaos,lc));
    lifeCountDown = lifeCountDownOrig;
    respawnCountDownOrig = int(random(rc*chaos,rc));
    respawnCountDown = respawnCountDownOrig;
    for(int i=0;i<rulesArray.length;i++) {
      if(applyRule==rulesArray[i]) {
        switchArray[i]=true;
      }
    }
    if(renderHighQuality) {
      strokeLines=false;
    } 
    else {
      strokeLines=true;
    }
  }

  void update() {
    behaviors();
    drawGridGuy();
  }

  void behaviors() {
    if(hitDetect(mouseX,mouseY,0,0,posX,posY,guyWidth,guyHeight)) {
      hovered = true;
    } 
    else {
      hovered = false;
    }

    if(hovered&&mousePressed) {
      mainFire();
    } 
    else {
      //clicked = false;
    }
    if(kaboom) {
      if(delayCountDown>0) {
        delayCountDown--;
      }
      else {
        kaboom=false;
        clicked=true;
        delayCountDown=delayCountDownOrig;
      }
    }
    if(clicked) {
      if(lifeCountDown>0) {
        lifeCountDown--;
      }
      else {
        clicked=false;
      }
    }

    if(lifeCountDown==0&&respawnCountDown>0) {
      respawnCountDown--;
    } 
    else if(respawnCountDown==0) {
      lifeCountDown=lifeCountDownOrig;
      respawnCountDown=respawnCountDownOrig;
    }
  }

  void mainFire() {
    clicked = true;
    kaboom = false;
    delayCountDown=delayCountDownOrig;
    lifeCountDown=lifeCountDownOrig;
    respawnCountDown=respawnCountDownOrig;
  }

  void drawGridGuy() {
    fillColor = fillColorOrig;
    noStroke();

    if(debugColors) {
      for(int i=0;i<switchArray.length;i++) {
        if(switchArray[i]) {
          fillColor = fillColorArray[i];
        }
      }
    }
    if(strokeLines) {
      stroke(strokeColor);
    }

    if(hovered&&!clicked) {
      if(!renderHighQuality) {
        fillColor = blendColor(fillColor,hoveredColor,ADD);
      }
    }
    else if(clicked) {
      fillColor = blendColor(fillColor,clickedColor,ADD);
    }

    // note: points go faster with OpenGL, rects with P2D
    if(renderHighQuality) {
      drawPoint();
    } 
    else {
      drawRect();
    }
  }

  void drawPoint() {
    stroke(fillColor);
    strokeWeight(5);
    point(posX,posY);
  }

  void drawRect() {
    fill(fillColor);
    rectMode(CENTER);
    rect(posX, posY, guyWidth,guyHeight);
  }


  boolean hitDetect(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) {
    w1 /= 2;
    h1 /= 2;
    w2 /= 2;
    h2 /= 2;
    if(x1 + w1 >= x2 - w2 && x1 - w1 <= x2 + w2 && y1 + h1 >= y2 - h2 && y1 - h1 <= y2 + h2) {
      return true;
    } 
    else {
      return false;
    }
  }
}

