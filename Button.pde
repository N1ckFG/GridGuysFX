class Button {

    boolean hovered, clicked;
    float posX, posY, sizeXY;
    color offColor, hoverColor, clickColor, nowColor;
    int fontSize;
    PFont font;
    String label;

    Button(float x, float y, float s, color oc, int fs, String d) { 
        hovered=false;
        clicked=false;

        posX = x;
        posY = y;
        sizeXY = s;
        offColor = oc;
        hoverColor = highlight(oc, color(100,0,0));
        clickColor = highlight(oc, color(200,0,0));
        nowColor = oc;
        fontSize=fs;
        font = createFont("Arial", fontSize);
        label = d;
    }

    void update() {
        if (hitDetect(mouseX, mouseY, 0, 0, posX, posY, sizeXY, sizeXY)) {
            if (!mousePressed) {
                hovered = true;
                clicked = false;
            } else if (mousePressed) {
                hovered = true;
                clicked = true;
            }
        } else {
            hovered = false;
            clicked = false;
        }
    }

    void draw() {
        ellipseMode(CENTER);
        noStroke();
        if (hovered && !clicked) {
            nowColor = hoverColor;
        } else if (hovered && clicked) {
            nowColor = clickColor;
        } else if (!hovered && !clicked) {
            nowColor = offColor;
        }
        fill(0, 10);
        ellipse(posX + 2, posY + 2, sizeXY, sizeXY);
        fill(nowColor);
        ellipse(posX, posY, sizeXY, sizeXY);
        fill(0);
        textFont(font, fontSize);
        textAlign(CENTER, CENTER);
        text(label, posX, posY - (fontSize / 4));
    }

    void run() {
        update();
        draw();
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
