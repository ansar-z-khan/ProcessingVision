class AndroidVideoFinder extends Finder {

  private KetaiCamera cam;
  private PImage currentImage;

  AndroidVideoFinder(int _width, int _height) {
    cam = new KetaiCamera(VisionProcessor.this, _width, _height, 15);   
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
  PImage getCurrentImage() {
    return currentImage;
  }
  ArrayList <Pixel> getGreenPixels() {
    return getPixels(cam);
  }
}