//
//  SwiftReflectorTests.swift
//  SwiftReflectorTests
//
//  Created by Víctor on 23/8/14.
//  Copyright (c) 2014 Víctor Berga. All rights reserved.
//

import UIKit
import XCTest
import SwiftReflector

class ReflectorTests: XCTestCase {
  
  class TestClass : NSObject {
    var property1:String = "value1"
    var property2:Int    = 2
    
    func method() {}
  }
  
  var reflector:Reflector<TestClass>?
  
  override func setUp() {
    super.setUp()
    
    self.reflector = Reflector<TestClass>()
  }
  
  override func tearDown() {
    self.reflector = nil
    
    super.tearDown()
  }
  
  func testCreation() {
    XCTAssertNotNil(self.reflector!)
  }
  
  func testName() {
    let name = self.reflector!.name
    XCTAssertTrue(name == "_TtCC19SwiftReflectorTests14ReflectorTests9TestClass",
                  "Returned: \(self.reflector!.name)")
  }
  
  func testProperties() {
    let expected:Array<String> = ["property1", "property2"]
    let returned = self.reflector!.properties
    
    XCTAssertTrue(expected == returned)
  }
  
  func testMethods() {
    let returned = self.reflector!.methods
    
    XCTAssertTrue(contains(returned, "method"), "\(returned)")
  }
  
  func testCreateInstance() {
    let instance:TestClass = self.reflector!.createInstance()
    
    XCTAssertTrue(instance.property1 == "value1")
    XCTAssertTrue(instance.property2 == 2)
  }
  
  func testExecute() {
    let instance = self.reflector!.createInstance()
    var counter = 0
    self.reflector!.execute({ (`self`) -> () in
      ++counter
      `self`.property1 = "foo"
    },instance: instance)
    
    XCTAssertTrue(counter > 0)
    XCTAssertTrue(instance.property1 == "foo")
  }
  
  func testExecuteWithReturn() {
    let instance = self.reflector!.createInstance()
    let returned = self.reflector!.execute({ (`self`) -> Int in
      return `self`.property2 * 2
    }, instance: instance)
    
    XCTAssertTrue(returned == 4)
  }
  
  func testCreateInstanceFromString() {
    let className = "NSData"
    let instance: AnyObject? = Reflector.createInstance(className)
    
    XCTAssertTrue(instance != nil)
    XCTAssertTrue(instance is NSData)
  }
  
  func testPerformance() {

    self.measureBlock() {
      for var i = 0; i < 1000; ++i {
        let reflector = Reflector<TestClass>()
        
        let name        = reflector.name
        let properties  = reflector.properties
        let methods     = reflector.methods
      }
    }
  }
  
  func testIntegral() {
    let reflector   = Reflector<NSString>()
    let name        = reflector.name
    let properties  = reflector.properties
    let methods     = reflector.methods
    let instance    = reflector.createInstance()
    
    let example = "My Example String"
    reflector.execute({ (`self`) -> () in
      println("I have access to self: \(`self`)")
    }, instance: example)
    let returnValue = reflector.execute({ (`self`) -> String in
      return `self`.substringFromIndex(5)
    }, instance: example)
    
    XCTAssertTrue(true, "Executed integral test")
  }
}
