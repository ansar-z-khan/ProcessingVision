

protected class Finder {


  //This is the main function that should be called by other classes on the outside
  public ArrayList <Pixel> getPixels(PImage image) {
    //getMousePixel(image);
    return findGreenPixels(image);
  }

  //Gets Green Pixels
  protected ArrayList <Pixel> findGreenPixels(PImage img) {
    ArrayList <Pixel> greenPixels = new ArrayList<Pixel>();//Declare a templist for pixels found
    for (int i = 0; i<img.width; i += pixelsToSkip) {//Iterate throough width
      for (int j = 0; j<img.height; j += pixelsToSkip) {//Iterate through Height
        Pixel currentPixel = new Pixel(i, j, img.get(i, j));//Store Current Pixel
        if (isGreen(currentPixel, VisionProcessor.threshold)) {//Check if pixel is green
          if (!greenPixels.contains(currentPixel) ) {
            greenPixels.add(currentPixel);//Add to the list of pixels
          }
        }
      }
    }
    return greenPixels;
  }

  //Checks if a gicen p
  protected boolean isGreen(Pixel p, double threshold) {
    if (p.getGreen() <= p.getRed() || p.getGreen() <= p.getBlue() || p.getGreen()<=50 ) {
      return false;
    }
    //println("__________________________________________");
    //println(red(c) + ", " + green(c) + ", " + blue(c));
    //println(rgb[0] + " " + rgb[1] + " " + rgb[2]);
    //println(rgb[1]/rgb[0] + ", " + rgb[1]/rgb[2]);
    //println(rgb[1]/rgb[0] >= threshold/100 && rgb[1]/rgb[2] >= threshold/100);

    return (p.getSquaredGreen()/p.getSquaredRed() >= threshold/100 && p.getSquaredGreen()/p.getSquaredBlue() >= threshold/100);
  }
  protected boolean isGreenHSB(Pixel p, float threshold) {
    //final float PURE_GREEN = 120;
    //final float IDEAL_GREEN = 170;
    //Hue between 100 and 140
    PVector pointA = new PVector(VisionProcessor.IDEAL_GREEN-threshold, 0.0);
    PVector pointB = new PVector(VisionProcessor.IDEAL_GREEN, 100-SAT);
    PVector pointC = new PVector(VisionProcessor.IDEAL_GREEN+threshold, 0.0);
    
    double slopeR = (pointC.y - pointB.y)/(pointC.x - pointB.x);
    double slopeL = (pointA.y - pointB.y)/(pointA.x - pointB.x);
    

    double yIntR = pointB.y - (slopeR*pointB.x);
    double yIntL = pointB.y - (slopeL*pointB.x);

    /*
    return (p.getHue() > PURE_GREEN - threshold
          && p.getHue() < PURE_GREEN + threshold
          && p.getSat() <  (slopeL*p.getHue()) + yIntL//Sat 75
          && p.getSat() < (slopeR*p.getHue()) + yIntR
          && p.getBrightness()>60);
    */
    return (p.getSat() < SAT_REAL  
          && p.getSat() <  (slopeL*p.getHue()) + yIntL//Sat 75
          && p.getSat() < (slopeR*p.getHue()) + yIntR
          && p.getBrightness()>BRIGHTNESS);
      
  }
}