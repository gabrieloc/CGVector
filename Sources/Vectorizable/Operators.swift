//
//  File.swift
//
//
//  Created by Gabriel O'Flaherty-Chan on 2021-02-01.
//

import Foundation

public extension Vector {
  static func * <V: Vector>(lhs: Self, rhs: V) -> Self where V.Scalar == Scalar {
    Self(components: lhs.components * rhs.components)
  }

  static func * (lhs: Self, rhs: Self.Scalar) -> Self {
    Self(components: lhs.components.map { $0 * rhs })
  }

  static func + <V: Vector>(lhs: Self, rhs: V) -> Self where V.Scalar == Scalar {
    Self(components: lhs.components + rhs.components)
  }

  static func + (lhs: Self, rhs: Self.Scalar) -> Self {
    Self(components: lhs.components.map { $0 + rhs })
  }

  static func - <V: Vector>(lhs: Self, rhs: V) -> Self where V.Scalar == Scalar {
    Self(components: lhs.components - rhs.components)
  }

  static func - (lhs: Self, rhs: Self.Scalar) -> Self {
    Self(components: lhs.components.map { $0 - rhs })
  }
}

public extension Vector where Scalar: FloatingPoint {
  static func / <V2: Vector>(lhs: Self, rhs: V2) -> Self where Scalar == V2.Scalar {
    Self(components: zip(lhs.components, rhs.components).map { $0.0 / $0.1 })
  }
}

extension Vector where Scalar: Divisible {
  static func / <V: Vector>(lhs: Self, rhs: V) -> Self where V.Scalar == Scalar {
    Self(components: lhs.components / rhs.components)
  }

  static func / (lhs: Self, rhs: Self.Scalar) -> Self {
    Self(components: lhs.components.map { $0 / rhs })
  }
}

extension Array where Element: Numeric {
  static func * (lhs: Self, rhs: Self) -> Self {
    memberwiseOperation(lhs: lhs, rhs: rhs, operation: *)
  }

  static func + (lhs: Self, rhs: Self) -> Self {
    memberwiseOperation(lhs: lhs, rhs: rhs, operation: +)
  }

  static func - (lhs: Self, rhs: Self) -> Self {
    memberwiseOperation(lhs: lhs, rhs: rhs, operation: -)
  }

  static func memberwiseOperation(
    lhs: Self,
    rhs: Self,
    operation: (Element, Element) -> Element
  ) -> Self {
    let size = Swift.max(lhs.count, rhs.count)
    return zip(lhs.withSize(size), rhs.withSize(size)).map(operation)
  }

  func withSize(_ size: Int) -> Self {
    (0..<size).map { $0 < count ? self[$0] : 0 }
  }

  subscript(safe index: Index) -> Element? {
    indices.contains(index) ? self[index] : nil
  }
}

public protocol Divisible: Numeric {
  static func / (lhs: Self, rhs: Self) -> Self
}

extension Float: Divisible {}
extension Double: Divisible {}
extension Int: Divisible {}

extension Array where Element: Divisible {
  static func / (lhs: Self, rhs: Self) -> Self {
    memberwiseOperation(lhs: lhs, rhs: rhs, operation: /)
  }
}
