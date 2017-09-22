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
public static final double threshold = 190;



void setup() {
  //size(160, 45);//change this according to your camera resolution, and double the width
  size(320, 120);
  //Pass the Index of the Camera in the Constructor
  //See The VideoFinder class for instructios on where to get this numbers
  //Ansar's webcam
  //capture = new VideoFinder(13);
  
  //robot's cam
  //capture = new VideoFinder(44);
  
  //Winnie's webcam
  capture = new VideoFinder(2);
  
  rectMode(CORNERS);
  noFill();
  stroke(0,255,0);
  
  //VideoFinder foo = new VideoFinder(true);
} 




void draw() {  
  background(255);
  capture.updateImage();//Get New Image From Camera
  capture.drawImage(width/2, 0);//Draw Image
  greenPixels = capture.getGreenPixels();

  displayGreen(greenPixels);//Draw Green Pixels
  ArrayList<Boolean> blobCheck = new ArrayList<Boolean>();
  if (blobs.size()<1 && greenPixels.size()>0) {
    blobs.add(new Blob(greenPixels.get(0)));
    blobCheck.add(false);
    //addBlob(0, 0);
  }
  if (blobs.size()>0 && greenPixels.size()>0) {
    //println(blobs.size() );
    //println("**********************");
    
    addBlob(0, 0, blobCheck);
  }
  
  /*
  for (Pixel p : greenPixels) {
   for (Blob b : blobs){
   
     if (b.isPartOf(p)){
       b.addToBlob(p);
     } else {
       //blobs.add(new Blob(p));
     }
   
   }
 }*/
   

 // addBlob(0, 0);
 println(blobs.size() + " blobs and " + greenPixels.size() + " pixels");
  for (Blob b : blobs) {
    b.show();
    //println (b.pixels.size() + ", " + greenPixels.size());
    //b.clear();
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

public void addBlob (int blob, int pixel, ArrayList<Boolean> blobCheck) {
  if (blobs.get(blob).isPartOf(greenPixels.get(pixel))) {
    //println("*****************true********************");
    blobs.get(blob).addToBlob(greenPixels.get(pixel));
    blobCheck.set(blob, true);
  } else {
    if (blobs.size() < 10) {
      //println(true);
      //blobs.add(new Blob(greenPixels.get(pixel)));
      blobCheck.set(blob, false);
    }
  }
  
  if (blob == blobs.size()-1 && !blobCheck.contains(true) ) {
    blobs.add(new Blob(greenPixels.get(pixel)));
    blobCheck.add(false);
  }

  if (blob == blobs.size()-1 && pixel == greenPixels.size()-1) {
    return;
  }

  /*
  if (pixel == greenPixels.size()-1) {
    if (blob != blobs.size()-1) {
      addBlob(blob+1, 0);
    }
  } else {
    addBlob(blob, pixel+1);
  }*/
  
  if (blob == blobs.size()-1) {
    addBlob(0, pixel+1, blobCheck);
  } else {
    addBlob(blob+1, pixel, blobCheck);
  }
}