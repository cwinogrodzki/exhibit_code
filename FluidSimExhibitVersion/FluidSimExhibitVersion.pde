// Fluid Simulation
// by Claire Winogrodzki
// part of the "exhibit_code" art installation
// based on Daniel Shiffman's code here: https://thecodingtrain.com/CodingChallenges/132-fluid-simulation.html
// also based on:
// Real-Time Fluid Dynamics for Games by Jos Stam
// http://www.dgp.toronto.edu/people/stam/reality/Research/pdf/GDC03.pdf

import processing.javafx.*;
import ch.bildspur.vision.*;
import ch.bildspur.vision.result.*;
import processing.core.PApplet;
import processing.core.PConstants;
import processing.core.PImage;
import processing.video.Capture;

Capture cam;
PImage inputImage;
PImage mirrorImage;
DeepVision deepVision = new DeepVision(this);
YOLONetwork yolo;
ResultList<ObjectDetectionResult> detections;
PFont font;

final int N = 320;
final int iter = 16;
final int SCALE = 6;
float t = 0;

Fluid fluid;
String prompt = "Move your hand in front of the webcam to draw";

void setup() {
  //size(1280, 1280, FX2D);
  size(1920, 1440, FX2D);
  font = loadFont("CourierNewPS-BoldMT-48.vlw");
  
  println("creating model...");
  yolo = deepVision.createCrossHandDetectorTinyPRN();
  yolo.setConfidenceThreshold(0.3);

  println("loading yolo model...");
  yolo.setup();

  println("setup camera...");
  cam = new Capture(this, 1920, 1440, "pipeline:autovideosrc");
  println("capture created");   
  cam.start();
  inputImage = new PImage(320, 240, RGB);
  mirrorImage = new PImage(cam.width, cam.height, RGB);
  fluid = new Fluid(0.2, 0, 0);
  //fluid = new Fluid(0.2, 0, 0.0000001);
}

void updateDrawing(int x, int y, float prevX, float prevY) {
  fluid.addDensity(x/SCALE, y/SCALE, 400);
  float amtX = x - prevX;
  float amtY = y - prevY;
  fluid.addVelocity(x/SCALE, y/SCALE, amtX/2, amtY/2);
}

void draw(){
  background(0);

  if (cam.available()) {
    cam.read();
  }

  image(cam, 0, 0);
  
  if(cam.width == 0) {
    return;
  }
  
  cam.loadPixels();
  //Mirroring the image
  for(int x = 0; x < cam.width; x++){
    for(int y = 0; y < cam.height; y++){
      mirrorImage.pixels[x+y*cam.width] = cam.pixels[(cam.width-(x+1))+y*cam.width];
    }
  }
  
  inputImage.copy(mirrorImage, 0, 0, mirrorImage.width, mirrorImage.height, 0, 0, inputImage.width, inputImage.height);
  
  detections = yolo.run(inputImage);
  
  //scale(4);
  
  // extract x and y hand positions from the network detections
  for (int i = 0; i < detections.size(); i++) {
    ObjectDetectionResult currentDetection = detections.get(i);
    //multiply coordinates by 4 to bring up to scale
    int currentX = round(currentDetection.getCenterX())*6;
    int currentY = round(currentDetection.getCenterY())*6;
    if (i==0){
      float prevX = 0;
      float prevY = 0;
      updateDrawing(currentX, currentY, prevX, prevY);
    }
    else{
      ObjectDetectionResult prevDetection = detections.get(i-1);
      float prevX = prevDetection.getCenterX()*6;
      float prevY = prevDetection.getCenterY()*6;
      updateDrawing(currentX, currentY, prevX, prevY);
    }
  }
  
  fluid.step();
  fluid.renderD();
  
  // show text prompt
  textFont(font);
  textSize(48);
  fill(0, 0, 255);
  text(prompt, 30, 50);
}
