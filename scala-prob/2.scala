/*
P02 (*) Find the last but one element of a list.
Example:
scala> penultimate(List(1, 1, 2, 3, 5, 8))
res0: Int = 5
*/

object test {
  def main(args:Array[String]) = {
    def penultimate[A](ls:List[A]):A = 
      ls match {
	case h :: _ :: Nil => h
	case _ :: tail => penultimate(tail)
	case _ => throw new NoSuchElementException
      }
    val a = penultimate(List(1,2,3,4))
    println(a)
  }
}
