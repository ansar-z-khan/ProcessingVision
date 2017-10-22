class AndroidVideoFinder extends Finder {

  private KetaiCamera cam;
  private PImage currentImage;

  AndroidVideoFinder(int _width, int _height) {
    cam = new KetaiCamera(VisionProcessor.this, _width, _height, 30 );   
    cam.setPhotoSize(1280,720);
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
  void drawImage(float x, float y) {
    //image(lastImage, 0, 0);
    
    image(currentImage, x, y);
  }
  void drawPreviewImage() {
    //image(lastImage, 0, 0);
    pushMatrix();
    translate(displayWidth/2, displayHeight/2);
    rotate(90.0*PI/180.0);
    image(currentImage, 0,0);
    point(0,0);
    popMatrix();
  }
  PImage getCurrentImage() {
    return currentImage;
  }
  ArrayList <Pixel> getGreenPixels() {
    return getPixels(cam);
  }
}