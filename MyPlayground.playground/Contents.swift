import UIKit

var str = "Hello, playground"



func sum(_ nums: [Int], _ target: Int) -> [Int] {
  for num1 in nums {
    for num2 in (nums.firstIndex(of: num1)! + 1)...(nums.count-1) {
      if num1 + nums[num2] == target {
        return [nums.firstIndex(of: num1)!, num2]
      }
    }
  }
    return []
}

sum([6,0,5,3], 5)
