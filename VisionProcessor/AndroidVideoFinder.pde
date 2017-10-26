/*
class AndroidVideoFinder extends Finder {

  private KetaiCamera cam;
  private PImage currentImage;

  AndroidVideoFinder(int _width, int _height) {
    cam = new KetaiCamera(VisionProcessor.this, _width, _height, 30 );   
    cam.setPhotoSize(_width,_height);
    cam.autoSettings();
    cam.start();
  }
  void updateImage() {
    cam.read();
    currentImage = cam;
  }
  void onCameraPreviewEvent()
  {
    cam.read();
   
  }
  void drawImage() {
    //image(lastImage, 0, 0);
    
    image(currentImage, width/2, (height/2));
  }
  void drawPreviewImage() {
    
    //image(lastImage, 0, 0);
    pushMatrix();
    translate(width/2,height/2);
    rotate(90*PI/180);
    
    image(currentImage,0,0);
    point(0,0);
    popMatrix();
  }
  PImage getCurrentImage() {
    return currentImage;
  }
  ArrayList <Pixel> getGreenPixels() {
    return getPixels(cam);
  }
}*/