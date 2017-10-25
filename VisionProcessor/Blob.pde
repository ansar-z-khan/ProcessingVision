class Blob {

  ArrayList <Pixel> pixels = new ArrayList<Pixel>();
  PVector size;
  PVector center;
  private boolean deleted = false;
  private PVector minBounds;
  private PVector maxBounds;
  private float density;
  private float area;

  private final int TOLERANCE = int (pixelsToSkip * 2);


  Blob(Pixel p) {
    pixels.add(p);
    center = pixels.get(pixels.size()/2).pos;
    minBounds = new PVector(p.pos.x, p.pos.y);
    maxBounds = new PVector(p.pos.x, p.pos.y);
    size = new PVector(1, 1);
  }



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

  boolean contains(Pixel p) {
    return pixels.contains(p);
  }
  void clear() {
    pixels.clear();
  }
  private void updateSize() {
    //Pixel topLeft = pixels.get(0);
    //Pixel bottomRight = pixels.get(pixels.size()-1);

    //size.x = bottomRight.pos.x - topLeft.pos.x;
    //size.y = bottomRight.pos.y - topLeft.pos.y;

    size.x = maxBounds.x - minBounds.x;
    size.y = maxBounds.y - minBounds.y;

    //println("Area: " + size.x * size.y +", Pixel Length: "+ pixels.size() + ", Density: " + density);
  }

  void updateDensity() {
    area = size.x * size.y;
    density = ((pixels.size()*(2*pixelsToSkip)) / (area));
  }

  void addToBlob(Pixel p) {
    //may not be needed
    //if (this.contains(p)) {
    //return;
    //}
    pixels.add(p);
    center = pixels.get(pixels.size()/2).pos;

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
    update();
  }

  void show() {
    //Pixel topLeft = pixels.get(0);
    //Pixel bottomRight = pixels.get(pixels.size()-1);
    // fill(255 - (255*density));
    noFill();
    stroke(0);
    
    PVector shiftedMinPos = new PVector(minBounds.x + width/2 - capture.getCurrentImage().width/2, minBounds.y + height/2 - capture.getCurrentImage().height/2);
    PVector shiftedMaxPos = new PVector(maxBounds.x + width/2 - capture.getCurrentImage().width/2, maxBounds.y + height/2 - capture.getCurrentImage().height/2);
    rect(shiftedMinPos.x, shiftedMinPos.y, shiftedMaxPos.x, shiftedMaxPos.y);
    text(getWidth() + "x" + getHeight(), 20, height*0.8);
   // rect(minBounds.x + width/2, minBounds.y, maxBounds.x + width/2, maxBounds.y);
  }
  ///DO NOT USE THIS
  void show(int red, int green, int blue) {
    //Pixel topLeft = pixels.get(0);
    //Pixel bottomRight = pixels.get(pixels.size()-1);
    // fill(255 - (255*density));
    //noFill();
    stroke(red, green, blue);
    ///DO NOT USE THIS
    PVector shiftedMinPos = new PVector(minBounds.x + width/2, minBounds.y + height/2);
    PVector shiftedMaxPos = new PVector(maxBounds.x + width/2, maxBounds.y + height/2);
    
    rect(shiftedMinPos.x, shiftedMinPos.y, shiftedMaxPos.x, shiftedMaxPos.y);
    stroke(0);
  }

  double getWidth() {
    return maxBounds.x - minBounds.x;
  }
  double getHeight() {
    return maxBounds.y - minBounds.y;
  }

  void setDeleted() {
    deleted = true;
  }

  boolean getDeleted() {
    return deleted;
  }

  void update() {
    updateSize();
    updateDensity();
    
  }

}