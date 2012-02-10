STR_MAX=300000;
/* ランダム文字列生成 */
String getStr() {
    int i = 0; r = 16;
    Bytes rand_str = new byte[STR_MAX];
    for (i = 0; i < STR_MAX; i++) {
        r = ( r * 1103515245 + 12345 )& 0xFFFFFFFF;
        rand_str[i] = 0x61 + ( 26 * ( r / 0x10000) ) / 0x10000;
    }
    String res = rand_str.decode();
    return res;
}

void main(String[] args) {
    String rand_str = getStr();
    if (|args| != 1) {
        print "Usage: keyword";
        return;
    }
    String keyword = args[0];
    /* スキップ数と先頭位置でイテレート */
    for (int skip = 1; skip < STR_MAX-1; skip++) {
        for (int head = 0; head < STR_MAX-skip; head++) {
            boolean equal = true;
            boolean equalRev = true;
            for (int i = 0; i < |keyword|; i++) {
                int point = head + skip * i;
                int pointRev = head + skip * ((|keyword|-1) - i);
                if (point >= STR_MAX || keyword[i] != rand_str[point]) {
                    equal = false;
                }
                if (pointRev >= STR_MAX || keyword[i] != rand_str[pointRev]) {
                    equalRev = false;
                }
            }
            if (equal || equalRev) {
                OUT.println(skip + "," + (head+1));
                ERR.println(skip + "," + (head+1));
            }
        }
    }
}
