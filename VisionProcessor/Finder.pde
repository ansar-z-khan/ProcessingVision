//this class finds the green pixels in the camera's output
protected class Finder {
  
  //thresholds of different properties of the colour
  //used for HSV detection
  private float hueThreshold = 10;
  private float satThreshold = 25;
  private float brightnessThreshold = 10;

  //This is the main function that should be called by other classes on the outside
  //passes in the cam's image and returns all the green pixels in the image
  public ArrayList <Pixel> getPixels(PImage image) {
    //getMousePixel(image);
    return findGreenPixels(image);
  }

  //Goes through all pixels in an image and returns the green ones
  //Requires: PImage img: image to look through
  //Returns: An array list of pixels determined to be green
  
  protected ArrayList <Pixel> findGreenPixels(PImage img) {
    //creates the list for all the found green pixels
    ArrayList <Pixel> greenPixels = new ArrayList<Pixel>();

    //goes through the pixels of the image
    //Iterate through width
    for (int i = 0; i<img.width; i += pixelsToSkip) {
      //Iterate through Height
      for (int j = 0; j<img.height; j += pixelsToSkip) {
        //Store Current Pixel
        Pixel currentPixel = new Pixel(i, j, img.get(i, j));
        //Checks if pixel is green
        if (isGreenHSB(currentPixel, VisionProcessor.idealHue, VisionProcessor.idealSat, VisionProcessor.idealBrightness)) {
          //if the list of pixel does not already contain this pixel
          //necessary?
          if (!greenPixels.contains(currentPixel) ) {
            //Add to the list of pixels
            greenPixels.add(currentPixel);
          }
        }
        
        //used for debug purposes
        //prints the colour of the pixel at the mouse's coordinates
        if (i == (mouseX - width/2) && j == mouseY){
          fill(img.get(i,j));
          ellipse(mouseX, mouseY, 10,10);
          text(img.get(i,j), 0,0);
          println("Pixel At Mouse: hue = " + currentPixel.getHue() + " sat = " + currentPixel.getSat() + " brightness = " + currentPixel.getBrightness() );
        }
      }
    }
    //returns the list of green pixels
    return greenPixels;
  }

<<<<<<< HEAD
  //Checks if a given pixel is green using RGB
  //Requires: 
        //Pixel p: Pixel to check
        //double threshold: Threshold to allow different sensitivity
   //Returns whether or not a pixel is green
=======
  //determines whether the pixel in question is green or not
  //uses RGB values
  //takes in a pixel and the threshold, returns a boolean
>>>>>>> origin/ColourSelectionOnAndroid
  protected boolean isGreen(Pixel p, double threshold) {
    //green must be the dominant colour and be greater or equal to 50
    if (p.getGreen() <= p.getRed() || p.getGreen() <= p.getBlue() || p.getGreen()<=50 ) {
      return false;
    }
    //println("__________________________________________");
    //println(red(c) + ", " + green(c) + ", " + blue(c));
    //println(rgb[0] + " " + rgb[1] + " " + rgb[2]);
    //println(rgb[1]/rgb[0] + ", " + rgb[1]/rgb[2]);
    //println(rgb[1]/rgb[0] >= threshold/100 && rgb[1]/rgb[2] >= threshold/100);
    //squares all the values and sees if the ratio of green to red and green to blue exceed the specified threshold
    return (p.getSquaredGreen()/p.getSquaredRed() >= threshold/100 && p.getSquaredGreen()/p.getSquaredBlue() >= threshold/100);
  }
<<<<<<< HEAD
    //Checks if a given pixel is green using HSB
  //Requires: 
        //Pixel p: Pixel to check
        //double idealHue:Preffered val to look for
        //double idealSat:Preffered val to look for
        //double idealBrightness:Preffered val to look for
   //Returns whether or not a pixel is green
=======
  
  //determines whether the pixel in question is green or not
  //uses HSV values
  //takes in the pixel and idea properties of the pixel
>>>>>>> origin/ColourSelectionOnAndroid
  protected boolean isGreenHSB(Pixel p, float idealHue, float idealSat, float idealBrightness) {
    //two different methods of determination
    //first method creates a trapezoid on the 2D colour grid of HSV using ideal hues and sees if the pixel is within that trapezoid
    if (VisionProcessor.detectionType == 0) {
      //final float PURE_GREEN = 120;
      //final float IDEAL_GREEN = 170;
      //Hue between 100 and 140
      //calculations to determine the two diagonal lines of the trapezoid
      //calculates two lines using the coordinates based on the ideal hue and saturation
      PVector pointA = new PVector(idealHue-hueThreshold, 0.0);
      PVector pointB = new PVector(idealHue, 100-SAT);
      PVector pointC = new PVector(idealHue+hueThreshold, 0.0);
      
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
      //compares the pixel's hue with the trapezoid's area
      //also does comparisions of the pixel's saturation and brightness to see if they exceed the minimum values
      return (p.getSaturation() > idealSat - satThreshold  
            && p.getSat() <  (slopeL*p.getHue()) + yIntL//Sat 75
            && p.getSat() < (slopeR*p.getHue()) + yIntR
            && p.getBrightness() > idealBrightness - brightnessThreshold);
    }
    
    //detection type = 1
    //only runs if detection type != 0
    //brightness check may not be needed
    //does basic checks that consist of whether the pixel's colour values are within the ideal values + or - the threshold
    return (p.getHue() < idealHue + hueThreshold && p.getHue() > idealHue - hueThreshold 
           && p.getSaturation() < idealSat + satThreshold && p.getSaturation() > idealSat - satThreshold
           && p.getBrightness() < idealBrightness + brightnessThreshold && p.getBrightness() > idealBrightness - brightnessThreshold);
  }

}