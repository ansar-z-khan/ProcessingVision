//this class processes the blob objects
class BlobProcessor {
  //list of all the current blobs
  private ArrayList<Blob> blobs;
  //maximum distance between different blobs to be considered the same blob
  private final float MAX_DISTANCE = pixelsToSkip * 3;
  //minimum density of a blob
  private final float MIN_DENSITY = 0.0;
  //minimum area of a blob
  private final float MIN_AREA = 80;
  //private final float MERGE_DIST = 0;

  //constructor for the class
  //takes in a list of all the blobs
  BlobProcessor(ArrayList<Blob> _blobs) {
    blobs = _blobs;
  }
  
  //main function called from outside the class, calls other private functions within this class
  void process() {
    mergeAll();
    checkDensity();
    checkArea();
    deleteAll();
  }

  //checks each blob to see if the blob's density is high enough
  private void checkDensity() {
    for (Blob b : blobs) {
      if (b.density < MIN_DENSITY) {
        //If density is too low, set the blob to be deleted
        b.setDeleted();
      }
    }
  }
  
  
  private void checkArea() {
    for (Blob b : blobs) {
      if (b.area < MIN_AREA) {//If area is too low delete blob
        b.setDeleted();
      }
    }
  }

  //checks all the blobs and sees if they should be merged
  private void mergeAll() {
    //only runs if there is two or more blobs
    if (blobs.size()>1) {
      //println("Calling merge all at " + blobs.size() + " blobs");
      //delay(500);
      //recursive call to do checks
      merge(blobs.size()-2, blobs.size()-1);
    }
  }


  //deletes the blobs that are merged into another blob
  private void deleteAll() {
    /*
    int blobSize = blobs.size(); 
     for(int i = 0; i < blobSize; i++){
     if (blobs.get(i).getDeleted()) {
     blobs.remove(i);
     blobSize--;
     println ("Deleted Blobs");
     }
     }*/
    /*
    fill(255, 0, 0);
     for (Blob b : blobs) {
     b.show(255, 0, 0);
     //println (b.pixels.size() + ", " + greenPixels.size());
     //b.clear();
     }
     noFill();
     println("before delete");
     delay(500);
     */
    
     //deletes all the blobs that are set to be deleted
    for (int i = blobs.size()-1; i >= 0; i--) {
      if (blobs.get(i).getDeleted()) {
        blobs.remove(i);
        //blobSize--;
        //println ("Deleted Blobs");
        //delay(500);
      }
    }
    
    /*
    for (Blob b : blobs) {
     b.show(0, 255, 0);
     //println (b.pixels.size() + ", " + greenPixels.size());
     //b.clear();
     }
     println("after delete");
     delay(500);
     */
    //println("blobs after delete = " + blobs.size() );
  }

  //combines the two blobs together
  private void combine(Blob a, Blob b) {
    //a.show(true);
    //b.show(true);
    //println("before merge");
    //delay(1000);
    //adds all of the pixels into the second blob
    for (Pixel p : a.pixels) {
      //if (!b.pixels.contains(p)) {
      b.addToBlob(p);
      //}
    }
    /*
    for (int i = 0; i < a.pixels.size(); i++) {
     b.pixels.add(a.pixels.get(i) );
     }*/
    //removing
    //println ("Copied Pixels");
    //delay(1000);
    //a.show(true);
    //b.show(true);
    //delay(1000);
    //blobs.remove(a);
    
    //set the first blob to be deleted
    //cannot delete it instantly to prevent index out of bounds
    a.setDeleted();
  }

  //main recursive call that determines if the blobs should be merged or not
  //takes in the two blobs to be tested
  private void merge(int a, int b) {
    //println(a + " " + b);
    //get the blobs according to their index on the arraylist of blobs
    Blob blobA = blobs.get(a);
    Blob blobB = blobs.get(b);
    
    //if bother blobs are not set to be deleted
    if ((!blobA.getDeleted()) && (!blobB.getDeleted())) {
      //calls overlapping function to return true or false
      if (overlapping(blobA, blobB)) {
        //if true, then combine the blobs
        combine(blobA, blobB);
      }
    }

    //stops the recursive call if there is no more blobs to be tested
    if (b <= 1 && a <= 0) {
      return;
    }
    
    //calls the function again but with other blobs
    if (a == 0) {
      //println("case 1 " + a + " " + b);
      merge(b-2, b-1);
    } else {
      //println("case 2 = " + a + " " + b);
      merge(a-1, b);
    }
  }

  //determines if the blobs should be considered one blob or two
  //takes in the two blobs and returns a boolean
  private boolean overlapping(Blob a, Blob b) {
    //sets min and max bounds for each blob
    PVector minA = a.minBounds;
    PVector minB = b.minBounds;
    PVector maxA = a.maxBounds;
    PVector maxB = b.maxBounds;
    //boolean isOverlapping = false;

    //creates two larger rectangles around each blob and sees if they overlap
    //returns the outcome
    return ((minA.x-MAX_DISTANCE <= minB.x && minB.x <= maxA.x+MAX_DISTANCE ||
      minA.x-MAX_DISTANCE <= maxB.x && maxB.x <= maxA.x+MAX_DISTANCE) &&
      (minA.y-MAX_DISTANCE <= minB.y && minB.y <= maxA.y+MAX_DISTANCE ||
      minA.y-MAX_DISTANCE <= maxB.y && maxB.y <= maxA.y+MAX_DISTANCE));
  }
  
  //sorts all the blobs by area
  //unfinished...
  private void sortByArea(){
    
   for(int i = 0; i<blobs.size();i++){
     //unfinished
   }
  }
  
  //returns the blobs that represent the real object
  ArrayList<Blob> getRealBlobs(){
      ArrayList<Blob> blobs = new ArrayList<Blob>();
      return blobs;
  } 

}