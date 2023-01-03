// ASCIIwithShapes
// Claire Winogrodzki
// part of the "exhibit_code" art installation
// Turns your webcam feed into an ASCII display! Also displays
// cool rotating shapes to the side.
// based on Daniel Shiffman's code:
// https://thecodingtrain.com/CodingChallenges/166-ascii-image.html

var sketch1 = function(p) {
  p.rotAngle = 0;
  p.setup = function() {
    p.createCanvas(400, 650, p.WEBGL);
  }

  p.draw = function() {
    p.background(0);
    p.noFill();
    p.stroke(0,200,0);
    p.strokeWeight(1);
    p.rotateY(p.rotAngle);
    p.rotAngle+=0.005;
    p.sphere(100);
    p.translate(0, -200);
    p.box(130)
    p.translate(0, 435);
    p.cone(110, 170, 5, 1, 0);
  }
}

var sketch2 = function(q) {
  //q.density = "Ñ@#W$9876543210?!abc;:+=-,._                    ";
  // const density = '       .:-i|=+%O#@'
  // const density = '        .:░▒▓█';
  q.density = '.@#O%+=|i-:.                             ';

  let video = q.video;
  let asciiDiv = q.asciiDiv;

  q.setup = function() {
    q.noCanvas();
    q.video = q.createCapture(q.VIDEO);
    //q.video.size(64, 48);
    q.video.size(90, 60);
    q.asciiDiv = q.createDiv();
    q.asciiDiv.position(400, 0);
    q.video.hide();
  }

  q.draw = function() {
    q.video.loadPixels();
    let asciiImage = q.asciiImage;
    q.asciiImage = "";
    for (let j = 0; j < q.video.height; j++) {
      for (let i = 0; i < q.video.width; i++) {
        q.pixelIndex = (i + j * q.video.width) * 4;
        q.r = q.video.pixels[q.pixelIndex + 0];
        q.g = q.video.pixels[q.pixelIndex + 1];
        q.b = q.video.pixels[q.pixelIndex + 2];
        q.avg = (q.r + q.g + q.b) / 3;
        q.len = q.density.length;
        q.charIndex = q.floor(q.map(q.avg, 0, 255, 0, q.len));
        q.c = q.density.charAt(q.charIndex);
        if (q.c == " ") q.asciiImage += "&nbsp;";
        else q.asciiImage += q.c;
      }
      q.asciiImage += '<br/>';
    }
    q.asciiDiv.html(asciiImage);
  }
}

var shapesSketch = new p5(sketch1);
var ASCIIskecth = new p5(sketch2);

function windowResized() {
  shapesSketch.resizeCanvas(windowWidth/4, windowHeight);
  //ASCIIsketch.resizeCanvas(windowWidth, windowHeight);
}