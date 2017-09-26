class Blob {

  ArrayList <Pixel> pixels = new ArrayList<Pixel>();
  PVector size;
  PVector center;
  private PVector minBounds;
  private PVector maxBounds;
  float density;


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

    return (minBounds.x-( (size.x/5)+5) <= p.pos.x && 
      p.pos.x <= maxBounds.x+( (size.x/5)+5) && 
      minBounds.y-( (size.y/5)+5) <= p.pos.y && 
      p.pos.y <= maxBounds.y+( (size.y/5+5) ) );
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
    density = ((pixels.size()*(2*pixelsToSkip)) / (size.x * size.y));
    println("Area: " + size.x * size.y +", Pixel Length: "+ pixels.size() + ", Density: " + density);
  }

  void addToBlob(Pixel p) {
    if (this.contains(p)) {
      return;
    }
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
    updateSize();
  }

  void show() {
    //Pixel topLeft = pixels.get(0);
    //Pixel bottomRight = pixels.get(pixels.size()-1);
    fill(255 - (255*density));
    //noFill();
    rect(minBounds.x, minBounds.y, maxBounds.x, maxBounds.y);
  }

  void update() {
    updateSize();
  }
}