#include <IRremote.h> // thư viện hỗ trợ IR remote

const int receiverPin = 8; // chân digital 8 dùng để đọc tín hiệu
IRrecv irrecv(receiverPin); // tạo đối tượng IRrecv mới
decode_results results;// lưu giữ kết quả giải mã tín hiệu

const int LED1 = 13;

void setup()

{
  Serial.begin(9600);// serial
  irrecv.enableIRIn(); // start the IR receiver

  pinMode(LED1, OUTPUT); //Tất cả các chân LED là OUTPUT
  digitalWrite(LED1, LOW); //Mặc định các đèn LED tắt
}
// translate IR signals
void translateIR()
{
  switch (results.value)
  {
    case 0xFF6897://phim so 1
      digitalWrite(LED1, HIGH);
      break;
    case 0xFF9867://phim so 2
      digitalWrite(LED1, LOW);
      break;
  }
}

void loop()

{
  if (irrecv.decode(&results)) // nếu nhận được tín hiệu
  {
    translateIR();
    Serial.println(results.value, HEX);
    delay(200);
    irrecv.resume(); // nhận giá trị tiếp theo
  }
}

