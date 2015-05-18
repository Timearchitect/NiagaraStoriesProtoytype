ArrayList<Word> words= new ArrayList<Word>();
ArrayList<Word> orderedWords= new ArrayList<Word>();
ArrayList<Particle> particles= new ArrayList<Particle>();
final int MAX_MOVE=5;
int spawn, alignMode=CENTER, actions, maxAction=5, GrabedIndex=-1, move;
boolean grab, vertical, moveLimit;
PFont font;
float grabOffsetX, grabOffsetY, vx, vy;

//String orderedText;
// version 2
void setup() {
  font=loadFont("Roboto-Bold-18.vlw");
  textFont(font, 18);
  size(displayWidth, displayHeight);
  spawn=int(height-height/5-(height/5*0.5));
  words.add(new Word("test", 100, 100, 40, 40));
  move=MAX_MOVE;
  smooth();
}

void draw() {
  background(100); 
  /*for (Word w : words) {
   w.displayAntiWater();
   }*/
  vy=pmouseY-mouseY;
  vy=constrain(vy, -90, 90);

  mouseHold(); // check hold 
  fill(0);
  strokeWeight(1);
  rectMode(CENTER);
  rect(width/2, height-height/5, width, height/5);

  fill(255);
  textSize(32);
  text("wordTray", width/2, height-height/5);
  //particles.add(new Particle (int(random(width)), 0, 0, 10, 50, 2000, color(255, 255, 255)));
  for (Word w : words) {
    w.display();

    for (Word w2 : words) {
      if (w!=w2 && !w.hold && !w2.hold) {
        w.wordCollision(w2);
      }
    }
  }
  for (Particle p : particles) {
    p.display();
    p.update();
  }
  displayMoves();

  displayOrderdText();
}
void mousePressed()
{
  if (move>0 || !moveLimit) {
    for (int i=words.size ()-1; 0<=i; i--) {
      if (words.size()>0) {
        if ((words.get(i).x-words.get(i).w*0.5)<mouseX && (words.get(i).x+words.get(i).w*0.5)>mouseX) {
          if (!grab &&(words.get(i).y-words.get(i).h*0.5)<mouseY && (words.get(i).y+words.get(i).h*0.5)>mouseY) {
            GrabedIndex=i;
            words.get(GrabedIndex).hold=true;  
            grabOffsetX=words.get(i).x-mouseX;
            grabOffsetY=words.get(i).y-mouseY;
            grab=true;
          }
        }
      }
    }

    if (mouseY>spawn) {
      words.add(new Word( mouseX, mouseY, 40, 40));
      words.get(words.size()-1).hold=true;
      grabOffsetX=words.get(words.size()-1).x-mouseX;
      grabOffsetY=words.get(words.size()-1).y-mouseY;
      grab=true;
    }
  }
}

void mouseHold() {
  if (GrabedIndex!=-1) {
    if (  words.get(GrabedIndex).hold) {   
      words.get(GrabedIndex).x=mouseX+grabOffsetX; 
      words.get(GrabedIndex).y=mouseY+grabOffsetY;
      collision(words.get(GrabedIndex));
      if (grabOffsetX>0) {
        words.get(GrabedIndex).angle=vy;
      } else {
        words.get(GrabedIndex).angle=-vy;
      }
    }
  } else {
    if (words.size()>0) {
      if (  words.get(words.size()-1).hold) {   
        collision(words.get(words.size()-1));
        words.get(words.size()-1).x=mouseX+grabOffsetX; 
        words.get(words.size()-1).y=mouseY+grabOffsetY;
        words.get(words.size()-1).angle=vy;
      }
    }
  }
}
void mouseReleased() {
  if (grab) {
    if (GrabedIndex!=-1) {
      if (mouseY>spawn && grab) {// drops the word on tray
         words.remove(GrabedIndex);
        useMove();
      } else {
        words.get(GrabedIndex).hold=false;  // drops the word
        particles.add(new Pulse(int(words.get(GrabedIndex).x), int(words.get(GrabedIndex).y), 0, 0, words.get(GrabedIndex).w, words.get(GrabedIndex).h, 2000, color(255)));
        if (words.get(GrabedIndex).overlap) {
          //    words.remove(GrabedIndex);
        } else {    
          useMove();
        }
      }
    } else {

      if (mouseY>spawn && grab) {// drops the word on tray
        if (words.size()>0) { 
           words.remove(words.size()-1); 
          useMove();
        }
      } else {
        words.get(words.size()-1).hold=false;  // drops the word
        particles.add(new Pulse(int(   words.get(words.size()-1).x), int(   words.get(words.size()-1).y), 0, 0, words.get(words.size()-1).w, words.get(words.size()-1).h, 2000, color(255)));
        if (words.get(words.size()-1).overlap) {
          //  words.remove(words.size()-1);
        } else {    
          useMove();
        }
      }
    }
    GrabedIndex=-1;
    grab=false;
  }
}

void keyPressed() {
  if (key=='h' || key =='H') {
    vertical=false;
    frame.setSize(displayHeight, displayWidth);
  }

  if (key=='v' || key =='V') {
    vertical=true;
    frame.setSize(displayWidth, displayHeight);
  }

  if (key=='r' || key =='R' ) { // reset move
    move=MAX_MOVE;
    background(255);
  }

  if (key=='s' || key =='S' ) { // reset move
    words.add(new Word( mouseX, mouseY, 40, 40));
  }
  if (key=='l' || key =='L' || key=='m' || key =='M') { // reset move
    moveLimit=(moveLimit?false:true);
  }

  if (key=='o' || key =='O') { // reset move
    for (Word w : words) {
      w.delink();
    }
    orderedWords.clear();
    orderedWords.add( words.get(0));
    words.get(0).link=true;
  }
  if (key=='0' || key ==' ') { // reset move
    words.clear();
    move=MAX_MOVE;
    background(255);
  }
}


void useMove() {
  if (move>0 && moveLimit)move--;
}

void displayMoves() {
  if (moveLimit) {
    fill(255);
    textSize(24);
    text(move +" Moves left", 100, height-height/3);
  }
}

void collision(Word holdW) {
  holdW.overlap=false;
  for (Word w : words) {
    if (holdW!=w) {
      if (holdW.x-holdW.w*0.5 < w.x+w.w*0.5 && holdW.x+holdW.w*0.5 > w.x-w.w*0.5) {
        if (holdW.y-holdW.h*0.5 < w.y+w.h*0.5 && holdW.y+holdW.h*0.5 > w.y-w.h*0.5) {
          holdW.overlap=true;
        }
      }
    }
  }
}

void displayOrderdText(){
  String orderedText="";
 
  for(int i = 0; i<orderedWords.size();i++){
      fill(0,255,0);
     text(i, orderedWords.get(i).x, orderedWords.get(i).y-50);
     orderedText+=" "+orderedWords.get(i).text;
  }
  fill(255);
  textAlign(LEFT);
  text(orderedText, 50, height-300);
  textAlign(CENTER);

}

