/*
Find the Kth element of a list.
By convention, the first element in the list is element 0.
Example:

scala> nth(2, List(1, 1, 2, 3, 5, 8))
res0: Int = 2
*/
object test {
  def main(args:Array[String]) = {
    def nth[A](n:Int,ls:List[A]):A = (n,ls) match {
      case (0,h :: _) => h
      case (n,_ :: tail) => nth(n-1,tail)
      case (n, Nil ) => throw new NoSuchElementException
    }
    val a = nth(3,List(1,2,3,4))
    val b = nth(1,List("Hi","bye","romeo"))
    println(a)
    println(b)
  }
}
