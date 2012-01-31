class FillBoxButton {
  float internalRandomValue = 0;
  float posX, posY, sizeXY;
  color offColor, hoverColor, clickColor, nowColor;
  PFont font;
  String label;
  int fontSize;
  boolean hovered=false;
  boolean clicked=false;
  boolean maxmin=false;
  float degLocal;
  
  color gaugeMaxColor = color(0,255,0);
  color gaugeMinColor = color(255,0,0);
  color gaugeFreeColor = color(0,0,255);
  color gaugeNowColor=gaugeFreeColor;

  FillBoxButton(float x, float y, float s, color oc, int fs, String d) {
    posX = x;
    posY = y;
    sizeXY = s;
    offColor = oc;
    hoverColor = blendColor(offColor, color(40), ADD);
    clickColor = blendColor(offColor, color(120), ADD);
    nowColor = offColor;
    fontSize=fs;
    font = createFont("Arial", fontSize);
    label = d;
  }

  void update() {
    checkButton();
    drawButton();
  }

  void checkButton() {
    float kSize = 10;
    if (hitDetect(mouseX, mouseY, 0, 0, posX, posY, sizeXY, sizeXY)) {
      if (!mousePressed) {
        hovered=true;
        clicked=false;
      } 
      else if (mousePressed) {
        hovered=true;
        clicked=true;
      }
      /*
    } 
       else if (hitDetect(x[1], y[1], kSize, kSize, posX, posY, sizeXY, sizeXY)||hitDetect(x[4], y[4], kSize, kSize, posX, posY, sizeXY, sizeXY)) {
       hovered=true;
       clicked=false;
       } 
       else if (hitDetect(x[0], y[0], kSize, kSize, posX, posY, sizeXY, sizeXY)&&hitDetect(x[4], y[4], kSize, kSize, posX, posY, sizeXY, sizeXY)) {
       hovered=true;
       clicked=true;
       */
    } 
    else {
      hovered=false;
      clicked=false;
    }
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    if (clicked&&!maxmin) {
      internalRandomValue = abs(mouseY-(posY+(sizeXY/2)))/sizeXY;
      label = ""+roundToPlaces(internalRandomValue, 2);
    }

    if (hovered&&doubleClickedGlobal) {
      doubleClickedGlobal=false;
      if (!maxmin) {
      gaugeNowColor=gaugeMaxColor;
        internalRandomValue=1;
        maxmin=true;
      }else if(maxmin && internalRandomValue==1){
      gaugeNowColor=gaugeMinColor;
      internalRandomValue=0;
      }else if(maxmin && internalRandomValue==0){
      gaugeNowColor=gaugeFreeColor;
      maxmin=false;
      }
      label = ""+roundToPlaces(internalRandomValue, 2);
    }
  }

  void drawButton() {
    rectMode(CENTER);
    noStroke();
    if(!maxmin){
    if (hovered&&!clicked) {
      nowColor = hoverColor;
    }
    else if (hovered&&clicked) {
      nowColor = clickColor;
    }
    else if (!hovered&&!clicked) {
      nowColor = offColor;
    }
    }else{
    nowColor=gaugeNowColor;
    }
    fill(0, 10);
    rect(posX+2, posY+2, sizeXY, sizeXY);
    fill(nowColor);
    rect(posX, posY, sizeXY, sizeXY);
    //~~~~~~~~
    fill(gaugeNowColor);
    rect(posX, posY+(sizeXY/2)-((internalRandomValue*sizeXY)/2), sizeXY, internalRandomValue*sizeXY);
    //~~~~~~~~
    fill(0);
    textFont(font, fontSize);
    textAlign(CENTER, CENTER);
    text(label, posX, posY-(fontSize/4));
  }

  boolean hitDetect(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) {
    w1 /= 2;
    h1 /= 2;
    w2 /= 2;
    h2 /= 2; 
    if (x1 + w1 >= x2 - w2 && x1 - w1 <= x2 + w2 && y1 + h1 >= y2 - h2 && y1 - h1 <= y2 + h2) {
      return true;
    } 
    else {
      return false;
    }
  }

  float roundToPlaces(float f1, int p) {
    float f2 = f1 * pow(10, p);
    f2 = round(f2);
    f2 /= pow(10, p);
    println(f2 + " " + f1);
    return f2;
  }
}

