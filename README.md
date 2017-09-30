<h1 align="center"> Swift 4.0简化字符串相应操作 </h1>

## 开发环境
Mac OS 10.12+ / Xcode 9+ / Swift 4.0
## 支持环境
iOS 8+， iPhone & iPad
## 项目获取
项目已上传至GitHub中 [ZTSimplifiedString](https://github.com/WayToForward/ZTSimplifiedString),若要使用，下载后导入您的项目，就可直接使用
## 如何使用
### 通过整数下标获取与修改字符串的某个字符
* 源码展示


		/// 字符串名[n]: 修改与获取字符串某个字符
	    ///
	    /// - Parameter index: 下标整数
	    subscript(index: Int) -> Character {
	        set {
	            guard index >= 0 && index < self.count else {
	                assertionFailure("The subscript has beyond [0,\(self.count-1)]")
	                return
	            }
	            let startIndex = self.startIndex;
	            let startPath = self.index(startIndex, offsetBy:index)
	            let endPath = self.index(after: startPath)
	            let range = startPath ..< endPath
	            self.replaceSubrange(range, with: String(newValue))
	        }
	        get {
	            var character:Character = "0"
	            guard index < self.count else {
	                assertionFailure("The subscript has beyond [0,\(self.count-1)]")
	                return character
	            }
	            let startIndex = self.startIndex;
	            let indexPath = self.index(startIndex, offsetBy:index)
	            character = self.characters[indexPath]
	            return character
	        }
	    }
* 使用示例

		var example = "ABCDEFG"
        example[0] = "1" 
        print(example)  //1BCDEFG
        print(example[0]) //输出1
        
### 通过整数范围下标获取与修改字符串某个范围内的子串
* 源码展示
	
		/// 字符串名[n,m]:获取、修改和删除
	    ///
	    /// - Parameters:
	    ///   - startIndex: 下标整数
	    ///   - endIndex: 下标整数
	    subscript(_ startIndex:Int ,_ endIndex:Int) -> String {
	        set {
	            var min = startIndex
	            var max = endIndex
	            guard  (min >= 0 &&  min < self.count) && (max >= 0 &&  max < self.count) else {
	                assertionFailure("The subscript has beyond [0,\(self.count-1)]")
	                return
	            }
	            if min > max {
	                (min,max) = (max,min)
	            }
	            let firstIndex = self.startIndex;
	            let startPath = self.index(firstIndex, offsetBy:min)
	            let endPath = self.index(firstIndex, offsetBy:max)
	            let range = startPath ... endPath
	            self.replaceSubrange(range, with: newValue)
	        }
	        get {
	            var min = startIndex
	            var max = endIndex
	            var newString = String()
	            guard (min >= 0 &&  min < self.count) && (max >= 0 &&  max < self.count) else {
	                assertionFailure("The subscript has beyond [0,\(self.count-1)]")
	                return newString
	            }
	            if min > max {
	                (min,max) = (max,min)
	            }
	            let firstIndex = self.startIndex;
	            let startPath = self.index(firstIndex, offsetBy:min)
	            let endPath = self.index(firstIndex, offsetBy:max)
	            let range = startPath ... endPath
	            newString = String(self[range])
	            return newString
	        }
	    }
	    
	    /// 字符串名[n...m]: 获取与修改相应的子串
	    ///
	    /// - Parameter closeRange: 无符号封闭整型范围
	    subscript(_ closeRange:ClosedRange<Int>) -> String {
	        set {
	            self[closeRange.lowerBound,closeRange.upperBound] = newValue
	        }
	        get {
	            return String(self[closeRange.lowerBound,closeRange.upperBound])
	        }
	    }
	    
	    /// 字符串名[n..<m]: 获取与修改相应的子串
	    ///
	    /// - Parameter closeRange: 无符号半封闭整型范围
	    subscript(_ subRange:Range<Int>) -> String {
	        set {
	            self[subRange.lowerBound,subRange.upperBound-1] = newValue
	        }
	        get {
	            return String(self[subRange.lowerBound,subRange.upperBound-1])
	        }
	    }
* 使用示例

		var example = "ABCDEFG"

        print(example[0,1])  //输出：AB :全封闭区间
        print(example[1..<3]) //输出：BC
        print(example[3...5]) //输出：DEF
        
        example[0,1] = "12"
        example[2..<4] = "34"
        //example[5...7] = "567" //报下标越界error
        example[4...6] = "567"
        print(example) //输出：1234567
    
        example[0,2] = "" //另类的删除
        print(example) //输出：4567
        
### 通过整数下标插入字符或字符串
* 源码展示

		/// 用对应下标的整数来插入字符
	    ///
	    /// - Parameters:
	    ///   - newString: 需插入的字符
	    ///   - index: 相应下标整数
	    mutating func insert(_ newCharacter:Character, at index:Int) {
	        guard index >= 0 && index < self.count else {
	            assertionFailure("The subscript has beyond [0,\(self.count-1)]")
	            return
	        }
	        //dealStr[index,index] = newString; //也可以这样通过下标来插入，但需保持两个下标相等
	        let firstIndex = self.startIndex;
	        let indexpath = self.index(firstIndex, offsetBy:index)
	        self.insert(newCharacter, at: indexpath)
	    }
		/// 用对应下标的整数来插入字符串
	    ///
	    /// - Parameters:
	    ///   - newString: 需插入的字符串
	    ///   - index: 相应下标整数
	    mutating func insert(_ newString:String, at index:Int) {
	        guard index >= 0 && index < self.count else {
	            assertionFailure("The subscript has beyond [0,\(self.count-1)]")
	            return
	        }
	        //dealStr[index,index] = newString; //也可以这样通过下标来插入，但需保持两个下标相等
	        let firstIndex = self.startIndex;
	        let indexpath = self.index(firstIndex, offsetBy:index)
	        self.insert(contentsOf: newString, at: indexpath)
	    }
* 使用示例

		var example = "ABCDEFG"

        example.insert("0", at: 0)
        print(example) //输出: 0ABCDEFG
        example.insert("zt", at: example.count-1)
        print(example) //输出：0ABCDEFztG
        
### 通过整数下标删除字符或字符串
* 源码展示

		/// 删除对应下标整数的字符
	    ///
	    /// - Parameter index: 下标整数
	    /// - Returns: 删除的字符
	    mutating func remove(i index: Int) -> Character {
	        var character:Character = "0"
	        guard index >= 0 && index < self.count else {
	            assertionFailure("The subscript has beyond [0,\(self.count-1)]")
	            return character
	        }
	        let indexPath = self.index(self.startIndex, offsetBy: index)
	        character = self.remove(at: indexPath)
	        return character
	    }
	    
	    /// 给出范围整数，删除该范围的字符串(全封闭区间)
	    ///
	    /// - Parameters:
	    ///   - startIndex: 初始下标
	    ///   - endIndex: 结尾下标
	    mutating func remove(from startIndex:Int, to endIndex:Int) {
	        var min = startIndex
	        var max = endIndex
	        guard (min >= 0 &&  min < self.count) && (max >= 0 &&  max < self.count) else {
	            assertionFailure("The subscript has beyond [0,\(self.count-1)]")
	            return
	        }
	        if min > max {
	            (min,max) = (max,min)
	        }
	        let firstIndex = self.startIndex;
	        let startPath = self.index(firstIndex, offsetBy:min)
	        let endPath = self.index(firstIndex, offsetBy:max)
	        let range = startPath ... endPath
	        self.removeSubrange(range)
	    }
	    /// n...m: 删除此范围的字符串
	    ///
	    /// - Parameter closeRange: n...m
	    mutating func removeRange(_ closeRange:ClosedRange<Int>) {
	        self.remove(from: closeRange.lowerBound, to: closeRange.upperBound)
	    }
	    /// n..<m: 删除此范围的字符串
	    ///
	    /// - Parameter closeRange: n..<m
	    mutating func removeRange(_ subRange:Range<Int>) {
	        self.remove(from: subRange.lowerBound, to: subRange.upperBound-1)
	    }
* 使用示例

		var example = "ABCDEFG"

        example.remove(i: 0)
        print(example) //输出：BCDEFG
        example.remove(from: 0, to: 1) //删除全封闭的区间
        print(example) //输出：DEFG
        example.removeRange(0...1)
        print(example) //输出：FG
        example.removeRange(0..<1)
        print(example) //输出：G
