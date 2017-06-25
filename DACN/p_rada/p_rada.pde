import processing.serial.*; // Thư viện Serial
import java.awt.event.KeyEvent; // Thư viện đọc dữ liệu
import java.io.IOException;
Serial myPort; // Xác định đối tượng
 
// Khai báo các biến :v
String angle="";
String distance="";
String data="";
String noObject;
float pixsDistance;
int iAngle, iDistance;
int index1=0;
int index2=0;
PFont orcFont;
void setup() {
    size (1360, 768); // Thiết lập màn hình
    smooth();
    myPort = new Serial(this,"COM3", 9600); // Chọn giao tiếp cổng COM4, tốc độ 9600
    myPort.bufferUntil('.'); // Đọc dữ liệu từ cổng COM4...đến khi nhận đc dấu '.' thỳ dừng lại....!!!! ( Processing sẽ nhận đc giá trị như phần Code Arduino đã gửi)
    orcFont = loadFont("ACaslonPro-Bold-48.vlw");//Chọn Font cho nó nguy hiểm tý, các bạn có thể chọn Font khác theo ý mình
}
void draw() {
    fill(98,245,31);
    textFont(orcFont);
    // Cái này mình cũng không hiểu lắm...hình như nó mô phỏng dòng chuyển động...Mà thôi,các bạn cứ coppy cho nhanh
    noStroke();
    fill(0,4);
    rect(0, 0, width, height-height*0.065);
    fill(98,245,31); // green color
    // Gọi các hàm vẽ Radar
    drawRadar();
    drawLine();
    drawObject();
    drawText();
}
void serialEvent (Serial myPort) { // Đọc dữ liệu từ cổng COM
    data = myPort.readStringUntil('.');// Đọc dữ liệu đến khi phát hiện dấu "." rồi gán vào biến "data"
    data = data.substring(0,data.length()-1);
    index1 = data.indexOf(","); // Tìm ký tự "," rồi gán vào "index1"
    angle= data.substring(0, index1); // Đọc dữ liệu từ ký tự đầu tiên...đến khi nhận dấu "," rồi gán vào biến "angle"
    distance= data.substring(index1+1, data.length()); // Đọc dữ liệu từ ký tự sau dấu "," đến dấu "." ( đến hết đó )
    // Chuyển đổi các chuỗi thành số nguyên
    iAngle = int(angle);
    iDistance = int(distance);
}
// Đến phần xây dựng giao diện Radar...Đây là vẽ hình á...các bạn cứ coppy
void drawRadar() {
    pushMatrix();
    translate(width/2,height-height*0.074); // di chuyển tọa độ đến vị trí mới!!!
    strokeWeight(2);
    stroke(98,245,31);
    // Vẽ các vệt line sao ý!!! keke
    arc(0,0,(width-width*0.0625),(width-width*0.0625),PI,TWO_PI);
    arc(0,0,(width-width*0.27),(width-width*0.27),PI,TWO_PI);
    arc(0,0,(width-width*0.479),(width-width*0.479),PI,TWO_PI);
    arc(0,0,(width-width*0.687),(width-width*0.687),PI,TWO_PI);
    // Vẽ các đường góc
    line(-width/2,0,width/2,0);
    line(0,0,(-width/2)*cos(radians(30)),(-width/2)*sin(radians(30)));
    line(0,0,(-width/2)*cos(radians(60)),(-width/2)*sin(radians(60)));
    line(0,0,(-width/2)*cos(radians(90)),(-width/2)*sin(radians(90)));
    line(0,0,(-width/2)*cos(radians(120)),(-width/2)*sin(radians(120)));
    line(0,0,(-width/2)*cos(radians(150)),(-width/2)*sin(radians(150)));
    line((-width/2)*cos(radians(30)),0,width/2,0);
    popMatrix();
}
void drawObject() {
    pushMatrix();
    translate(width/2,height-height*0.074); // Di chuyển con trỏ đến tọa độ khác...rồi vẽ tiếp
    strokeWeight(9);
    stroke(255,10,10); // Màu đỏ
    pixsDistance = iDistance*((height-height*0.1666)*0.025); // Khoảng cách..từ cm đổi thành pixcel ( theo công thức )
    // Nếu khoảng cách < 40cm
    if(iDistance<40){
        // Vẽ các đối tượng góc và khoảng cách...!!!!
        line(pixsDistance*cos(radians(iAngle)),-pixsDistance*sin(radians(iAngle)),(width-width*0.505)*cos(radians(iAngle)),-(width-width*0.505)*sin(radians(iAngle)));
    }
    popMatrix();
}
void drawLine() {
    pushMatrix();
    strokeWeight(9);
    stroke(30,250,60);
    translate(width/2,height-height*0.074); // Lại di chuyển con trỏ đến vị trí khác
    line(0,0,(height-height*0.12)*cos(radians(iAngle)),-(height-height*0.12)*sin(radians(iAngle)));
    popMatrix();
}
void drawText() { // Viết các dòng chữ trên màn hình
    pushMatrix();
    if(iDistance>40) {
        noObject = "Ra khỏi phạm vi";
    }
    else {
        noObject = "Trong phạm vi";
    }
    fill(0,0,0);
    noStroke();
    rect(0, height-height*0.0648, width, height);
    fill(98,245,31);
    textSize(25);
    text("10cm",width-width*0.3854,height-height*0.0833);
    text("20cm",width-width*0.281,height-height*0.0833);
    text("30cm",width-width*0.177,height-height*0.0833);
    text("40cm",width-width*0.0729,height-height*0.0833);
    textSize(40);
    text("Object: " + noObject, width-width*0.875, height-height*0.0277);
    text("Angle: " + iAngle +" °", width-width*0.48, height-height*0.0277);
    text("Distance: ", width-width*0.26, height-height*0.0277);
    if(iDistance<40) {
        text(" " + iDistance +" cm", width-width*0.225, height-height*0.0277);
    }
    textSize(25);
    fill(98,245,60);
    translate((width-width*0.4994)+width/2*cos(radians(30)),(height-height*0.0907)-width/2*sin(radians(30)));
    rotate(-radians(-60));
    text("30°",0,0);
    resetMatrix();
    translate((width-width*0.503)+width/2*cos(radians(60)),(height-height*0.0888)-width/2*sin(radians(60)));
    rotate(-radians(-30));
    text("60°",0,0);
    resetMatrix();
    translate((width-width*0.507)+width/2*cos(radians(90)),(height-height*0.0833)-width/2*sin(radians(90)));
    rotate(radians(0));
    text("90°",0,0);
    resetMatrix();
    translate(width-width*0.513+width/2*cos(radians(120)),(height-height*0.07129)-width/2*sin(radians(120)));
    rotate(radians(-30));
    text("120°",0,0);
    resetMatrix();
    translate((width-width*0.5104)+width/2*cos(radians(150)),(height-height*0.0574)-width/2*sin(radians(150)));
    rotate(radians(-60));
    text("150°",0,0);
    popMatrix();
}
