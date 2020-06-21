#pragma once
#include "ofMain.h"

class GridGuy {
    
    public:
        String[] rulesArray = { "NWcorner", "NEcorner", "SWcorner", "SEcorner", "Nrow", "Srow", "Wrow", "Erow" };
        boolean[] switchArray = { false, false, false, false, false, false, false, false };
        color[] fillColorArray = {
          color(255, 0, 0), color(0, 255, 0), color(0, 0, 255), color(255, 0, 255), color(50), color(60), color(70), color(80)
        };
        boolean debugColors, strokeLines, hovered, clicked, kaboom;
        color strokeColor, fillColorOrig, fillColor, hoveredColor, clickedColor;
        float posX, posY, guyWidth, guyHeight, chaos;
        String applyRule;
        int delayCountDownOrig, delayCountDown, lifeCountDownOrig, lifeCountDown, respawnCountDownOrig, respawnCountDown;
        int birthTime, alpha;
    
}
