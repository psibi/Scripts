/*
1)  swig -c++ -java sab1.i
2)  g++ -fpic -c sab1.cpp sab1_wrap.cxx -I /usr/lib/jvm/java-6-openjdk-i386/include/ -I /usr/lib/jvm/java-6-openjdk-i386/include/linux/ 
3)  g++ --shared sab1.o sab1_wrap.o -o libegs.so
4) javac -classpath . Test.java
5) java -Djava.library.path="." Test
*/

public class Test 
{
    public static void main(String args[]) 
    {
	System.loadLibrary("egs");
	CRectangle a = new CRectangle();
	a.set_values(4,5);
	System.out.println(a.area());
	String[] str = {"Hi","Bye"};
	a.print(str);


    }
}
