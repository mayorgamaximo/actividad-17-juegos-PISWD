int[][] board = new int[3][3];
boolean xTurn = true;
boolean gameEnded = false;
int winner = 0; // 0 = nadie, 1 = X, 2 = O, 3 = empate
int winX1, winY1, winX2, winY2;

void setup() {
  size(300, 340);
  resetGame();
}

void draw() {
  background(240, 248, 255); // azul muy claro
  drawBoard();
  checkWin();
  showStatus();
}

void drawBoard() {
  stroke(60);
  strokeWeight(4);
  for (int i = 1; i < 3; i++) {
    line(i * 100, 0, i * 100, 300);
    line(0, i * 100, 300, i * 100);
  }

  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (board[i][j] == 1) {
        drawX(i, j);
      } else if (board[i][j] == 2) {
        drawO(i, j);
      }
    }
  }

  // Línea ganadora
  if (gameEnded && winner != 3 && winner != 0) {
    stroke(200, 0, 0);
    strokeWeight(6);
    line(winX1, winY1, winX2, winY2);
    strokeWeight(1);
  }
}

void drawX(int i, int j) {
  stroke(220, 30, 30);
  strokeWeight(5);
  line(i * 100 + 15, j * 100 + 15, (i + 1) * 100 - 15, (j + 1) * 100 - 15);
  line(i * 100 + 15, (j + 1) * 100 - 15, (i + 1) * 100 - 15, j * 100 + 15);
  strokeWeight(1);
}

void drawO(int i, int j) {
  noFill();
  stroke(30, 60, 200);
  strokeWeight(5);
  ellipse(i * 100 + 50, j * 100 + 50, 70, 70);
  strokeWeight(1);
}

void mousePressed() {
  if (gameEnded) {
    resetGame(); 
    return;
  }
  int i = mouseX / 100;
  int j = mouseY / 100;
  if (i < 3 && j < 3 && board[i][j] == 0) {
    board[i][j] = xTurn ? 1 : 2;
    xTurn = !xTurn;
  }
}

void checkWin() {
  // Filas
  for (int j = 0; j < 3; j++) {
    if (board[0][j] != 0 && board[0][j] == board[1][j] && board[1][j] == board[2][j]) {
      winner = board[0][j];
      winX1 = 10; winY1 = j * 100 + 50;
      winX2 = 290; winY2 = j * 100 + 50;
      gameEnded = true;
    }
  }
  // Columnas
  for (int i = 0; i < 3; i++) {
    if (board[i][0] != 0 && board[i][0] == board[i][1] && board[i][1] == board[i][2]) {
      winner = board[i][0];
      winX1 = i * 100 + 50; winY1 = 10;
      winX2 = i * 100 + 50; winY2 = 290;
      gameEnded = true;
    }
  }
  // Diagonal principal
  if (board[0][0] != 0 && board[0][0] == board[1][1] && board[1][1] == board[2][2]) {
    winner = board[0][0];
    winX1 = 10; winY1 = 10;
    winX2 = 290; winY2 = 290;
    gameEnded = true;
  }
  // Diagonal secundaria
  if (board[2][0] != 0 && board[2][0] == board[1][1] && board[1][1] == board[0][2]) {
    winner = board[2][0];
    winX1 = 10; winY1 = 290;
    winX2 = 290; winY2 = 10;
    gameEnded = true;
  }
  // Empate
  if (!gameEnded) {
    boolean full = true;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == 0) full = false;
      }
    }
    if (full) {
      winner = 3;
      gameEnded = true;
    }
  }
}

void showStatus() {
  textAlign(CENTER);
  textSize(22);
  fill(20);
  if (gameEnded) {
    if (winner == 1) {
      fill(220, 30, 30);
      text("¡Ganó X!", width/2, 325);
    } else if (winner == 2) {
      fill(30, 60, 200);
      text("¡Ganó O!", width/2, 325);
    } else if (winner == 3) {
      fill(50);
      text("¡Empate!", width/2, 325);
    }
    textSize(14);
    fill(80);
    text("Clic para reiniciar", width/2, 20);
  } else {
    if (xTurn) {
      fill(220, 30, 30);
      text("Turno: X", width/2, 325);
    } else {
      fill(30, 60, 200);
      text("Turno: O", width/2, 325);
    }
  }
}

void resetGame() {
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      board[i][j] = 0;
    }
  }
  xTurn = true;
  gameEnded = false;
  winner = 0;
}
