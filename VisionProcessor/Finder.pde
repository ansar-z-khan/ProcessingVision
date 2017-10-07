

protected class Finder {
  
  
  //This is the main function that should be called by other classes on the outside
  public ArrayList <Pixel> getPixels(PImage image){
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
}