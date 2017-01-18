
import processing.video.*;

// Variable for capture device
Capture video;

// A variable for the color we are searching for.
color trackColor; 

int closestX = 0;
int closestY = 0;
float pclosestX = 0;
float pclosestY = 0;

void setup() {
  size(1280, 480);
  background(255);
  video = new Capture(this, 640, 480);
  video.start();
  // Start off tracking for red
  trackColor = color(255, 0, 0);
}

void captureEvent(Capture video) {
  // Read image from the camera
  video.read();
}

void draw() {
  video.loadPixels();
  image(video, 0, 0);

  // Before we begin searching, the "world record" for closest color is set to a high number that is easy for the first pixel to beat.
  float worldRecord = 500; 

  // XY coordinate of closest color
  
  float sumX = 0;
  float sumY = 0;
  int SameColorCount=0;

  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {
      int loc = x + y*video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      // Using euclidean distance to compare colors
      float d = dist(r1, g1, b1, r2, g2, b2); // We are using the dist( ) function to compare the current color with the color we are tracking.

      // If current color is more similar to tracked color than
      // closest color, save current location and current difference
      if (d < 20) {
        worldRecord = d;
        sumX = x+sumX;
        sumY = y+sumY;
        SameColorCount++;
      }
    }
  }
  closestX = int(sumX / SameColorCount); 
  closestY = int(sumY / SameColorCount);

  // We only consider the color found if its color distance is less than 10. 
  // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
  if (worldRecord < 20) { 
    // Draw a circle at the tracked pixel
    fill(trackColor);
    strokeWeight(3.0);
    stroke(0);
    ellipse(closestX, closestY, 16, 16);
    if(abs(float(closestY)-pclosestY)<40 && abs(float(closestX)-pclosestX)<40)
    {
    line(float(closestX)+640, float(closestY),pclosestX+640, pclosestY);
    }
  }
  
  pclosestX = closestX;
  pclosestY = closestY;
}

void mousePressed() {
  // Save color where the mouse is clicked in trackColor variable
  int loc = mouseX + mouseY*video.width;
  trackColor = video.pixels[loc];
  background(255);
}