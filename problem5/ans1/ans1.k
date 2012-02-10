using konoha.math.*;
DELAY=5;
NUMCAPACITY=1;
class Decl {
    int id;
    int requestTime;
    int onFloor;
    int offFloor;
    Decl(Array<String> data) {
        _id = (int)data[0];
        _requestTime = (int)data[1];
        _onFloor = (int)data[2];
        _offFloor = (int)data[3];
    }
}
void mainLoop(Array<Decl> decls) {
    int time = 0;
    int floor = 1;
    foreach (Decl decl in decls) {
        time += Math.abs(floor - decl.onFloor) * 2;
        floor = decl.onFloor;
        if (decl.requestTime > DELAY + time) time = decl.requestTime - DELAY;
        OUT << 1 << "," << time << "," << floor << "," << "B," << 0 << ",0,0,0,0" << EOL;
        time += DELAY;
        OUT << 1 << "," << time << "," << floor << "," << "E," << decl.id << ",0,0,0,0" << EOL;
        time += Math.abs(floor - decl.offFloor) * 2;
        floor = decl.offFloor;
        OUT << 1 << "," << time << "," << floor << "," << "B," << decl.id << ",0,0,0,0" << EOL;
        time += DELAY;
        OUT << 1 << "," << time << "," << floor << "," << "E," << 0 << ",0,0,0,0" << EOL;
    }
}
void main(String[] args) {
    InputStream input = new("../input/input_i.csv");
    if (|args| > 0) {
        input = new (args[0]);
    }
    Decl[] decls = [];
    String s = "";
    while ((s = input.readLine()) != null) {
        decls.add(new Decl(s.split(",")));
    }
    mainLoop(decls);
}
