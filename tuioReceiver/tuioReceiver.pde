
import TUIO.*;
import java.util.*;
TuioProcessing tuioClient;


//////
int w=600;
int h=600;
int alfa=5;
color base=color(200, 150, 150, alfa);
float xoff=0.0;
float yoff=0.0;
int ellipseW=8;
int ellipseH=8;
color init=color(180, 100, 100);
color end=color(140, 90, 180);
int X_AXIS=1;
int Y_AXIS=2;




// these are some helper variables which are used
// to create scalable graphical feedback
float cursor_size = 15;
float object_size = 60;
float table_size = 760;
float scale_factor = 1;
PFont font;

void setup()
{
  size(w, h);
  noStroke();
  fill(0);

  loop();
  frameRate(30);
  //noLoop();

  hint(ENABLE_NATIVE_FONTS);
  font = createFont("Arial", 18);
  scale_factor = height/table_size;

  // we create an instance of the TuioProcessing client
  // since we add "this" class as an argument the TuioProcessing class expects
  // an implementation of the TUIO callback methods (see below)
  tuioClient  = new TuioProcessing(this);
  setGradient(0, 0, width, height, init, end, Y_AXIS );
}

// within the draw method we retrieve a Vector (List) of TuioObject and TuioCursor (polling)
// from the TuioProcessing client and then loop over both lists to draw the graphical feedback.
void draw()
{
  textFont(font, 18*scale_factor);
  float obj_size = object_size*scale_factor; 
  float cur_size = cursor_size*scale_factor; 

  //  Vector tuioObjectList = tuioClient.getTuioObjects();
  //  for (int i=0;i<tuioObjectList.size();i++) {
  //    TuioObject tobj = (TuioObject)tuioObjectList.elementAt(i);
  //    stroke(0);
  //    fill(0);
  //    pushMatrix();
  //    translate(tobj.getScreenX(width), tobj.getScreenY(height));
  //    rotate(tobj.getAngle());
  //    rect(-obj_size/2, -obj_size/2, obj_size, obj_size);
  //    popMatrix();
  //    fill(255);
  //
  //    pushMatrix();
  //    noStroke();
  //    fill(base);
  //
  //    xoff = xoff + .01;
  //    yoff = yoff + random(0, .01);
  //    float n = noise(xoff) * width;
  //    float nn=noise(yoff) * height;
  //
  //    ellipse(n, nn, ellipseW, ellipseH);
  //    popMatrix();
  //
  //
  //    text(""+tobj.getSymbolID(), tobj.getScreenX(width), tobj.getScreenY(height));
  //  }

  Vector tuioCursorList = tuioClient.getTuioCursors();
  for (int i=0;i<tuioCursorList.size();i++) {
    TuioCursor tcur = (TuioCursor)tuioCursorList.elementAt(i);
    Vector pointList = tcur.getPath();

    pushMatrix();
    //scale(-1, 1);
    translate(w*.2, h);
    rotate(radians(-90));

    if (pointList.size()>0) {
      stroke(0, 0, 255);
      TuioPoint start_point = (TuioPoint)pointList.firstElement();
      ;
      for (int j=0;j<pointList.size();j++) {
        TuioPoint end_point = (TuioPoint)pointList.elementAt(j);
        line(start_point.getScreenX(width), start_point.getScreenY(height), end_point.getScreenX(width), end_point.getScreenY(height));

        // translate(width*.5, height*.5);
        noStroke();
        fill(base);

        xoff = xoff + .01;
        yoff = yoff + random(0, .01);
        float n = noise(xoff) * width;
        float nn=noise(yoff) * height;

        ellipse(start_point.getScreenX(width), start_point.getScreenY(height), ellipseW, ellipseH);
        start_point = end_point;
      }

      stroke(192, 192, 192);
      fill(192, 192, 192);
     // ellipse( tcur.getScreenX(width), tcur.getScreenY(height), cur_size, cur_size);
      fill(0);
      //   text(""+ tcur.getCursorID(), tcur.getScreenX(width)-5, tcur.getScreenY(height)+5);
    }
    popMatrix();
  }
}

// these callback methods are called whenever a TUIO event occurs

// called when an object is added to the scene
void addTuioObject(TuioObject tobj) {
  println("add object "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle());
}

// called when an object is removed from the scene
void removeTuioObject(TuioObject tobj) {
  println("remove object "+tobj.getSymbolID()+" ("+tobj.getSessionID()+")");
}

// called when an object is moved
void updateTuioObject (TuioObject tobj) {
  println("update object "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle()
    +" "+tobj.getMotionSpeed()+" "+tobj.getRotationSpeed()+" "+tobj.getMotionAccel()+" "+tobj.getRotationAccel());
}

// called when a cursor is added to the scene
void addTuioCursor(TuioCursor tcur) {
  println("add cursor "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY());
}

// called when a cursor is moved
void updateTuioCursor (TuioCursor tcur) {
  println("update cursor "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY()
    +" "+tcur.getMotionSpeed()+" "+tcur.getMotionAccel());
}

// called when a cursor is removed from the scene
void removeTuioCursor(TuioCursor tcur) {
  println("remove cursor "+tcur.getCursorID()+" ("+tcur.getSessionID()+")");
}

// called after each message bundle
// representing the end of an image frame
void refresh(TuioTime bundleTime) { 
  redraw();
}



void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {

  noFill();

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(init, end, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }  
  else if (axis == X_AXIS) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(init, end, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
}

