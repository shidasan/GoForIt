using konoha.math.*;
DELAY=5;
NUMCAPACITY=1;
class Decl {
    int id;
    int requestTime;
    int closeFloor;
    int openFloor;
    Decl(Array<String> data) {
        _id = (int)data[0];
        _requestTime = (int)data[1];
        _closeFloor = (int)data[2];
        _openFloor = (int)data[3];
    }
}
class ElevatorEvent {
    int id;
    int time;
    int floor;
    boolean isOpen;
    Array<Int> difference;
    ElevatorEvent (int id, int floor, Array<Int> difference, int time, boolean isOpen) {
        _id = id;
        _floor = floor;
        _time = time;
        _difference = difference;
        _isOpen = isOpen;
    }
    String dump() {
        String res = id + "," + time + "," + floor + "," + ((isOpen) ? "B," : "E,");
        for (int i = 0; i < |difference|; i++) {
            res += difference[i];
            if (i != |difference|-1) {
                res += ",";
            }
        }
        return res;
    }
}
class Elevator {
    int id;
    ElevatorEvent[] ee;
    Elevator(int id) {
        _id = id;
        _ee = [];
    }
    int changeFloor(int fromFloor, int toFloor) {
        return Math.abs(fromFloor - toFloor) * 2;
    }
    int openToOpen(Decl decl1, Decl decl2, int time) {
        if (decl1.openFloor == decl2.openFloor) {
            ee[|ee|-1].difference.remove(ee[|ee|-1].difference.indexOf(decl2.id));
            return time;
        } else {
            time += DELAY;
            ee.add(new ElevatorEvent(this.id, decl1.openFloor, [], time, false));
            time += changeFloor(decl1.openFloor, decl2.openFloor);
            ee.add(new ElevatorEvent(this.id, decl2.openFloor, [decl2.id], time, true));
            return time;
        }
    }
    int openToClose(Decl decl1, Decl decl2, int time) {
        if (decl1.openFloor == decl2.closeFloor) {
            time += DELAY;
            time = (time < decl2.requestTime) ? decl2.requestTime : time;
            ee.add(new ElevatorEvent(this.id, decl2.closeFloor, [decl2.id], time, false));
            return time;
        } else {
            time += DELAY;
            ee.add(new ElevatorEvent(this.id, decl1.openFloor, [], time, false));
            time += changeFloor(decl1.openFloor, decl2.closeFloor);
            ee.add(new ElevatorEvent(this.id, decl2.closeFloor, [], time, true));
            time += DELAY;
            time = (time < decl2.requestTime) ? decl2.requestTime : time;
            ee.add(new ElevatorEvent(this.id, decl2.closeFloor, [decl2.id], time, false));
            return time;
        }
    }
    int closeToOpen(Decl decl1, Decl decl2, int time) {
        if (decl1.closeFloor == decl2.openFloor) {
            ee.add(new ElevatorEvent(this.id, decl2.openFloor, [decl2.id], time, true));
            return time;
        } else {
            time += changeFloor(decl1.closeFloor, decl2.openFloor);
            ee.add(new ElevatorEvent(this.id, decl2.openFloor, [decl2.id], time, true));
            return time;
        }
    }
    int closeToClose(Decl decl1, Decl decl2, int time) {
        if (decl1 == null) {
            time += changeFloor(1, decl2.closeFloor);
            ee.add(new ElevatorEvent(this.id, decl2.closeFloor, [], time, true));
            time += DELAY;
            time = (time < decl2.requestTime) ? decl2.requestTime : time;
            ee.add(new ElevatorEvent(this.id, decl2.closeFloor, [decl2.id], time, false));
            return time;
        } else if (decl1.closeFloor == decl2.closeFloor) {
            ee[|ee|-1].difference.add(decl2.id);
            return time;
        } else {
            time += changeFloor(decl1.closeFloor, decl2.closeFloor);
            ee.add(new ElevatorEvent(this.id, decl2.closeFloor, [], time, true));
            time += DELAY;
            time = (time < decl2.requestTime) ? decl2.requestTime : time;
            ee.add(new ElevatorEvent(this.id, decl2.closeFloor, [decl2.id], time, false));
            return time;
        }
    }
    void dump() {
        foreach(ElevatorEvent tmp in ee) {
            OUT << tmp.dump() << EOL;
        }
    }
}
void mainLoop(Array<Decl> decls) {
    int offset = 0;
    int lostime = 0;
    int time = 0;
    Elevator e = new Elevator(1);
    Decl decl1 = decls[0];
    Decl decl2 = null;
    time = e.closeToClose(null, decl1, time);
    offset++;
    while (offset < |decls|) {
        decl2 = decls[offset];
        offset++;
        time = e.closeToOpen(decl1, decl1, time);
        lostime += time - decl1.requestTime;
        time = e.openToClose(decl1, decl2, time);
        decl1 = decl2;
    }
    time = e.closeToOpen(decl1, decl1, time);
    lostime += time - decl1.requestTime;
    e.dump();
    print lostime;
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
