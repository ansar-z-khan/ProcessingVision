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
ArrayList<Blob> blobs = new ArrayList<Blob>();
ArrayList<Pixel> greenPixels = new ArrayList<Pixel>();
//Low Number = More Stuff
//High Number = Less Stuff
public static final double threshold = 105;



void setup() {
  size(160, 45);//change this according to your camera resolution, and double the width
  //Pass the Index of the Camera in the Constructor
  capture = new VideoFinder(13);//See The VideoFinder class for instructios on where to get this numbers
  rectMode(CORNERS);
  noFill();
  stroke(0,255,0);
} 




void draw() {  
  background(255);
  capture.updateImage();//Get New Image From Camera
  capture.drawImage(width/2, 0);//Draw Image
  greenPixels = capture.getGreenPixels();

  displayGreen(greenPixels);//Fraw Green Pixels
  if (blobs.size()<1 && greenPixels.size()>0) {
    blobs.add(new Blob(greenPixels.get(0)));
  } else if (blobs.size()>=1 && greenPixels.size()>0) {
    addBlob(0, 0);
  }
  
  /*
  for (Pixel p : greenPixels) {
   for (Blob b : blobs){
   
     if (b.isPartOf(p)){
       b.addToBlob(p);
     }
   
   }
 }*/
   

 // addBlob(0, 0);
  for (Blob b : blobs) {
    b.show();
    println (b.pixels.size() + ", " + greenPixels.size());
    b.clear();
  }
  blobs.clear();
}


public void displayGreen(ArrayList <Pixel> pixels) {
  for (Pixel p : pixels) {
    stroke(p.getColour());//Set color to that of the pixel
    point(p.getPos().x, p.getPos().y);//Draw in the pixel
    //println(p.getRed() + ", "+p.getGreen() + ", " + p.getBlue());
  }
}

public void addBlob (int blob, int pixel) {
  if (blobs.get(blob).isPartOf(greenPixels.get(pixel))) {
    blobs.get(blob).addToBlob(greenPixels.get(pixel));
  } else {
    blobs.add(new Blob(greenPixels.get(pixel)));
  }

  if (blob == blobs.size()-1 && pixel == greenPixels.size()-1) {
    return;
  }

  if (pixel == greenPixels.size()-1) {
    if (blob != blobs.size()-1) {
      addBlob(blob+1, 0);
    }
  } else {
    addBlob(blob, pixel+1);
  }
}