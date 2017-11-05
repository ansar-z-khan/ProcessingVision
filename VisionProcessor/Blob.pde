//this class creates the blobs that store information about the blob
class Blob {
  //stores all the pixels that are a part of this blob
  ArrayList <Pixel> pixels = new ArrayList<Pixel>();
  //size of the blob
  PVector size;
  //the blob's center location
  PVector center;
  //used to delete blobs when merging two blobs
  private boolean deleted = false;
  //coordinates of the top left and bottom right corner
  //used to draw the rectangle
  private PVector minBounds;
  private PVector maxBounds;
  //pixel density of the blob
  private float density;
  //area of the blob
  private float area;
  //the maximum distance of the pixel in question to be still considered a part of the blob
  //used to determine if the pixel is part of a new blob or this blob
  private final int TOLERANCE = int (pixelsToSkip * 2);

  //constructor for blobs
  //pass in the initial pixel of the blob
  Blob(Pixel p) {
    //add given pixel into the array of pixels in this blob
    pixels.add(p);
    //sets initial values of the blob, given that there is only one pixel
    center = pixels.get(pixels.size()/2).pos;
    minBounds = new PVector(p.pos.x, p.pos.y);
    maxBounds = new PVector(p.pos.x, p.pos.y);
    size = new PVector(1, 1);
  }


  //method determines if the pixel in question is a part of this blob or not
  //takes in a pixel and returns a boolean
  boolean isPartOf (Pixel p) {

    //if (this.contains(p)) {
    //return false;
    //}
    //Pixel topLeft = pixels.get(0);
    //Pixel bottomRight = pixels.get(pixels.size()-1);
    //double dist = dist(center.x, center.y, p.pos.x, p.pos.y);
    //println("dist = " + dist + " top left = " + topLeft.pos + " bottom right = " + bottomRight.pos);
    //return dist <  5 * ((dist(bottomRight.pos.x,bottomRight.pos.y, topLeft.pos.x, topLeft.pos.y)));
    //return dist<60;

    //updateSize();
    //int errorRange = 5;
    
    //creates a larger rectangle around the edges of the blob and sees if the pixel is within that rectangle
    return (minBounds.x-(TOLERANCE) <= p.pos.x && 
      p.pos.x <= maxBounds.x+(TOLERANCE) && 
      minBounds.y-(TOLERANCE) <= p.pos.y && 
      p.pos.y <= maxBounds.y+(TOLERANCE));

    /*  return (minBounds.x-( (size.x/5)+5) <= p.pos.x && 
     p.pos.x <= maxBounds.x+( (size.x/5)+5) && 
     minBounds.y-( (size.y/5)+5) <= p.pos.y && 
     p.pos.y <= maxBounds.y+( (size.y/5+5) ) );
     */
  }

  //method to see if the pixel in question is already contained within the blob
  //takes in a pixel and returns a booelan
  boolean contains(Pixel p) {
    return pixels.contains(p);
  }
  
  //clears all pixels in the blob
  void clear() {
    pixels.clear();
  }
  
  //updates the size of the blob
  private void updateSize() {
    //Pixel topLeft = pixels.get(0);
    //Pixel bottomRight = pixels.get(pixels.size()-1);

    //size.x = bottomRight.pos.x - topLeft.pos.x;
    //size.y = bottomRight.pos.y - topLeft.pos.y;
    
    //calculations for size based on top left and bottom right corner
    size.x = maxBounds.x - minBounds.x;
    size.y = maxBounds.y - minBounds.y;

    //println("Area: " + size.x * size.y +", Pixel Length: "+ pixels.size() + ", Density: " + density);
  }

  //updates the pixel density of the blob
  void updateDensity() {
    //calculations done by dividing the amount of pixels in the blob by the area of the blob
    area = size.x * size.y;
    density = ((pixels.size()*(2*pixelsToSkip)) / (area));
  }

  //adds the pixel to the blob
  //takes in the pixel that is to be added
  void addToBlob(Pixel p) {
    //may not be needed
    //if (this.contains(p)) {
    //return;
    //}
    
    //adds into the pixel array of the blob
    pixels.add(p);
    //updates the center of the blob due to the added pixel
    center = pixels.get(pixels.size()/2).pos;

    //updates the min and max bounds by seeing if the new pixel is outside any of these bounds
    if (p.pos.x < minBounds.x) {
      minBounds.x = p.pos.x;
    }
    if (p.pos.y < minBounds.y) {
      minBounds.y = p.pos.y;
    }
    if (p.pos.x > maxBounds.x) {
      maxBounds.x = p.pos.x;
    }
    if (p.pos.y > maxBounds.y) {
      maxBounds.y = p.pos.y;
    }
    //calls update function to update other properties of the blob
    update();
  }

  //this method draws the rectange around the blob
  void show() {
    //Pixel topLeft = pixels.get(0);
    //Pixel bottomRight = pixels.get(pixels.size()-1);
    // fill(255 - (255*density));
    noFill();
    stroke(0);
    if (VisionProcessor.runType == RunType.PC) {
      //Pixel topLeft = pixels.get(0);
      //Pixel bottomRight = pixels.get(pixels.size()-1);
      // fill(255 - (255*density));
      //draws a rectangle on the blank screen and on top of the camara image
      rect(minBounds.x, minBounds.y, maxBounds.x, maxBounds.y);
      rect(minBounds.x + width/2, minBounds.y, maxBounds.x + width/2, maxBounds.y);
    } else if (VisionProcessor.runType == RunType.ANDROID) {
      //unfinished...
      PVector shiftedMinPos = new PVector(minBounds.y + width/2 - capture.getCurrentImage().height/2, minBounds.x + height/2 - capture.getCurrentImage().width/2);
      PVector shiftedMaxPos = new PVector(maxBounds.y + width/2 - capture.getCurrentImage().height/2, maxBounds.x + height/2 - capture.getCurrentImage().width/2);
      pushMatrix();
      rectMode(CENTER);
      translate(((shiftedMinPos.x+getRealWidth()/2)), (shiftedMinPos.y+getRealHeight()/2));
      //rotate(HALF_PI);
      rect(0,0,getRealWidth(), getRealHeight());
      rectMode(CORNERS);
      //);
      popMatrix();
      //rect(shiftedMinPos.x, shiftedMinPos.y, shiftedMaxPos.x, shiftedMaxPos.y);
      text(getWidth() + "x" + getHeight(), 20, height*0.8);
      // rect(minBounds.x + width/2, minBounds.y, maxBounds.x + width/2, maxBounds.y);
    }
  }
  
  //overload of previous function for debug purposes
  //makes the rectangles different colours to differentiate different blobs
  void show(int red, int green, int blue) {
    //Pixel topLeft = pixels.get(0);
    //Pixel bottomRight = pixels.get(pixels.size()-1);
    // fill(255 - (255*density));
    //noFill();
    stroke(red, green, blue);
    rect(minBounds.x, minBounds.y, maxBounds.x, maxBounds.y);
    rect(minBounds.x + width/2, minBounds.y, maxBounds.x + width/2, maxBounds.y);
    stroke(0);
  }

  //returns the width of the rect
  float getWidth() {
    return maxBounds.x - minBounds.x;
  }
  //returns the height of the rect
  float getHeight() {
    return maxBounds.y - minBounds.y;
  }
  
  //the image on the android cam is rotated so the width and height must be switched
  float getRealWidth() {
    return maxBounds.y - minBounds.y;
  }
  float getRealHeight() {
    return maxBounds.x - minBounds.x;
  }

  //set the blob to be deleted
  void setDeleted() {
    deleted = true;
  }

  //returns whether the blob is set to be deleted
  boolean getDeleted() {
    return deleted;
  }

  //updates other properties of the blob
  void update() {
    updateSize();
    updateDensity();
  }
  
  //changes x and y coordinates
  //used in android mode due to the image being rotated
  PVector swapVector(PVector pos) {
    return new PVector(pos.y, pos.x);
  }
}