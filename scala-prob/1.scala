/*
Find the last element of a list.
Example:
scala> last(List(1, 1, 2, 3, 5, 8))
res0: Int = 8
*/
class Last {
  def last(a:List[Int]) {
    println(a(a.length - 1))
  }
}

object test extends Last {
  def main(args:Array[String]) = {
  last(List(1,2,3,4,5))
  }
}
