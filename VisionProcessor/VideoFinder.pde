
import processing.video.*;


class VideoFinder extends Finder {

  private Capture cam;
  private final int camNumber;
  private PImage currentImage;
  private PImage lastImage;

  private int repeatCounter = 0;


  //Call This Constructor to print out all cameras, The code will crash, but choose the camera you want and call the constructor with the int
  VideoFinder(boolean getCamNumber) {
    printAvailableCams(Capture.list());
    camNumber = 0;
  }

  //Use This Constructor during normal use
  VideoFinder(int camNum) {
    camNumber = camNum;
    String[] cameras = Capture.list();
    if (camNumber < cameras.length) {
      //Init Camera
      cam = new Capture(VisionProcessor.this, cameras[camNumber]);
      cam.start();
      lastImage = createImage(cam.width, cam.height, RGB);
      currentImage = createImage(cam.width, cam.height, RGB);
    } else {
      System.err.println("Camera Not Found at Index " + camNumber);
    }
  }





  ArrayList <Pixel> getGreenPixels() {
    return getPixels(cam);
  }
  //Gets newest Image From Camera
  void updateImage() {

    if (cam.available() == true) {
      cam.read();
      println(currentImage.pixels.length + ", " + lastImage.pixels.length);
      lastImage = currentImage.get();
      currentImage = cam;
      if (Arrays.equals(currentImage.pixels, lastImage.pixels)) {
        repeatCounter++;
        //println("repeat" + repeatCounter);
      } else {
        repeatCounter = 0;
      }
      if (repeatCounter > cam.frameRate * 30) {
        frozen();
      }
    }
  }

  void frozen() {
    //exit();
    //println("The Image has not updated for the last " + cam.frameRate * 30 + " frames, exitting");
  }

  void drawImage(float x, float y) {
    //image(lastImage, 0, 0);
    image(currentImage, x, y);
  }

  void printAvailableCams(String[] CaptureList) {
    String[] cameras = Capture.list();
    if (CaptureList.length == 0) {
      println("There are no cameras available for capture.");
      exit();
    } else {
      println("Available cameras:");
      for (int i = 0; i < cameras.length; i++) {
        println("index=" + i+ " " + CaptureList[i]);
      }
    }
  }

  PImage getCurrentImage() {
    return currentImage;
  }
}