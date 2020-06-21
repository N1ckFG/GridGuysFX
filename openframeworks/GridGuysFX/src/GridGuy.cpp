#include "GridGuy.h"
    
GridGuy::GridGuy(float x, float y, float w, float h, string s, float cc, int dc, int lc, int rc) {
    birthTime = ofGetElapsedTimeMillis();
    alpha = 255;
    
    debugColors = false;
    strokeLines = false;
    strokeColor = ofColor(0);
    fillColorOrig = ofColor(0);
    fillColor = fillColorOrig;
    
    hoveredColor = ofColor(255, 0, 0);
    clickedColor = ofColor(255, 255, 0);

    hovered = false;
    clicked = false;
    kaboom = false;

    posX = x;
    posY = y;
    guyWidth = w;
    guyHeight = h;
    applyRule = s;

    chaos = abs(1.0 - cc);
    delayCountDownOrig = int(ofRandom(dc * chaos, dc));
    delayCountDown = delayCountDownOrig;
    lifeCountDownOrig = int(ofRandom(lc * chaos, lc));
    lifeCountDown = lifeCountDownOrig;
    respawnCountDownOrig = int(ofRandom(rc * chaos, rc));
    respawnCountDown = respawnCountDownOrig;
    
    for (int i = 0; i < rulesArray.size(); i++) {
        if (applyRule == rulesArray[i]) {
            switchArray[i] = true;
        }
    }

    //strokeLines = true;
}

void GridGuy::run() {
    update();
    draw();
}

void GridGuy::update() {
    if (hitDetect(ofGetMouseX(), ofGetMouseY(), 0, 0, posX, posY, guyWidth, guyHeight)) {
        hovered = true;
        birthTime = ofGetElapsedTimeMillis();
        alpha = 255;
    } else {
        hovered = false;
    }

    if (hovered && ofGetMousePressed()) mainFire();

    if (kaboom) {
        alpha = 255;
        birthTime = ofGetElapsedTimeMillis();
    
        if (delayCountDown>0) {
            delayCountDown--;
        } else {
            kaboom = false;
            clicked = true;
            delayCountDown = delayCountDownOrig;
        }
    }

    if (clicked) {
        if (lifeCountDown > 0) {
            lifeCountDown--;
        } else {
            clicked = false;
        }
    }

    if (lifeCountDown == 0 && respawnCountDown > 0) {
        respawnCountDown--;
    }
    else if (respawnCountDown == 0) {
        lifeCountDown = lifeCountDownOrig;
        respawnCountDown = respawnCountDownOrig;
    }
}

void GridGuy::mainFire() {
    clicked = true;
    kaboom = false;
    delayCountDown = delayCountDownOrig;
    lifeCountDown = lifeCountDownOrig;
    respawnCountDown = respawnCountDownOrig;
}

void GridGuy::draw() {
    fillColor = fillColorOrig;
    //noStroke();

    if (debugColors) {
        for (int i = 0; i < switchArray.size(); i++) {
            if (switchArray[i]) {
                fillColor = fillColorArray[i];
            }
        }
    }

    if (strokeLines) {
        ofSetColor(strokeColor);
    }

    if (hovered && !clicked) {
        fillColor = highlight(fillColor, hoveredColor);
    } else if(clicked) {
        fillColor = highlight(fillColor, clickedColor);
    }

    drawRect();
}

void GridGuy::drawPoint() {
    int alpha = 255 - (ofGetElapsedTimeMillis() - birthTime);
    ofSetColor(fillColor, alpha);
    //strokeWeight(guyWidth);
    ofPoint(posX, posY);
}

void GridGuy::drawEllipse() {
    ofSetColor(fillColor);
    ofDrawEllipse(posX, posY, guyWidth, guyHeight);
}

void GridGuy::drawRect() {
    ofSetColor(fillColor);
    ofDrawRectangle(posX, posY, guyWidth, guyHeight);
}

ofColor GridGuy::highlight(ofColor c1, ofColor c2) {
    return ofColor(c1.r + c2.r, c1.g + c2.g, c1.b + c2.b);
}

bool GridGuy::hitDetect(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) { // float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2
    w1 /= 2;
    h1 /= 2;
    w2 /= 2;
    h2 /= 2;
    return (x1 + w1 >= x2 - w2 && x1 - w1 <= x2 + w2 && y1 + h1 >= y2 - h2 && y1 - h1 <= y2 + h2);
}


