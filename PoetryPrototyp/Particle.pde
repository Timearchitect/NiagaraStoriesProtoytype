class Particle implements Cloneable {
  int  size, opacity;
  float x, y, vx, vy, angle;
  color particleColor;
  boolean dead;
  Particle(int _x, int _y, float _vx, float _vy, int _size, int _time, color _particleColor) {
    size=_size;
    particleColor= _particleColor;
    opacity=255;
    x= _x;
    y= _y;
    vx= _vx;
    vy= _vy;
  }

  void update() {
    if (!dead ) { 
      opacity-=2;
      x+=vx;
      y+=vy;
    }
  }

  void display() {
    if (!dead ) {
      fill(particleColor, opacity);
      noStroke();
      ellipse(x, y, size, size);
    }
  }

  public Particle clone()throws CloneNotSupportedException {  
    return (Particle)super.clone();
  }
}


class Pulse extends Particle {
  int  size, maxSize=200, opacity, startTime, time;
  float x, y, vx, vy, angle, w, h;
  color particleColor;
  boolean dead;
  Pulse(int _x, int _y, float _vx, float _vy, float _w,float _h, int _time, color _particleColor) {
    super( _x, _y, _vx, _vy, 0, _time, _particleColor);
    time=_time;
    startTime=_time;
   // size=_size;
    particleColor= _particleColor;
    opacity=255;
    x= _x;
    y= _y;
    w=_w;
    h=_h;
    vx= _vx;
    vy= _vy;
  }

  void update() {
    if (!dead ) { 
      time--;
      if(opacity>0)opacity-=5;
     // size=int((startTime-time)/(time+1));
      x+=vx;
      y+=vy;
    }
  }
  void display() {
    if (!dead ) {
      noFill();
      strokeWeight(int(opacity*0.05));
      stroke(particleColor, opacity);
      rect(x, y, w, h);
    }
  }
}

