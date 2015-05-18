class Word  implements Cloneable {
  final float MAX_LINK_ANGLE=90, MIN_LINK_ANGLE=-90; 
  String word[]=split(ord, ',');
  ArrayList<Word> potetialLinkedWords= new ArrayList<Word>();
  Word nextWord;
  // String temaWords[]=split(ord,',');
  // String word[]=ArrayUtils.addAll(wordCommon, temaWords);
  String text=word[int(random(word.length))];
  float vx, vy, x, y, w=20, h=40, cx, cy, angle=random(-10, 10), forceFactor=0.1, linkAngle=MIN_LINK_ANGLE;

  PVector pos, CPos;
  boolean hold, overlap, ordered, link;
  int fontSize=18;
  Word( float x, float y, float w, float h) {
    this.x=x;
    this.y=y;
    this.w=w+text.length()*6.5;
    this.h=h+fontSize*0.5;
  }
  Word(String text, float x, float y, float w, float h) {
    this.text=text;
    this.x=x;
    this.y=y;
    this.w=w+text.length()*6.5;
    this.h=h+fontSize*0.5;
  }



  void display() {
    x+=vx;
    y+=vy;
    vx*=0.5;
    vy*=0.5;
    angle*=0.8;
    if (link)link();
    if (nextWord!= null) {
      stroke(0, 255, 0);
      line(nextWord.x, nextWord.y, x, y);
    }
    strokeWeight(2);
    pushMatrix();
    translate(hold?x+3:x+1, hold?y+3:y+1);
    rotate(radians(angle));
    fill(0);
    rect(0, 0, w, h);
    popMatrix();
    textSize(fontSize);
    pushMatrix();
    translate(hold?x-2:x, hold?y-2:y);
    rotate(radians(angle));
    rectMode(alignMode);
    textMode(alignMode);
    textAlign(alignMode, CENTER);
    stroke(0);
    if (overlap) {
      fill(255, 0, 0);
    } else {
      fill(255);
    }
    rect(0, 0, w, h);
    fill(0);
    text(text, 0+(alignMode==CENTER?0:w*0.5), 0+(alignMode==CENTER?0:h*0.5));
    popMatrix();
  }

  void displayAntiWater() {
    if (!hold) {
      stroke(255);
      strokeWeight(4);
      line(x-w*0.5, y, x-w*0.5, y+1000);
      line(x+w*0.5, y, x+w*0.5, y+1000);
      fill(0);
      rect(x, y+500+Y*0.5, w, 1000);
    }
  }

  void wordCollision(Word word) {
    if (x+w*0.5>word.x-word.w*0.5 && x-w*0.5<word.x+word.w*0.5 && y+h*0.5>word.y-word.h*0.5 && y-h*0.5<word.y+word.h*0.5) {
      word.vx=(word.x-x)*forceFactor;
      word.vy=(word.y-y)*forceFactor;
      vx=(x-word.x)*forceFactor;
      vy=(y-word.y)*forceFactor;
    }
  }
  void link() {

    linkAngle+=10;
    stroke(255);
    line(x+cos(radians(linkAngle))*2000, y+sin(radians(linkAngle))*2000, this.x, this.y);
    for (Word w : words) {
      float bAngle=degrees(atan2((w.y-y), (w.x-x)));
      //text(bAngle, w.x, w.y-40);
      println(bAngle);
      if ( bAngle< linkAngle && bAngle<MAX_LINK_ANGLE &&bAngle>MIN_LINK_ANGLE) {
        if (!potetialLinkedWords.contains(w) && w!=this && !w.ordered)potetialLinkedWords.add(w);
      }
    }
    for (Word pw : potetialLinkedWords) {
      stroke(0, 255, 255);
      line(x, y, pw.x, pw.y);
    }
    if (linkAngle>MAX_LINK_ANGLE) {
      linkAngle=MIN_LINK_ANGLE;
      for (Word pw : potetialLinkedWords) {
        if (  nextWord==null||dist(nextWord.x, nextWord.y, x, y) > dist(pw.x, pw.y, x, y))nextWord=pw;
      }
      if (nextWord!=null) {//
        orderedWords.add(nextWord);
      //  orderedText+=" "+nextWord.text;
      }
      ordered=true; // deactivate
      link=false;
      if (potetialLinkedWords.size()!=0)nextWord.link=true; // exe next order

      potetialLinkedWords.clear();
    }
  }
  void delink() {

    nextWord=null;
    ordered=false;
    link=false;
  }
}

