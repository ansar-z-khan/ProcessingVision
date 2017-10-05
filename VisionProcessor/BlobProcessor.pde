import java.util.*;

class BlobProcessor {

  private ArrayList<Blob> blobs;
  private final float MAX_DISTANCE = 6;
  private final float MIN_DENSITY = 0.2;
  private final float MIN_AREA = 15;
  private final float MERGE_DIST = 0;

  BlobProcessor(ArrayList<Blob> _blobs) {
    blobs = _blobs;
  }

  void mergeAll() {
    if (blobs.size()>1) {
      println("Calling merge all at " + blobs.size());
      merge(blobs.size()-2, blobs.size()-1);
    }
  }

  void deleteAll(){
    int blobSize = blobs.size(); 
    for(int i = 0; i < blobSize; i++){
      if (blobs.get(i).getDeleted()) {
        blobs.remove(i);
        blobSize--;
        println ("Deleted Blobs");
        
      }
    }
  }


  void combine(Blob a, Blob b) {
    for (Pixel p : a.pixels) {
      //if (!b.pixels.contains(p)) {
        b.pixels.add(p);
      //}
    }
    //removing
    println ("Copied Pixels");
    //blobs.remove(a);
    a.setDeleted();
  }

  void merge(int a, int b) {
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

  boolean overlapping(Blob a, Blob b) {
    PVector minA = a.minBounds;
    PVector minB = b.minBounds;
    PVector maxA = a.maxBounds;
    PVector maxB = b.maxBounds;
    boolean isOverlapping = false;
      
     
    return ((minA.x-MERGE_DIST <= minB.x && minB.x <= maxA.x+MERGE_DIST ||
      minA.x-MERGE_DIST <= maxB.x && maxB.x <= maxA.x+MERGE_DIST) &&
      (minA.y-MERGE_DIST <= minB.y && minB.y <= maxA.y+MERGE_DIST ||
      minA.y-MERGE_DIST <= maxB.y && maxB.y <= maxA.y+MERGE_DIST));

    //}
  }
}