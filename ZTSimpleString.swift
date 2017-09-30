//
//  ZTSimpleString.swift
//  ZTSimplifiedString(简化字符串操作)
//
//  Created by Zhangteng on 2017/9/30.
//  Copyright © 2017年 YFWL. All rights reserved.
//

import UIKit
import Foundation

/**
 * MARK: - 简单封装字符串简化操作
 */

///MARK: - 下标法
extension String {
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
    
    /// 字符串名[n,m]:获取、修改和删除，字符串名[n,n]:插入
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
}

///MARK: - 自定义方法
extension String {
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
}













