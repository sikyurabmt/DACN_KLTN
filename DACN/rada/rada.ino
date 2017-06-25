// Sử dụng thư viện Servo
#include <Servo.h>
// Khai báo chân Trig và Echo
const int trigPin = 10;
const int echoPin = 11;
// Khai báo biến thời gian và khoảng cách
long duration;
int distance;
Servo myServo; // Tạo đối tượng Servo để điều khiển Servo
void setup() {
    pinMode(trigPin, OUTPUT); // Set chân trig là chân OUTPUT
    pinMode(echoPin, INPUT); // Set chân echo INPUT
    Serial.begin(9600);
    myServo.attach(12); // Chân Servo là chân 12
}
void loop() {
    // Quay Servo từ 15 độ - 165 độ
    for(int i=15;i<=165;i++){
        myServo.write(i);
        delay(30);
        distance = calculateDistance();// Gọi hàm tính khoảng cách
        Serial.print(i); // Gửi giá trị i ( góc quay của Servo) đến Serial Port
        Serial.print(","); // Gửi ","
        Serial.print(distance); // Tiếp theo gửi các giá trị khoảng cách tới Serial Port
        Serial.print("."); // Gửi dấu "."
    }
    // Sau khi quay xong Servo từ 15 - 165 độ....quay ngược lại từ 165 độ về 15 độ, sau đó gửi tương tự các giá trị như bên trên
    for(int i=165;i>15;i--){
        myServo.write(i);
        delay(30);
        distance = calculateDistance();
        Serial.print(i);
        Serial.print(",");
        Serial.print(distance);
        Serial.print(".");
    }
}
// Hàm tính khoảng cách bằng siêu âm
int calculateDistance(){
    digitalWrite(trigPin, LOW);
    delayMicroseconds(2);
    // Phát xung siêu âm với thời gian là 10 Micro giây
    digitalWrite(trigPin, HIGH);
    delayMicroseconds(10);
    digitalWrite(trigPin, LOW);// Ngưng phát xung
    duration = pulseIn(echoPin, HIGH); // Tính thời gian xung siêu âm phát ra đập vào vật cản rồi dội lại là bao nhiêu???
    distance= duration*0.034/2;// Tính khoảng cách từ siêu âm đến vật cản ( vì vận tốc của xung siêu âm là 344m/s...và sau khi đập vào vật cản rồi dội lại, nên /2) ==>> khoảng cách = thời gian*vận tốc/2
    return distance;
}
