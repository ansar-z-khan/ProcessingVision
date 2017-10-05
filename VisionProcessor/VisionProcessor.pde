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
private VideoFinder capture;
private ArrayList<Blob> blobs = new ArrayList<Blob>();
private ArrayList<Pixel> greenPixels = new ArrayList<Pixel>();

private BlobProcessor blobProcessor = new BlobProcessor(blobs);
//Low Number = More Stuff
//High Number = Less Stuff

public static final double threshold = 110+10;
public static final float pixelsToSkip = 2;

private final double maxBlobs = 1000;

private int step = 1;

private boolean frameByFrame = true;



void setup() {
  size(160, 45);//change this according to your camera resolution, and double the width
  //size(320, 120);WINNIE Cam
  //Pass the Index of the Camera in the Constructor
  //See The VideoFinder class for instructios on where to get this numbers
  //Ansar's webcam
  capture = new VideoFinder(13);
  //robot's cam
  //capture = new VideoFinder(44);

  //Winnie's webcam
  //capture = new VideoFinder(2);

  rectMode(CORNERS);
  noFill();
  stroke(0, 0, 0);

  //VideoFinder foo = new VideoFinder(true);
} 




void draw() {  

  switch(step) {

  case 1://Draws the raw image from the stream, get green Pixels 
    background(255);
    capture.updateImage();//Get New Image From Camera
    capture.drawImage(width/2, 0);//Draw Image

    for (Blob b : blobs) {
      b.show();
      //println (b.pixels.size() + ", " + greenPixels.size());
      //b.clear();
    }
    displayGreen(greenPixels);//Draw Green Pixels
    blobs.clear();
    greenPixels = capture.getGreenPixels();
    if (frameByFrame) {
      step++;
      break;
    }
  case 2://Calculate Blobs
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
    blobProcessor.mergeAll();
    blobProcessor.deleteAll();

    if (frameByFrame) {
      step=1;
      break;
    }
  }
  println(blobs.size() + " blobs and " + greenPixels.size() + " pixels");
  //delay(1250);
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
}
private void displayGreen(ArrayList <Pixel> pixels) {
  for (Pixel p : pixels) {
    stroke(p.getColour());//Set color to that of the pixel
    point(p.getPos().x, p.getPos().y);//Draw in the pixel
    //println(p.getRed() + ", "+p.getGreen() + ", " + p.getBlue());
  }
}

private void addBlob (int blob, int pixel, ArrayList<Boolean> blobCheck) {
  //println ("Blob " + blob + "/" +  (blobs.size()-1) + ": Pixel " + pixel + "/" +  (greenPixels.size()-1));
  println("blob = " + blob + " blob size = " + blobs.size() + " pixel = " + pixel + " size = " + greenPixels.size() );
  //if (blob >= blobs.size()-1 && pixel >= greenPixels.size()-1 ) {
  //return;
  //}

  boolean added = false;
  if (blobs.get(blob).isPartOf(greenPixels.get(pixel))) {
    //println("*****************true********************");
    blobs.get(blob).addToBlob(greenPixels.get(pixel));
    blobCheck.set(blob, true);
    added = true;
  } else {
    if (blobs.size() < maxBlobs) {
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

  //next pixel
  if (blob == blobs.size()-1) {
    addBlob(0, pixel+1, blobCheck);
  } else {
    if (!added) {
      //next blob
      addBlob(blob+1, pixel, blobCheck);
    } else {
      if (pixel == greenPixels.size()-1){
        return;
      }

      addBlob(0, pixel+1, blobCheck);
    }
  }
}