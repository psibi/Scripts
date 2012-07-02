/*
Find the number of elements of a list.
Example:
scala> length(List(1, 1, 2, 3, 5, 8))
res0: Int = 6
*/ 

object test {
  def main(args:Array[String]) = {
    def len[A](ls:List[A]):Int = 
      ls match {
	case h :: Nil => 1
	case h :: tail => 1+len(tail)
	case Nil =>  0
      }
    val a = len(List(1,2,3,4))
    val b = len(List("hi","byr"))
    println(a)
    println(b)
  }
}
