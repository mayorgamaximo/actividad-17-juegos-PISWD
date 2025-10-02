import processing.sound.*;

PVector ballPos, ballSpeed;
float ballRadius = 10;

PVector paddle1Pos, paddle2Pos;
float paddleWidth = 10, paddleHeight = 60, paddleSpeed = 10;

int score1 = 0;
int score2 = 0;
boolean gameOver = false;

SoundFile hitSound;

void setup() {
  size(800, 400, P3D);
  resetPositions();
  
  // Cargar sonido
  hitSound = new SoundFile(this, "hit.mp3");
}

void draw() {
  background(0);
  lights();
  
  if (!gameOver) {
    moveBall();
    movePaddles();
    checkCollision();
  }
  
  drawBall();
  drawPaddles();
  drawScore();
  
  checkWinner();
}

void resetPositions() {
  ballPos = new PVector(width / 2, height / 2, 0);
  ballSpeed = new PVector(8, 10, 0);
  
  paddle1Pos = new PVector(10, height / 2 - paddleHeight / 2, 0);
  paddle2Pos = new PVector(width - 20, height / 2 - paddleHeight / 2, 0);
}

void moveBall() {
  ballPos.add(ballSpeed);
  
  // Rebote superior e inferior
  if (ballPos.y - ballRadius < 0 || ballPos.y + ballRadius > height) {
    ballSpeed.y *= -1;
  }
  
  // Punto jugador 2
  if (ballPos.x - ballRadius < 0) {
    score2++;
    resetBall();
  }
  
  // Punto jugador 1
  if (ballPos.x + ballRadius > width) {
    score1++;
    resetBall();
  }
}

void resetBall() {
  ballPos.set(width/2, height/2, 0);
  ballSpeed.x *= -1;
  ballSpeed.y = random(2, 4) * (random(1) > 0.5 ? 1 : -1);
}

void movePaddles() {
  // Jugador 1: W/S
  if (keyPressed) {
    if (key == 'w' || key == 'W') paddle1Pos.y -= paddleSpeed;
    if (key == 's' || key == 'S') paddle1Pos.y += paddleSpeed;
  }
  paddle1Pos.y = constrain(paddle1Pos.y, 0, height - paddleHeight);
  
  // Jugador 2: Flechas
  if (keyPressed) {
    if (keyCode == UP) paddle2Pos.y -= paddleSpeed;
    if (keyCode == DOWN) paddle2Pos.y += paddleSpeed;
  }
  paddle2Pos.y = constrain(paddle2Pos.y, 0, height - paddleHeight);
}

void checkCollision() {
  // Paleta izquierda
  if (ballPos.x - ballRadius < paddle1Pos.x + paddleWidth &&
      ballPos.y > paddle1Pos.y &&
      ballPos.y < paddle1Pos.y + paddleHeight) {
    ballSpeed.x *= -1;
    hitSound.play();
  }
  
  // Paleta derecha
  if (ballPos.x + ballRadius > paddle2Pos.x &&
      ballPos.y > paddle2Pos.y &&
      ballPos.y < paddle2Pos.y + paddleHeight) {
    ballSpeed.x *= -1;
    hitSound.play();
  }
}

void drawBall() {
  pushMatrix();
  translate(ballPos.x, ballPos.y, ballPos.z);
  fill(255);
  noStroke();
  sphere(ballRadius);
  popMatrix();
}

void drawPaddles() {
  fill(255);
  noStroke();
  
  pushMatrix();
  translate(paddle1Pos.x + paddleWidth/2, paddle1Pos.y + paddleHeight/2, 0);
  box(paddleWidth, paddleHeight, 10);
  popMatrix();
  
  pushMatrix();
  translate(paddle2Pos.x + paddleWidth/2, paddle2Pos.y + paddleHeight/2, 0);
  box(paddleWidth, paddleHeight, 10);
  popMatrix();
}

void drawScore() {
  camera(); // Reset cámara para 2D overlay
  fill(255);
  textSize(32);
  textAlign(CENTER, TOP);
  text(score1, width/4, 20);
  text(score2, 3*width/4, 20);
}

void checkWinner() {
  if (score1 >= 5) {
    gameOver = true;
    displayWinner("Jugador 1 gana!");
  } else if (score2 >= 5) {
    gameOver = true;
    displayWinner("Jugador 2 gana!");
  }
}

void displayWinner(String msg) {
  camera();
  fill(255);
  textSize(48);
  textAlign(CENTER, CENTER);
  text(msg, width/2, height/2);
}
