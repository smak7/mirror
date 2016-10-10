import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

PFont font;
float x;
float y;
int boxSize=640;
int windowWidth = 640;
int windowHeight = 480;  
int r = 0, g = 0, b = 0;
float h = 0, s = 0, v = 0;

void setup() {
    size(1080,1920);
    //size(displayWidth,displayHeight);
    //video = new Capture(this, 960, 540, "HD Pro Webcam C920",30);
    //video = new Capture(this, 960, 540, "HD Pro Webcam C920",30);
    video = new Capture(this, 640, 480);
    opencv = new OpenCV(this, 640, 480);
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
    video.start();
}

void draw() {

  background(0);
  opencv.loadImage(video);
  image(video, 220,720);
  
  //font = createFont("BrownProTT-Bold.ttf",28);
  //textFont(font);
  //textSize(60);
  //fill(255,0,0);
  //text("RACIAL",100,1300);
  //fill(0,255,0);
  //text("GENERATIVE",100,1400);
  //fill(0,0,255);
  //text("BIAS",100,1500);

  Rectangle[] faces = opencv.detect();
  
 for (int i = 0; i < faces.length; i++) {
    noFill();
    println(faces[i].x , faces[i].y);
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    translate(220,720);
    // grabbing the center of the face detection in the size of 1/4 of the actual image
    int centerWidth = faces[i].width/8;
    int centerHeight = faces[i].height/8;
    int centerX = faces[i].width/2;
    int centerY = faces[i].height/2 + faces[i].height/16; // offset a little offcenter for eyes
    int count = 0;
    float[] hsv = new float[3];

    rect(faces[i].x + centerX-centerWidth, faces[i].y + centerY-centerHeight, centerWidth*2, centerHeight*2);
    translate(220,720);
    for(int x = centerX - centerWidth; x < centerX + centerWidth; x++){
      for(int y =centerY - centerHeight; y < centerY + centerHeight; y++){    
        color c = video.get(faces[i].x+x, faces[i].y+y);
        Color.RGBtoHSB(c>>16&0xFF,c>>8&0xFF,c&0xFF,hsv);
        h +=hsv[0];
        s +=hsv[1];
        v +=hsv[2];
        
        r += c>>16&0xFF;
        g += c>>8&0xFF;
        b += c&0xFF;
        count++; 
       }
    }
        r /= count;
        g /= count;
        b /= count;
              
        h /= count;
        s /= count;
        v /= count;
        
    // source: http://docs.oracle.com/javase/1.5.0/docs/api/java/awt/Color.html#RGBtoHSB%28int,%20int,%20int,%20float%5b%5d%29
    // converting rgb to huse saturation brightness color space
    // array return composed of hue saturation brightness 
    
    //fill(r,g,b);
    
    // hsv mode 
    colorMode(HSB,1,1,1);
    fill(color(h,s,v));
    // make this box large to show the entire size 
    rect(-440,-1450,1080,1950);
    translate(220,720);
   
    //noStroke();
    
   //logging values -- 
    //println(h*360,s*100,v*100);
    //println(r,g,b);
    //colorMode(RGB, 255, 255, 255);
    //fill(color(r,g,b));
    ////box on the right
    //// make the box large to show the entire size 
    //rect(2*boxSize/8,0, boxSize/8, boxSize/8);
    
    //if(v < .3){
    //  fill(255,255,255);
    //  textSize(28);
    //  text("too dark to read your color", 200,450);
    //}else {
    //  fill(0,0,0);
    //  textSize(28);
    //  text(r,220,450);
    //  text(g,290,450);
    //  text(b,360,450);    
    //}
 }
}

void captureEvent(Capture c) {
  c.read();
}