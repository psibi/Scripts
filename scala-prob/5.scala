/*
Reverse a list.
Example:
scala> reverse(List(1, 1, 2, 3, 5, 8))
res0: List[Int] = List(8, 5, 3, 2, 1, 1)
*/

object test {
  def main(args:Array[String]) = {
    def reverse[A](ls:List[A]):List[A] = ls match {
      case _ :: h :: Nil => h :: reverse(_)
      case Nil => Nil
    }
    val a = reverse(List(1,2,4))
    println(a)
  }
}
