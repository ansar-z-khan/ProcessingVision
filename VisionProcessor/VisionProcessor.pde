/*
Pseudocode
 - pixel class
   - takes in 2d array of pixels
   - properties:
     - green threshold
     - frequency
     - ArrayList of green pixels
   - methods
     - getGreenPixels
     - isGreen

*/

//This VideoFinder Class takes care of all the video and the detection of green
VideoFinder capture;


void setup() {
  size(160, 45);//change this according to your camera resolution, and double the width
  //Pass the Index of the Camera in the Constructor
  capture = new VideoFinder(13);//See The VideoFinder class for instructios on where to get this numbers
  
  
} 

//Low Number = More Stuff
//High Number = More Stuff
public static final double threshold = 120;

void draw() {  
  background(255);
  capture.updateImage();//Get New Image From Camera
  capture.drawImage(width/2,0);//Draw Image
  displayGreen(capture.getGreenPixels());//Fraw Green Pixels
}



public void displayGreen(ArrayList <Pixel> pixels){
  for (Pixel p:pixels){
    stroke(p.getColour());//Set color to that of the pixel
    point(p.getPos().x, p.getPos().y);//Draw in the pixel
    //println(p.getRed() + ", "+p.getGreen() + ", " + p.getBlue());
    
  } 
}