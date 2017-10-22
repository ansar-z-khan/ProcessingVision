class ColourSelector {
  PVector buttonPos;
  PVector buttonSize;
  boolean pressingDown;


  ColourSelector() {
    buttonSize = new PVector(800, 300);
    buttonPos = new PVector(width/2-(buttonSize.x/2), height*0.80);
  }
  void drawButton() {
    stroke(0, 255, 0);
    if (pressingDown) {
      fill(19, 134, 84);
    } else {
      fill(19, 134, 84, 150);
    }
    rect(buttonPos.x, buttonPos.y, buttonPos.x+buttonSize.x, buttonPos.y+buttonSize.y, 60);
    fill(243, 216, 58);
    textSize(buttonSize.y*0.65);
    text("Proceed", buttonPos.x+35, buttonPos.y+buttonSize.y*0.75);
  }
  void updateButton() {
    if (mousePressed) {
      if (mouseX>buttonPos.x && mouseX < buttonPos.x + buttonSize.x
        && mouseY > buttonPos.y && mouseY < buttonPos.y+buttonSize.y ) {
        pressingDown  =true;
      }
    }

  }

}

void changeState(){

     step++;
}

void mouseReleased(){
    changeState();
 }
  