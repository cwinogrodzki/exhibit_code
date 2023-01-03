// ScatterLettersWithDetails
// by Claire Winogrodzki
// based on StringAnimationDemos by Jeremy Douglass, 2018-01-19
// part of the "exhibit_code" art installation

import processing.javafx.*;
import ch.bildspur.vision.*;
import ch.bildspur.vision.result.*;

import processing.video.Capture;

Capture cam;
StringList letters;
PFont font;
Wave wave;

DeepVision vision;
ULFGFaceDetectionNetwork network;
ResultList<ObjectDetectionResult> detections;

void setup() {
  //size(250, 200);
  //size(640, 480, FX2D);
  size(1920, 1440, FX2D);
  colorMode(HSB, 360, 100, 100);
  letters = new StringList();
  font = loadFont("CourierNewPS-BoldMT-30.vlw");
  
  letters.append("Without change something sleeps");
  letters.append("inside us, and seldom awakens.");
  letters.append("The sleeper must awaken.");
  
  println("creating network...");
  vision = new DeepVision(this);
  network = vision.createULFGFaceDetectorRFB320();

  println("loading model...");
  network.setup();
  
  //network.setConfidenceThreshold(0.5);

  println("setup camera...");
  cam = new Capture(this, 640, 480, "pipeline:autovideosrc");
  cam.start();
  wave = new Wave(8, 4);
}

void draw() {
  background(0);
  
  if (cam.available()) {
    cam.read();
  }

  //image(cam, 0, 0);

  if (cam.width == 0) {
    return;
  }

  detections = network.run(cam);

  noFill();
  strokeWeight(2f);

  wave.calcWave();
  wave.renderWave();
  
  translate(0,height/2);
  
  //stroke(200, 80, 100);
  scale(2);
  for (ObjectDetectionResult detection : detections) {
    translate(50, 50);
    drawLettersScatterFade(letters, detection.getY()/float(height));
    //drawLettersScatterFade(letters, sqrt((detection.getY()-height/2)/float(height)*(detection.getY()-height/2)/float(height)));
  }
}

void drawLettersScatterFade(StringList s, float amt) {
  float stringAmt = 0;
  float xoffset = 0;
  float yoffset = 0;
  float travel = 0;
  if(amt < 0){
    amt = 0;
  }
  //print("\n"+amt);
  for (String str : s) {
    for (int i = 0; i < str.length(); i++) {
      stringAmt = (i+1)/float(str.length()+1);
      char c = str.charAt(i);
      travel = amt;
      pushMatrix();
      // move each letter in a different direction
      rotate(i);
      translate(0, travel*200);
      rotate(-i);
      pushStyle();
      // fade each letter by its position and the amt
      float opacity = 255 * (2 + (stringAmt-1) - (3*amt));
      fill(255, opacity);
      textFont(font);
      text(c, xoffset, yoffset);
      popStyle();
      xoffset += textWidth(c);
      popMatrix();
    }
    xoffset = 0;
    yoffset +=40;
  }
}
