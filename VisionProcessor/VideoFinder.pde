
import processing.video.*;
import java.util.*;

class VideoFinder extends Finder {

  private Capture cam;
  private KetaiCamera androidCam;
  private int camNumber = 0;
  private PImage currentImage;
  private PImage lastImage;

  private int repeatCounter = 0;

  private RunType runType;


  //Call This Constructor to print out all cameras, The code will crash, but choose the camera you want and call the constructor with the int
  VideoFinder(boolean getCamNumber) {
    printAvailableCams(Capture.list());
    camNumber = 0;
  }

  //pc mode
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
    runType = RunType.PC;
  }

  //android mode
  VideoFinder(int _width, int _height, boolean isAndroid) {
    androidCam = new KetaiCamera(VisionProcessor.this, _width, _height, 30 );   
    androidCam.setPhotoSize(_width, _height);
    androidCam.autoSettings();
    androidCam.start();
    runType = RunType.ANDROID;
  }



  ArrayList <Pixel> getGreenPixels() {
    if(runType == RunType.PC){
      return getPixels(cam);
    }
    else{
      return getPixels(androidCam);
    }
  }
  //Gets newest Image From Camera
  void updateImage() {
    println("Beginning Update Image");
    if (runType == RunType.PC) {
      if (cam.available() == true) {
        cam.read();
        lastImage = currentImage.get();
        currentImage = cam;
        //freeze method does not work
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
    } else if (runType == RunType.ANDROID) {
        println("Before Read");
        androidCam.read();
        println("After Read");
        currentImage = androidCam;

    }
    println("END OF Update Image");
  }

  void frozen() {
    //exit();
    //println("The Image has not updated for the last " + cam.frameRate * 30 + " frames, exitting");
  }

  //pc mode
  void drawImage(float x, float y) {
    //image(lastImage, 0, 0);
    image(currentImage, x, y);
  }
  //android mode
  void drawImage() {
    //image(lastImage, 0, 0);
    image(currentImage, width/2, (height/2));
  }

  void drawPreviewImage() {
    //image(lastImage, 0, 0);
    pushMatrix();
    translate(width/2, height/2);
    rotate(90*PI/180);

    image(currentImage, 0, 0);
    popMatrix();
  }

  void printAvailableCams(String[] CaptureList) {
    String[] cameras = Capture.list();
    if (CaptureList.length == 0) {
      println("There are no cameras available for capture.");
      //exit();
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

  /*
  void onCameraPreviewEvent()
   {
   cam.read();
   
   }*/
}