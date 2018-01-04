ArrayList<Lines> vectorField = new ArrayList<Lines>();
ArrayList<Interaction> interactionField = new ArrayList<Interaction>();
int lineSize = 25;

// emulateMouse
boolean emulate = false;
boolean mousePressedBool = false;
float emulateMouseX;
float emulateMouseY;
float pemulateMouseX;
float pemulateMouseY;

void setup() {
  size(800,800);
  background(255);
  for (int i = 0; i < width/lineSize; i++) {
    for (int j = 0; j < height/lineSize; j++) {
      Lines l = new Lines(i*lineSize,j*lineSize);
      vectorField.add(l);
    }
  }
  for (Lines l : vectorField) {
    for (Lines k : vectorField) {
      if (l.ax <= k.ax + lineSize && l.ax >= k.ax - lineSize && 
          l.ay <= k.ay + lineSize && l.ay >= k.ay - lineSize) {
            Interaction a = new Interaction(l,k);    
            interactionField.add(a);
          }
    }
  }
}

void draw() {
  stroke(255);
  background(255);
  emulateMouse();
  for (Lines l : vectorField) {
    l.update();
    l.display();
  }
  for (Interaction I : interactionField) {
    I.update();
  }
  saveFrame("interaction_sticks_white-####.png");
}

class Lines {
  float ax,ay,bx,by;
  float arot, arotspeed;
  color colorStroke = 255;
  float viscosity = 0.03;
  float speedCoeff = 0.3;
  
  Lines(float x1, float y1) {
    ax = x1;
    ay = y1;
  }
  
  void update() {
    
    if (mousePressedBool) {
      if (emulateMouseX < ax + lineSize/2 && emulateMouseX > ax - lineSize/2 && 
          emulateMouseY < ay + lineSize/2 && emulateMouseY > ay - lineSize/2) {        
          arotspeed = speedCoeff*(abs(emulateMouseX - pemulateMouseX) + 
          abs(emulateMouseY - pemulateMouseY));
      }
    }
    arotspeed -= arotspeed*viscosity;
    arot += arotspeed;
  }
  
  void display() {
    stroke(colorStroke);
    strokeWeight(5);
    pushMatrix();
    translate(ax,ay);
    rotate(arot);
    line(-lineSize/2,0,lineSize/2,0);
    popMatrix();
  }
}

void mousePressed() {
  for (Lines l : vectorField) {
    
  }
}

class Interaction {
  Lines l1;
  Lines l2;
  float IntCoeff = 0.2;
  float maxNoInteraction = 0.05;
  
  Interaction(Lines Line1, Lines Line2) {
    l1 = Line1;
    l2 = Line2;
  }
  
  void update() {
    if ((l1.arot - l2.arot) > maxNoInteraction) {
      l1.arot += IntCoeff*(l2.arot - l1.arot);
      l2.arot += IntCoeff*(l1.arot - l2.arot);
      float colorIntens = map(abs(l2.arot - l1.arot), 0, PI, 255, 0);
      l1.colorStroke = color(255,colorIntens,colorIntens);
      l2.colorStroke = l1.colorStroke;
    }
  }
}

void emulateMouse() {
  if (emulate) {
    mouseSpiral();
  } else {
    emulateMouseX = mouseX;
    emulateMouseY = mouseY;
    pemulateMouseX = pmouseX;
    pemulateMouseY = pmouseY;
  }
  if (emulate) {
    if (keyPressed) {
      if (key == ' ') {
        mousePressedBool = true;
        }
      } else {
      mousePressedBool = false;
      }
  } else {
    if (mousePressed) {
      mousePressedBool = true;
    } else {
      mousePressedBool = false;
    }
  }
}

void mouseSpiral() {
  long timer = millis();
  float speed = 0.005;
  pemulateMouseX = emulateMouseX;
  pemulateMouseY = emulateMouseY;
  emulateMouseX = width/2 + width/3*sin(timer*speed)*(1 + 0.1*sin(timer*speed*0.65));
  emulateMouseY = height/2 + height/3*cos(timer*speed);
}