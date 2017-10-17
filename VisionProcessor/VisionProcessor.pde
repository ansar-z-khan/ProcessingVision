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

public static final float threshold = 20;
public static final float pixelsToSkip = 2;

//used for calculation of ranges
public static final float SAT = -100;
//actual max sat
public static final float SAT_REAL = 95;
public static final float BRIGHTNESS = 50;



private final double maxBlobs = 1000;

private int step = 1;

private boolean frameByFrame = true;

private int timer = 0;
private boolean operational = true;

boolean Verbose = false;



void setup() {
  //size(160, 45);//change this according to your camera resolution, and double the widtht
  size(320, 120);
  frameRate(30);
  //Pass the Index of the Camera in the Constructor
  //See The VideoFinder class for instructios on where to get this numbers
  //Ansar's webcam
  //capture = new VideoFinder(13);
  //robot's webcam
  //capture = new VideoFinder(44);

  //Winnie's webcam
  //capture = new VideoFinder(8);   //15fps
  //capture = new VideoFinder(9);   //30fps
  
  //RObot Cam on Mac
  //capture = new VideoFinder(12);
  //Robot cam on windows
  capture = new VideoFinder(21);
  
  //Druiven's cam
  //capture = new VideoFinder(3);  //30fps

  rectMode(CORNERS);
  noFill();
  stroke(0, 0, 0);
  colorMode(HSB);

  //VideoFinder foo = new VideoFinder(true);
  //delay(1000);
} 




void draw() {  
  /*
  if (!operational && millis() > 7000) {
    //add commands in case that video provides blank output
    //exit();
  }
*/


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
    
    /*
    if (!operational && millis() < 5000 && greenPixels.size() != 0) {
      operational = true;
    }
    */
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
    //timesAdded = 0;
    if (blobs.size()>0 && greenPixels.size()>0) {
      //println(blobs.size() );
      //println("**********************");
      addBlob(0, 0, blobCheck);
    }
    //println("amount of pixels added = " + timesAdded);
    /*
    if (timesAdded != greenPixels.size() ) {
      println("amount of pixels added = " + timesAdded);
      delay(1000);
    }*/

    blobProcessor.process();
    
    //println("end of case");
    if (frameByFrame) {
      step=1;
      break;
    }
  }
  if (Verbose){
    println(blobs.size() + " blobs and " + greenPixels.size() + " pixels");
  }
//  delay(5000);
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

//int timesAdded;
private void addBlob (int blob, int pixel, ArrayList<Boolean> blobCheck) {
  //println ("Blob " + blob + "/" +  (blobs.size()-1) + ": Pixel " + pixel + "/" +  (greenPixels.size()-1));
  //println("blob = " + blob + " blob size = " + blobs.size() + " pixel = " + pixel + " size = " + greenPixels.size() );
  //if (blob >= blobs.size()-1 && pixel >= greenPixels.size()-1 ) {
  //return;
  //}

  boolean added = false;
  if (blobs.get(blob).isPartOf(greenPixels.get(pixel))) {
    //println("*****************true********************");
    blobs.get(blob).addToBlob(greenPixels.get(pixel));
    blobCheck.set(blob, true);
    added = true;
    //timesAdded++;
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