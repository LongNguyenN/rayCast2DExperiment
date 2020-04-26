
Ball ball;
Ball[] balls;
mouseRay mLine;

void setup() {
  size(500, 500, P2D);
  balls = new Ball[5];
  int ranX = 0;
  int ranY = 0;
  for (int i = 0; i<5; i++) {
    ranX = floor(random(500))-19;
    ranY = floor(random(500))-19;
    balls[i] = new Ball(ranX, ranY, 20);
  }
  mLine = new mouseRay(250, 500, 0, 100);
}

void draw() {
  background(155);
  mouseStuff();
  for(Ball ball: balls) {
    ball.drawBall();
  }
}

void mouseStuff() {
  mLine.updateFinal(mouseX, mouseY);
  mLine.calculateLine();
  mLine.checkCollision(balls);
  mLine.drawLine();
  mLine.drawPerp();
}

class Ball {
  float x, y;
  int r;
  boolean popped;
  Ball(int x, int y, int r) {
    this.x = x;
    this.y = y;
    this.r = r;
    popped = false;
  }
  void drawBall() {
    if(popped) {
      fill(255, 0, 0);
    } else {
      fill(255);
    }
    strokeWeight(1);
    stroke(0);
    ellipse(x, y, r, r);
  }
  void makePop(boolean popped) {
    this.popped = popped;
  }
}

class mouseRay {
  float xi, yi, xf, yf;
  float slope, yIntersept;
  mouseRay(int xi, int yi, int xf, int yf) {
    this.xi = xi;
    this.yi = yi;
    this.xf = xf;
    this.yf = yf;
    this.slope = 0;
    this.yIntersept = 0;
  }
  void calculateLine() {
    slope = (yf-yi)/(xf-xi);
    yIntersept = yi - slope*xi;
  }
  void drawLine() {
    strokeWeight(3);
    stroke(0);
    println(yf);
    if(poppedBall()) {
      line(xi, yi, xf, yf);
    } else {
      line(xi, yi, (-yIntersept)/slope, 0);
    }
  }
  boolean poppedBall() {
    for(Ball ball: balls) {
      if(ball.popped) return true;
    }
    return false;
  }
  void updateOrigin(int xi, int yi) {
    this.xi = xi;
    this.yi = yi;
  }
  void updateFinal(int xf, int yf) {
    this.xf = xf;
    this.yf = yf;
  }
  void checkCollision(Ball[] balls) {
    float xdist, ydist;
    float slopePerp, yInterseptPerp;
    float xIntersect, yIntersect;
    for(Ball ball: balls) {
      slopePerp = -1/slope;
      yInterseptPerp = ball.y-slopePerp*ball.x;
      xIntersect = slope*(yInterseptPerp-yIntersept)/(1+slope*slope);
      yIntersect = slope*slope*(yInterseptPerp-yIntersept)/(1+slope*slope)+yIntersept;
      //x^2+y^2<r
      xdist = Math.abs(ball.x - xIntersect);
      ydist = Math.abs(ball.y - yIntersect);
      if(xdist*xdist+ydist*ydist < ball.r*ball.r/4) {
        ball.popped = true;
        xf = xIntersect;
        yf = yIntersect;
      } else {
        ball.popped = false;
      }
    }
  }
  void drawPerp() {
    float mp = -1/slope; //perpendicular slope
    float bp = balls[2].y-mp*balls[2].x; //perp line (yIntersept) going to ball[2]
    int x1 = 0; //range of perp line from 0
    int x2 = 500; //range of perp lien to 500
    float y1 = mp*x1+bp; //calculate y values for perp line
    float y2 = mp*x2+bp;
    //The intersection of perpline with mouse line
    float xIntersect = slope*(bp-yIntersept)/(1+slope*slope);
    float yIntersect = slope*slope*(bp-yIntersept)/(1+slope*slope)+yIntersept;
    //distance between mouse line and ball[2]
    float xDist = Math.abs(xIntersect - balls[2].x);
    float yDist = Math.abs(yIntersect - balls[2].y);
    //draw an ellipse at intersection of perline and mouse line
    strokeWeight(3);
    stroke(255,0,0);
    line(x1,y1,x2,y2);
    strokeWeight(1);
    stroke(0);
    if(xDist*xDist + yDist*yDist < balls[2].r*balls[2].r) {
      fill(0, 255, 0);
    } else {
      fill(0, 0, 255);
    }
    ellipse(xIntersect, yIntersect, 20, 20);
  }
}
