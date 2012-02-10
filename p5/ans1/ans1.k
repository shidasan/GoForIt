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
class Elevator {
    int id;
    int floor;
    Array<Int> passenger;
    Elevator(int id) {
        _id = id;
        _passenger = [];
        _floor = 1;
    }
    int changeFloor(int targetFloor) {
        int tmp = _floor;
        _floor = targetFloor;
        return Math.abs(tmp - targetFloor) * 2;
    }
}
class ElevatorEvent {
    int id;
    int time;
    int floor;
    boolean isOpen;
    Array<Int> difference;
    ElevatorEvent (Elevator e, Array<Int> difference, int time, boolean isOpen) {
        _id = e.id;
        _time = time;
        _floor = e.floor;
        _difference = difference;
        _isOpen = isOpen;
    }
    String dump() {
        String res = id + "," + time + "," + ((isOpen) ? "B," : "E,");
        for (int i = 0; i < |difference|; i++) {
            res += difference[i];
            if (i != |difference|-1) {
                res += ",";
            }
        }
        return res;
    }
}

void mainLoop(Array<Decl> decls) {
    int offed = 0;
    int time = 0;
    Elevator e = new(1);
    ElevatorEvent[] ee = [];
    while (true) {
        Decl decl = decls[offed];
        offed++;
        time += e.changeFloor(decl.onFloor);
        if (time< decl.requestTime - DELAY) {
            time = decl.requestTime - DELAY;
        }
        ee.add(new ElevatorEvent(e, [], time, true));
        time += DELAY;
        ee.add(new ElevatorEvent(e, [decl.id], time, false));
        time += e.changeFloor(decl.offFloor);
        ee.add(new ElevatorEvent(e, [decl.id], time, true));
        if (offed == |decls|) {
            break;
        }
        time += DELAY;
        ee.add(new ElevatorEvent(e, [], time, false));
    }
    foreach (ElevatorEvent ans in ee) {
        OUT << ans.dump() << EOL;
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
