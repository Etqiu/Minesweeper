import de.bezier.guido.*;
int NUM_ROWS = 20;
int NUM_COLS = 20;
int NUM_MINES = 40;
int numFlagged;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>();//ArrayList of just the minesweeper buttons that are mined

void setup ()
{
  size(700, 700);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r<NUM_ROWS; r++) {
    for (int c = 0; c<NUM_COLS; c++) {
      buttons[r][c]= new MSButton(r, c);
    }
  }


  setMines();
}
public void setMines()
{
  while (mines.size()< NUM_MINES) {

    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if (!mines.contains(buttons[r][c])) {
      mines.add(buttons[r][c]);
     
    }
  }
}

public void draw ()
{
  background( 0 );
  if (isWon() == true){
    displayWinningMessage();
    //noLoop(); completely broken on github
  }
}
public boolean isWon()
{

  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
   
        if (buttons[r][c].clicked == true) {
          if(mines.size() == numFlagged){
          return true;
          }
        }
      }
    }
  
  return false;
}
public void displayLosingMessage()
{  
 
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_ROWS; c++) {
      buttons[r][c].setLabel("");
      fill(255);
    }
  }
  for (int r = 0; r<NUM_ROWS; r++) {
    for (int c = 0; c<NUM_COLS; c++) {
      buttons[r][c].clicked = true;
      buttons[r][c].flagged = false;
    }
  }
  // NOTE to self, PLEASE MAKE THE TIMER WHEN YOU *FIRST CLICK *
  if (millis() > 60000) { //if you lose after 60 seconds
    buttons[10][6].setLabel("Y");
    buttons[10][7].setLabel("O");
    buttons[10][8].setLabel("U");
    buttons[10][9].setLabel("");
    buttons[10][10].setLabel("L");
    buttons[10][11].setLabel("O");
    buttons[10][12].setLabel("S");
    buttons[10][13].setLabel("T");
  } else { // lose before 60 seconds -_-
    buttons[10][6].setLabel("S");
    buttons[10][7].setLabel("O");
    buttons[10][8].setLabel("");
    buttons[10][9].setLabel("B");
    buttons[10][10].setLabel("A");
    buttons[10][11].setLabel("D");
    buttons[10][12].setLabel("!");
    buttons[10][13].setLabel("!");
  }

}
public void displayTimer(){
  //no timer 
}
public void displayWinningMessage()
{
    for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_ROWS; c++) {
      buttons[r][c].setLabel("");
      fill(255);
    }
  }
  if (millis() > 100000) { // spent 100 sec or more on this
    buttons[10][6].setLabel("Y");
    buttons[10][7].setLabel("O");
    buttons[10][8].setLabel("U");
    buttons[10][9].setLabel("");
    buttons[10][10].setLabel("W");
    buttons[10][11].setLabel("O");
    buttons[10][12].setLabel("N");
    buttons[10][13].setLabel("!");
  }
  if (millis()<60000 && millis() > 40000) { // 60 sec to solve
    buttons[10][6].setLabel("");
    buttons[10][7].setLabel("S");
    buttons[10][8].setLabel("K");
    buttons[10][9].setLabel("I");
    buttons[10][10].setLabel("L");
    buttons[10][11].setLabel("L");
    buttons[10][12].setLabel("E");
    buttons[10][13].setLabel("D");
  }
  if (millis() < 40000) { // using hacks bruh
   
    buttons[10][6].setLabel("H");
    buttons[10][7].setLabel("A");
    buttons[10][8].setLabel("C");
    buttons[10][9].setLabel("K");
    buttons[10][10].setLabel("E");
    buttons[10][11].setLabel("R");
    buttons[10][12].setLabel("?");
    buttons[10][13].setLabel("!");
  }
  
}
public boolean isValid(int r, int c)
{
  if (r>NUM_ROWS-1 || r<0) {
    return false;
  }
  if (c>NUM_COLS-1 || c<0) {
    return false;
  }
  return true;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  for (int r = row - 1; r <= row + 1; r++)
    for (int c = col - 1; c <= col + 1; c++)
      if (isValid(r, c) && mines.contains(buttons[r][c]))
        numMines++;
  if (mines.contains(buttons[row][col]))
    numMines--;
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;
  

  public MSButton ( int row, int col )
  {
 
    width = 700/NUM_COLS;
    height = 700/NUM_ROWS;
    myRow = row;
    myCol = col;
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed ()
  {
    if(mouseButton == LEFT && !flagged)
      clicked = true;
    if (mouseButton == RIGHT && !clicked) {
      
      flagged = !flagged;
      
       if(flagged == true){
         numFlagged++;
       }
      if (flagged == false) {
        numFlagged--;
        clicked = false;
      }
    } else if (mines.contains(this)) {
      displayLosingMessage();
      //noLoop();
    } else if (countMines(myRow, myCol) > 0) {
      setLabel(countMines(myRow, myCol));
    } else {
      for (int r = myRow - 1; r <= myRow + 1; r++) {
        for (int c = myCol - 1; c <= myCol + 1; c++) {
          if (isValid(r, c)&& buttons[r][c].clicked == false ) {
            buttons[r][c].mousePressed();
          }
        }
      }
    }
  }
  public void draw ()
  {    
    if (flagged)
      fill(0,0,150);
    else if (clicked && mines.contains(this) )
      fill(255, 0, 0);
    else if (clicked)
      fill(217, 163, 130 );
    else
      fill(106, 201, 105);
   strokeWeight(3);
   stroke(217, 163, 130);
    rect(x, y, width, height,3);
    fill(0);
   
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
  public boolean getClicked(){
    return clicked;
  }
}
