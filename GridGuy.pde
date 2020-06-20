class GridGuy {

    String[] rulesArray = { "NWcorner", "NEcorner", "SWcorner", "SEcorner", "Nrow", "Srow", "Wrow", "Erow" };;
    boolean[] switchArray = { false, false, false, false, false, false, false, false };
    color[] fillColorArray = {          
        color(255, 0, 0), color(0, 255, 0), color(0, 0, 255), color(255, 0, 255), color(50), color(60), color(70), color(80)
    };
    boolean debugColors, strokeLines, hovered, clicked, kaboom;
    color strokeColor, fillColorOrig, fillColor, hoveredColor, clickedColor;
    float posX, posY, guyWidth, guyHeight, chaos;
    String applyRule;
    int delayCountDownOrig, delayCountDown, lifeCountDownOrig, lifeCountDown, respawnCountDownOrig, respawnCountDown;

    GridGuy(float x, float y, float w, float h, String s, float cc, int dc, int lc, int rc) {
        debugColors = false;
        strokeLines = false;
        strokeColor = color(0);
        fillColorOrig = color(0);
        fillColor = fillColorOrig;
        
        hoveredColor = color(255, 0, 0);
        clickedColor = color(255, 255, 0);

        hovered = false;
        clicked = false;
        kaboom = false;

        posX = x;
        posY = y;
        guyWidth = w;
        guyHeight = h;
        applyRule = s;

        chaos = abs(1.0 - cc);
        delayCountDownOrig = int(random(dc * chaos, dc));
        delayCountDown = delayCountDownOrig;
        lifeCountDownOrig = int(random(lc * chaos, lc));
        lifeCountDown = lifeCountDownOrig;
        respawnCountDownOrig = int(random(rc * chaos, rc));
        respawnCountDown = respawnCountDownOrig;
        
        for (int i = 0; i < rulesArray.length; i++) {
            if (applyRule == rulesArray[i]) {
                switchArray[i] = true;
            }
        }

        strokeLines = true;
    }

    void run() {
        update();
        draw();
    }

    void update() {
        if (hitDetect(mouseX, mouseY, 0, 0, posX, posY, guyWidth, guyHeight)) {
            hovered = true;
        } else {
            hovered = false;
        }

        if (hovered && mousePressed) {
            mainFire();
        } else {
            //clicked = false;
        }

        if (kaboom) {
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

    void mainFire() {
        clicked = true;
        kaboom = false;
        delayCountDown = delayCountDownOrig;
        lifeCountDown = lifeCountDownOrig;
        respawnCountDown = respawnCountDownOrig;
    }

    void draw() {
        fillColor = fillColorOrig;
        noStroke();

        if (debugColors) {
            for (int i = 0; i < switchArray.length; i++) {
                if (switchArray[i]) {
                    fillColor = fillColorArray[i];
                }
            }
        }

        if (strokeLines) {
            stroke(strokeColor);
        }

        if (hovered && !clicked) {
            fillColor = highlight(fillColor, hoveredColor);
        } else if(clicked) {
            fillColor = highlight(fillColor, clickedColor);
        }

        drawRect();
    }

    void drawPoint() {
        stroke(fillColor);
        strokeWeight(5);
        point(posX, posY);
    }

    void drawRect() {
        fill(fillColor);
        rectMode(CENTER);
        rect(posX, posY, guyWidth, guyHeight);
    }

    color highlight(color c1, color c2) {
        return color(red(c1) + red(c2), green(c1) + green(c2), blue(c1) + blue(c2));
    }

    boolean hitDetect(float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2) { // float x1, float y1, float w1, float h1, float x2, float y2, float w2, float h2
        w1 /= 2;
        h1 /= 2;
        w2 /= 2;
        h2 /= 2; 
        if (x1 + w1 >= x2 - w2 && x1 - w1 <= x2 + w2 && y1 + h1 >= y2 - h2 && y1 - h1 <= y2 + h2) {
            return true;
        } else {
            return false;
        }
    }

}
