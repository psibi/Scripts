/*
Find out whether a list is a palindrome.
Example:
scala> isPalindrome(List(1, 2, 3, 2, 1))
res0: Boolean = true
*/
object test {
  def main(args:Array[String]) = {
    def isPalindrome[A](ls:List[A]):Boolean = {
      ls == ls.reverse
    }
    val a = isPalindrome(List("a","b","c","b","a"))
    print(a)
  }
}
