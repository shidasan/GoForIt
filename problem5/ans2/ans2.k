using konoha.math.*;
MAXCAPACITY=5;
DELAY=5;
int capacity;
int numElevator;
@Public dynamic Array.last() {
    return this[|this|-1];
}
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
class Event {
    int id;
    int time;
    int floor;
    String eventStr;
    int[] target;
    Event(String[] data) {
        this.id = (to Int)data[0];
        this.time = (to Int)data[1];
        this.floor = (to Int)data[2];
        this.eventStr = data[3];
        this.target = [];
        for (int i = 4; i < |data|; i++) {
            if (data[i] != "0") {
                target.add((to Int) data[i]);
            }
        }
    }
}
int changeFloor(int floor0, int floor1) {
    return Math.abs(floor0-floor1) * 2;
}
void confirm(Decl[] decls, Event[] events) {
    int[][] passenger = new Int[][numElevator+1];
    Event[][] chkevents = new Event[][numElevator+1];
    int declComfirmed = 0;
    for (int i = 0; i < numElevator+1; i++) {
        passenger[i] = [];
        chkevents[i] = [new Event((i + ",0,1,E,0,0,0,0,0").split(","))];
    }
    Event publicLast = new Event(("1,0,1,E,0,0,0,0,0").split(","));
    for (int i = 0; i < |events|; i++) {
        Event e = events[i];
        print i, e;
        assert(publicLast.time <= e.time);
        assert(e.id <= numElevator);
        assert(e.eventStr == "E" || e.eventStr == "B");
        Event last = chkevents[e.id].last();
        if (e.eventStr == "B") {
            assert(last.eventStr == "E");
            assert(e.time >= last.time + changeFloor(e.floor, last.floor));
            if (|e.target| > 0) {
                foreach (int p in e.target) {
                    assert(passenger[e.id].indexOf(p) != -1);
                    passenger[e.id].remove(passenger[e.id].indexOf(p));
                    declComfirmed++;
                }
            }
            chkevents[e.id].add(e);
        } else {
            assert(last.eventStr == "B");
            assert(e.time >= last.time + DELAY);
            assert(e.floor == last.floor);
            if (|e.target| > 0) {
                foreach (int p in e.target) {
                    assert(decls[p].requestTime <= e.time);
                    passenger[e.id].add(p);
                    assert(|passenger[e.id]| <= capacity);
                }
            }
            chkevents[e.id].add(e);
        }
        publicLast = e;
    }
    assert(declComfirmed == |decls|-1);
    OUT.println("Confirmed");
}
void main(String[] args) {
    if (|args| != 4) {
        print "Usage: [input] [output] [capacity] [elevator count]";
        return;
    }

    InputStream inputdata = new (args[0]);
    InputStream outputdata = new (args[1]);
    capacity = (to Int)args[2];
    assert(capacity <= MAXCAPACITY);
    numElevator = (to Int) args[3];
    Decl[] decls = [null];
    Event[] events = [];
    String s = "";
    while ((s = inputdata.readLine()) != null) {
        decls.add(new Decl(s.split(",")));
    }
    while ((s = outputdata.readLine()) != null) {
        events.add(new Event(s.split(",")));
    }
    confirm(decls, events);
}
