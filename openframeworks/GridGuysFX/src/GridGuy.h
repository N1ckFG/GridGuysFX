#pragma once
#include "ofMain.h"

class GridGuy {
    
    public:
        GridGuy(float x, float y, float w, float h, string s, float cc, int dc, int lc, int rc);
        void run();
        void update();
        void mainFire();
        void draw();
        void drawPoint();
        void drawEllipse();
        void drawRect();
        ofColor highlight(ofColor c1, ofColor c2);
        bool hitDetect(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2);
        
        string rulesArray[8] = { "NWcorner", "NEcorner", "SWcorner", "SEcorner", "Nrow", "Srow", "Wrow", "Erow" };
        bool switchArray[8] = { false, false, false, false, false, false, false, false };
        ofColor fillColorArray[8] = { ofColor(255, 0, 0), ofColor(0, 255, 0), ofColor(0, 0, 255), ofColor(255, 0, 255), ofColor(50), ofColor(60), ofColor(70), ofColor(80) };

        bool debugColors, strokeLines, hovered, clicked, kaboom;
        ofColor strokeColor, fillColorOrig, fillColor, hoveredColor, clickedColor;
        float posX, posY, guyWidth, guyHeight, chaos;
        string applyRule;
        int delayCountDownOrig, delayCountDown, lifeCountDownOrig, lifeCountDown, respawnCountDownOrig, respawnCountDown;
        int birthTime, alpha;
    
};
