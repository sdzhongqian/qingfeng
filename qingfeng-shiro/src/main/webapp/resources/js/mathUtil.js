//乘法
function FloatMul(arg1, arg2) {
    var m = 0,
    s1 = arg1.toString(),
    s2 = arg2.toString();
    try {
        m += s1.split(".")[1].length
    } catch(e) {

	}
    try {
        m += s2.split(".")[1].length
    } catch(e) {

	}
    return Number(s1.replace(".", "")) * Number(s2.replace(".", "")) / Math.pow(10, m);
}
//加法
function FloatAdd(arg1, arg2) {
    var r1, r2, m;
    try {
        r1 = arg1.toString().split(".")[1].length
    } catch(e) {
        r1 = 0
    }
    try {
        r2 = arg2.toString().split(".")[1].length
    } catch(e) {
        r2 = 0
    }
    m = Math.pow(10, Math.max(r1, r2));
    return (arg1 * m + arg2 * m) / m;
}
//减法
function FloatSub(arg1, arg2) {
    var r1, r2, m, n;
    try {
        r1 = arg1.toString().split(".")[1].length
    } catch(e) {
        r1 = 0
    }
    try {
        r2 = arg2.toString().split(".")[1].length
    } catch(e) {
        r2 = 0
    }
    m = Math.pow(10, Math.max(r1, r2));
    //动态控制精度长度
    n = (r1 >= r2) ? r1: r2;
    return ((arg1 * m - arg2 * m) / m).toFixed(n);
}
//除法
function FloatDiv(arg1,arg2){
	var t1,t2,r1,r2;
	try{
			t1=arg1.toString().split(".")[1].length
		}catch(e){
			t1=0
		}
	try{
			t2=arg2.toString().split(".")[1].length
		}catch(e){
			t2=0
		}
	with(Math){
		r1=Number(arg1.toString().replace(".",""))
		r2=Number(arg2.toString().replace(".",""))
		return (r1/r2)*pow(10,t2-t1);
	}
}



//乘法
function FloatMulFixed(arg1, arg2,num) {
    var m = 0,
        s1 = arg1.toString(),
        s2 = arg2.toString();
    try {
        m += s1.split(".")[1].length
    } catch(e) {

    }
    try {
        m += s2.split(".")[1].length
    } catch(e) {

    }
    //return (Number(s1.replace(".", "")) * Number(s2.replace(".", "")) / Math.pow(10, m)).toFixed(num);
    return Math.round((Number(s1.replace(".", "")) * Number(s2.replace(".", "")) / Math.pow(10, m)) * Math.pow(10, num)) / Math.pow(10, num)
}
//加法
function FloatAddFixed(arg1, arg2,num) {
    if(num==undefined||num==''||num==null){
        num=2;
    }
    var r1, r2, m;
    try {
        r1 = arg1.toString().split(".")[1].length
    } catch(e) {
        r1 = 0
    }
    try {
        r2 = arg2.toString().split(".")[1].length
    } catch(e) {
        r2 = 0
    }
    m = Math.pow(10, Math.max(r1, r2));
    //return ((arg1 * m + arg2 * m) / m).toFixed(num);
    return Math.round(((arg1 * m + arg2 * m) / m) * Math.pow(10, num)) / Math.pow(10, num)
}
//减法
function FloatSubFixed(arg1, arg2,num) {
    var r1, r2, m;
    try {
        r1 = arg1.toString().split(".")[1].length
    } catch(e) {
        r1 = 0
    }
    try {
        r2 = arg2.toString().split(".")[1].length
    } catch(e) {
        r2 = 0
    }
    m = Math.pow(10, Math.max(r1, r2));
    //动态控制精度长度
    //return ((arg1 * m - arg2 * m) / m).toFixed(num);
    return Math.round(((arg1 * m - arg2 * m) / m) * Math.pow(10, num)) / Math.pow(10, num)
}
//除法
function FloatDivFixed(arg1,arg2,num){
    var t1,t2,r1,r2;
    try{
        t1=arg1.toString().split(".")[1].length
    }catch(e){
        t1=0
    }
    try{
        t2=arg2.toString().split(".")[1].length
    }catch(e){
        t2=0
    }
    with(Math){
        r1=Number(arg1.toString().replace(".",""))
        r2=Number(arg2.toString().replace(".",""))
        //return ((r1/r2)*pow(10,t2-t1)).toFixed(num);
        return Math.round(((r1 / r2) * pow(10, t2 - t1)) * Math.pow(10, num)) / Math.pow(10, num)
    }
}