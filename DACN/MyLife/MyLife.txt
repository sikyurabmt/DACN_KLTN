#include <AFMotor.h>
#include <Servo.h>
#include <NewPing.h>

#define TRIGGER_PIN     11
#define ECHO_PIN        3
#define SERVO_PIN       10

//CONST VALUE
#define MAX_DISTANCE    100
#define ROTATE_DEFAULT  90
#define ROTATE_MIN      36
#define ROTATE_MAX      144
#define ROTATE_OFFSET   2

#define MAX_SPEED       120
#define TURN_SPEED      210
#define COLL_DIST       20

NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE);
Servo myServo;

AF_DCMotor leftMotor(3, MOTOR12_8KHZ);
AF_DCMotor rightMotor(4, MOTOR12_8KHZ);

int pos       = 0;
int maxLeft   = 0;
int maxRight  = 0;
int maxFront  = 0;
int curDist   = 0;

void setup() {
  Serial.begin(9600);
  myServo.attach(SERVO_PIN);
  myServo.write(ROTATE_DEFAULT);
  delay(2000);
  moveForward();
}

void loop() {
  curDist = getDistance();
  Serial.println(curDist);
  if (curDist < COLL_DIST && curDist > 0) {
    moveBackward();
    delay(800);
    moveStop();
    selectPath();
    moveForward();
  }
}

void moveForward() {
  leftMotor.run(FORWARD);
  rightMotor.run(FORWARD);
  leftMotor.setSpeed(MAX_SPEED);
  rightMotor.setSpeed(MAX_SPEED);
}

void moveBackward() {
  leftMotor.run(BACKWARD);
  rightMotor.run(BACKWARD);
  leftMotor.setSpeed(MAX_SPEED);
  rightMotor.setSpeed(MAX_SPEED);
}

void moveStop() {
  leftMotor.run(RELEASE);
  rightMotor.run(RELEASE);
}

void turnRight() {
  leftMotor.run(FORWARD);
  rightMotor.run(BACKWARD);
  leftMotor.setSpeed(TURN_SPEED);
  rightMotor.setSpeed(TURN_SPEED);
  delay(1000);
}

void turnLeft() {
  leftMotor.run(BACKWARD);
  rightMotor.run(FORWARD);
  leftMotor.setSpeed(TURN_SPEED);
  rightMotor.setSpeed(TURN_SPEED);
  delay(1000);
}

void checkPath()
{
  for (pos = ROTATE_DEFAULT; pos >= ROTATE_MIN; pos -= ROTATE_OFFSET)
  {
    myServo.write(pos);
    caculateValue();
    delay(10);
  }
  for (pos = ROTATE_MIN; pos <= ROTATE_MAX; pos += ROTATE_OFFSET)
  {
    myServo.write(pos);
    caculateValue();
    delay(10);
  }
  for (pos = ROTATE_MAX; pos >= ROTATE_DEFAULT; pos -= ROTATE_OFFSET)
  {
    myServo.write(pos);
    caculateValue();
    delay(10);
  }
}

void selectPath()
{
  maxLeft   = 0;
  maxRight  = 0;
  maxFront  = 0;
  checkPath();
  if (maxLeft == 0)
  {
    turnLeft();
    return;
  }
  if (maxRight == 0)
  {
    turnRight();
    return;
  }
  if (maxLeft >= maxRight)
    turnLeft();
  else
    turnRight();
}

int getDistance()
{
  return sonar.ping_cm();
}

void caculateValue()
{
  int distance = getDistance();
  //  Serial.print(pos);
  //  Serial.print(" : ");
  //  Serial.println(distance);
  //Left
  if (typeOfPos() == 1)
  {
    if (distance > 0 && distance > maxLeft)
    {
      maxLeft = distance;
    }
  }
  //Front
  if (typeOfPos() == 2)
  {
    if (distance > 0 && distance > maxFront)
    {
      maxFront = distance;
    }
  }
  //Right
  if (typeOfPos() == 3)
  {
    if (distance > 0 && distance > maxRight)
    {
      maxRight = distance;
    }
  }
}

//Return value: Left 1, Front 2, Right 3, Default 0
int typeOfPos()
{
  if (pos <= ROTATE_MAX && pos >= ROTATE_MAX - (ROTATE_MAX - ROTATE_MIN) / 3)
  {
    return 1;
  }
  if (pos < ROTATE_MAX - (ROTATE_MAX - ROTATE_MIN) / 3 && pos > ROTATE_MIN + (ROTATE_MAX - ROTATE_MIN) / 3)
  {
    return 2;
  }
  if (pos <= ROTATE_MIN + (ROTATE_MAX - ROTATE_MIN) / 3 && pos >= ROTATE_MIN)
  {
    return 3;
  }
  return 0;
}
