// Wave
// by Claire Winogrodzki
// simple wave animation displayed above ScatterLetters
// based on Daniel Shiffman's example here: https://processing.org/examples/additivewave.html
 
class Wave {
  
  int xspacing;   // How far apart should each horizontal location be spaced
  int w;              // Width of entire wave
  int maxwaves;   // total # of waves to add together
  
  float theta;
  float[] amplitude; // Height of wave
  float[] dx;         // Value for incrementing X, to be calculated as a function of period and xspacing
  float[] yvalues;
  
  //xspacing = 8, maxwaves = 4;
  Wave(int xspac, int totalWaves) {
    this.xspacing = xspac;
    this.maxwaves = totalWaves;
    
    this.w = width + 16;
    this.theta = 0.0;
    this.amplitude = new float[maxwaves];
    this.dx = new float[maxwaves];
    
    for (int i = 0; i < maxwaves; i++) {
      amplitude[i] = random(10,30);
      float period = random(100,300); // How many pixels before the wave repeats
      dx[i] = (TWO_PI / period) * xspacing;
    }
  
    yvalues = new float[w/xspacing];
  }
  
  void calcWave() {
    // Increment theta (try different values for 'angular velocity' here
    theta += 0.02;
  
    // Set all height values to zero
    for (int i = 0; i < yvalues.length; i++) {
      yvalues[i] = 0;
    }
   
    // Accumulate wave height values
    for (int j = 0; j < maxwaves; j++) {
      float x = theta;
      for (int i = 0; i < yvalues.length; i++) {
        // Every other wave is cosine instead of sine
        if (j % 2 == 0)  yvalues[i] += sin(x)*amplitude[j];
        else yvalues[i] += cos(x)*amplitude[j];
        x+=dx[j];
      }
    }
  }
  
  void renderWave() {
    // A simple way to draw the wave with an ellipse at each location
    noStroke();
    fill(200, 75, 100, 70);
    ellipseMode(CENTER);
    for (int x = 0; x < yvalues.length; x++) {
      ellipse(x*xspacing,height/4+yvalues[x],16,16);
    }
  }
}  
