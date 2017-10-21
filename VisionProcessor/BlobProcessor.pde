
class BlobProcessor {
  private ArrayList<Blob> blobs;
  private final float MAX_DISTANCE = 6;
  private final float MIN_DENSITY = 50.0;
  private final float MIN_AREA = 2;  //initially 20
  //private final float MERGE_DIST = 0;

  BlobProcessor(ArrayList<Blob> _blobs) {
    blobs = _blobs;
  }
  void process() {//Main function called from the outside, responsible for all of the processing
    mergeAll();
    //checkDensity();
    checkArea();
    deleteAll();
  }

  private void checkDensity() {
    for (Blob b : blobs) {
      if (b.density < MIN_DENSITY) {//If density is too low delete blob
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

  private void mergeAll() {
    if (blobs.size()>1) {
      //println("Calling merge all at " + blobs.size() + " blobs");
      //delay(500);
      merge(blobs.size()-2, blobs.size()-1);
    }
  }



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


  private void combine(Blob a, Blob b) {
    //a.show(true);
    //b.show(true);
    //println("before merge");
    //delay(1000);
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
    a.setDeleted();
  }

  private void merge(int a, int b) {
    //println(a + " " + b);
    Blob blobA = blobs.get(a);//get the blobs
    Blob blobB = blobs.get(b);
    if ((!blobA.getDeleted()) && (!blobB.getDeleted())) {
      if (overlapping(blobA, blobB)) {
        combine(blobA, blobB);
      }
    }

    if (b <= 1 && a <= 0) {
      return;
    }
    if (a == 0) {
      //println("case 1 " + a + " " + b);
      merge(b-2, b-1);
    } else {
      //println("case 2 = " + a + " " + b);
      merge(a-1, b);
    }
  }

  private boolean overlapping(Blob a, Blob b) {
    PVector minA = a.minBounds;
    PVector minB = b.minBounds;
    PVector maxA = a.maxBounds;
    PVector maxB = b.maxBounds;
    //boolean isOverlapping = false;


    return ((minA.x-MAX_DISTANCE <= minB.x && minB.x <= maxA.x+MAX_DISTANCE ||
      minA.x-MAX_DISTANCE <= maxB.x && maxB.x <= maxA.x+MAX_DISTANCE) &&
      (minA.y-MAX_DISTANCE <= minB.y && minB.y <= maxA.y+MAX_DISTANCE ||
      minA.y-MAX_DISTANCE <= maxB.y && maxB.y <= maxA.y+MAX_DISTANCE));
  }
  private void sortByArea(){
    
   for(int i = 0; i<blobs.size();i++){
     
   }
  }
  ArrayList<Blob> getRealBlobs(){
      ArrayList<Blob> blobs = new ArrayList<Blob>();
      return blobs;
  }
  
  
  
  
}