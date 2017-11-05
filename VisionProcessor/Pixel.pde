//the object that is used to store properties of the pixel
class Pixel {
  //the position of the pixel
  private PVector pos;
  //the colour of the pixel
  private color colour;

  //constructor used to create the pixel
  //takes in the x and y coordinates of the pixel, and its colour
  Pixel(int x, int y, color c) {
    pos = new PVector(x, y);
    colour = c;
  }

  //these methods return the pixel's properties
  PVector getPos() {
    return pos;
  }
  color getColour() {
    return colour;
  }
  //returns the RGB values of the pixel
  float getRed() {
    return red(colour);
  }
  float getGreen() {
    return green(colour);
  }
  float getBlue() {
    return blue(colour);
  }
  
  //returns the squared RGB values used in RGB detection
  float getSquaredRed() {
    return pow(red(colour), 2);
  }
  float getSquaredGreen() {
    return pow(green(colour), 2);
  }
  float getSquaredBlue() {
    return pow(blue(colour), 2);
  }
  
  //returns the HSV values of the pixel
  float getHue() {
    //value scaled to be out of 360, the default scale for HSV, instead of the given 255 from Processing
    return (hue(colour)*(24.0/17.0) );
    //return (hue(colour));
  }
  float getSaturation() {
    //rescales to be out of 100 instead of 255
    return (saturation(colour)*(20.0/51.0) );
    //return (saturation(colour));
  }
  //this saturation is subtracted from 100 for use in the trapezoid method of detection
  float getSat(){
    //rescales to be out of 100 instead of 255
    return (100.0-(getSaturation()*(20.0/51.0) ) );
  }
  float getBrightness() {
    //rescales to be out of 100 instead of 255
    return (brightness(colour)*(20.0/51.0));
    //return (brightness(colour));
  }
}