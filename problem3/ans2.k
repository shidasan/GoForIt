STR_MAX=300000;
String getStr() {
    int i = 0; r = 16;
    Bytes rand_str = new byte[STR_MAX];
    for (i = 0; i < STR_MAX; i++) {
        r = ( r * 1103515245 + 12345 )& 0xFFFFFFFF;
        rand_str[i] = 0x61 + ( 26 * ( r / 0x10000) ) / 0x10000;
    }
    String res = rand_str.decode();
    OutputStream out = new("input.txt");
    out.print(res);
    return res;
}

/* ソート済みの配列に対するデータの挿入 */
Int[] addarray(Int[] array, int value) {
    if (array == null) {
        array = [];
    }
    if (array.indexOf(value) != -1) {
        return array;
    }
    for (int i = 0; i < |array|; i++) {
        if (array[i] > value) {
            array.insert(i, value);
            break;
        }
        if (i == |array|-1) {
            array.add(value);
            break;
        }
    }
    return array;
}
void main(String[] args) {
    OutputStream out;
    String rand_str = getStr();
    if (|args| != 1) {
        print "Usage: keyword";
        return;
    }
    out = new("result_" + args[0] + ".txt");
    String keyword = args[0];
    Int[][] result = new Int[][STR_MAX];
    Int[][] data = new Int[][2];
    Int[][] reverceData = new Int[][2];
    for (int i = 0; i < |data|; i++) {
        data[i] = [];
        reverceData[i] = [];
    }
    /* ランダム文字列から、キーワードの一文字目と二文字目の位置を取得する */
    for (int i = 0; i < |data|; i++) {
        for (int j = 0; j < STR_MAX; j++) {
            if (rand_str[j] == keyword[i]) {
                data[i].add(j);
            }
            if (rand_str[j] == keyword[(|keyword|-1)-i]) {
                reverceData[i].add(j);
            }
        }
    }

    /* 一文字目と二文字目の位置から、スキップ数を決定する */
    for (int i = 0; i < |data[0]|; i++) {
        for (int j = 0; j < |data[1]|; j++) {
            if (data[0][i] > data[1][j]) continue;
            int skip = data[1][j] - data[0][i];
            boolean equal = true;
            int point = data[1][j];
            for (int k = 2; k< |keyword|; k++) {
                point = point + skip;
                if (point >= STR_MAX || rand_str[point] != keyword[k]) {
                    equal = false;
                    break;
                }
            }
            /* 先頭文字列の昇順で答えが出力されてしまうためソート */
            if (equal) {
                if (result[skip] == null) {
                    result[skip] = [data[0][i]+1];
                } else {
                    result[skip] = addarray(result[skip], data[0][i]+1);
                }
            }
        }
    }

    /* 逆順 */
    for (int i = 0; i < |reverceData[0]|; i++) {
        for (int j = 0; j < |reverceData[1]|; j++) {
            if (reverceData[0][i] > reverceData[1][j]) continue;
            int skip = reverceData[1][j] - reverceData[0][i];
            boolean equal = true;
            int point = reverceData[1][j];
            for (int k = 2; k< |keyword|; k++) {
                point = point + skip;
                if (point >= STR_MAX || rand_str[point] != keyword[|keyword|-1-k]) {
                    equal = false;
                    break;
                }
            }
            if (equal) {
                if (result[skip] == null) {
                    result[skip] = [reverceData[0][i]+1];
                } else {
                    result[skip] = addarray(result[skip], reverceData[0][i]+1);
                }
            }
        }
    }
    
    /* ソート済みの結果を出力 */
    for (int i = 0; i < |result|; i++) {
        if (result[i] == null) continue;
        for (int j = 0; j < |result[i]|; j++) {
            out.println(i + "," + result[i][j]);
            ERR.println(i + "," + result[i][j]);
        }
    }
}
