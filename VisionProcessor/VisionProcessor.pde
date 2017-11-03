import ketai.camera.*;
import ketai.cv.facedetector.*;
import ketai.data.*;
import ketai.net.*;
import ketai.net.bluetooth.*;
import ketai.net.nfc.*;
import ketai.net.nfc.record.*;
import ketai.net.wifidirect.*;
import ketai.sensors.*;
import ketai.ui.*;



//************************************************** previous master code below, android code above ************************************

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
private VideoFinder previewCapture;
//Capture Res: 176,144
private ColourSelector selector;

private ArrayList<Blob> blobs = new ArrayList<Blob>();
private ArrayList<Pixel> greenPixels = new ArrayList<Pixel>();

private BlobProcessor blobProcessor = new BlobProcessor(blobs);
//Low Number = More Stuff
//High Number = Less Stuff

public static final float pixelsToSkip = 3;
public static final int WIDTH = 200;
public static final int HEIGHT = 200;

//used for detection method 0
public static float idealHue = 175;
public static float idealSat = 70;
public static float idealBrightness = 90;
public static color idealColour;

//used for detection method 1
public static final float threshold = 20;
//used for calculation of ranges
public static final float SAT = -100;
//actual max sat
public static final float SAT_REAL = 95;
public static final float BRIGHTNESS = 80;



private final double maxBlobs = 1000;

private int step = 0;

private boolean frameByFrame = true;

private int timer = 0;
private boolean operational = true;

boolean Verbose = false;

//0 = area under two lines
//1 = threshold for each value
public static int detectionType = 1;

// ** also change size()
public enum RunType {
  PC, 
    ANDROID
}

static RunType runType = RunType.ANDROID;

void setup() {
  frameRate(30);
  //size(160, 45);//change this according to your camera resolution, and double the width
  //pc mode
  //size(320, 120);
  //android mode
  size(displayWidth, displayHeight);

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

  //Robot Cam on Mac
  //capture = new VideoFinder(12);
  //Robot cam on windows
  //capture = new VideoFinder(21);

  //Druiven's cam
  //capture = new VideoFinder(3);  //30fps

  if (runType == RunType.PC) {
    capture = new VideoFinder(21);
  } else if (runType == RunType.ANDROID) {
    previewCapture = new VideoFinder(1280, 960, true);
    //capture = new VideoFinder(WIDTH, HEIGHT, true);
  }

  selector = new ColourSelector();

  rectMode(CORNERS);
  if (runType == RunType.PC) {
    imageMode(CORNER);
  } else if (runType == RunType.ANDROID) {
    imageMode(CENTER);
  }
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

  case 0: //get raw image and tune to selected pixel
    background(255);

    if (runType == RunType.PC) {
      pcPreview();
    } else if (runType == RunType.ANDROID) {
      androidPreview();
    }

    if (frameByFrame) {
      break;
    }

  case 1://Draws the raw image from the stream, get green Pixels 

    background(255);
    if (runType == RunType.PC) {
      capture.updateImage();//Get New Image From Camera
      capture.drawImage(width/2, 0);//Draw Image
    } else if (runType == RunType.ANDROID) {
      capture.updateImage();//Get New Image From Camera
      capture.drawPreviewImage();//Draw Image
    }

    for (Blob b : blobs) {
      b.show();
      //println (b.pixels.size() + ", " + greenPixels.size());
      //b.clear();
    }
    displayGreen(greenPixels);//Draw Green Pixels
    blobs.clear();
    try {
      greenPixels = capture.getGreenPixels();
    }
    catch(Exception e) {
      e.printStackTrace();
    }

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
  if (Verbose) {
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
  if (runType == RunType.PC) {
    for (Pixel p : pixels) {
      stroke(p.getColour());//Set color to that of the pixel
      point(p.getPos().x, p.getPos().y);//Draw in the pixel
      //println(p.getRed() + ", "+p.getGreen() + ", " + p.getBlue());
    }
  } else if (runType == RunType.ANDROID) {
    for (Pixel p : pixels) {
      PVector shiftedPos = new PVector(p.getPos().x + width/2 - capture.getCurrentImage().width, p.getPos().y + height/2 - capture.getCurrentImage().width);
      stroke(p.getColour());//Set color to that of the pixel
      point(shiftedPos.x, shiftedPos.y);//Draw in the pixel
      //println(p.getRed() + ", "+p.getGreen() + ", " + p.getBlue());
    }
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
      if (pixel == greenPixels.size()-1) {
        return;
      }

      addBlob(0, pixel+1, blobCheck);
    }
  }
}