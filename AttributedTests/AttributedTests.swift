//
//  AttributedTests.swift
//  AttributedTests
//
//  Created by David House on 1/10/16.
//  Copyright © 2016 David House. All rights reserved.
//

import XCTest
@testable import Attributed

let aString: String = "Here is a string to use in tests"

class AttributedTests: XCTestCase {

    func testCanCreateAStringWithNoFormatting() {

        let attributed = Attributed
        let result = attributed.toString { aString }
        XCTAssertEqual(result, NSAttributedString(string: aString))
    }

    func testCanCreateAnEmptyString() {

        let attributed = Attributed
        let result = attributed.toString { "" }
        XCTAssertEqual(result.length, 0)

        let attributedResult = attributed.toString { NSAttributedString() }
        XCTAssertEqual(attributedResult.length, 0)
    }

    func testCanCreateAStringWithOnlyColorApplied() {

        let attributed = Attributed(color: NSColor.red)
        let result = attributed.toString(aString)
        var range = NSRange()
        let attributes = result.attributes(at: 0, effectiveRange: &range)
        XCTAssertEqual(attributes.count, 1)
        XCTAssertTrue(attributes.keys.contains(NSForegroundColorAttributeName))
        XCTAssertEqual(range.location, 0)
        XCTAssertEqual(range.length, result.length)
    }

    func testCanCreateAStringWithOnlyColorAppliedUsingClosure() {

        let attributed = Attributed(color: NSColor.red)
        let result = attributed.toString { aString }
        var range = NSRange()
        let attributes = result.attributes(at: 0, effectiveRange: &range)
        XCTAssertEqual(attributes.count, 1)
        XCTAssertTrue(attributes.keys.contains(NSForegroundColorAttributeName))
        XCTAssertEqual(range.location, 0)
        XCTAssertEqual(range.length, result.length)
    }

    func testCanCreateStringWithOnlyFontApplied() {

        let attributed = Attributed(font: NSFont.boldSystemFont(ofSize: 24))
        let result = attributed.toString { aString }
        var range = NSRange()
        let attributes = result.attributes(at: 0, effectiveRange: &range)
        XCTAssertEqual(attributes.count, 1)
        XCTAssertTrue(attributes.keys.contains(NSFontAttributeName))
        let font = attributes[NSFontAttributeName] as? NSFont
        XCTAssertEqual(font, NSFont.boldSystemFont(ofSize: 24))
        XCTAssertEqual(range.location, 0)
        XCTAssertEqual(range.length, result.length)
    }

    func testCanCreateStringWithMultipleAttributesAtOnce() {

        let attributes = [NSForegroundColorAttributeName: NSColor.red,
                          NSFontAttributeName: NSFont.boldSystemFont(ofSize: 24)]
        let attributed = Attributed(attributes: attributes)
        let result = attributed.toString { aString }
        var range = NSRange()
        let foundAttributes = result.attributes(at: 0, effectiveRange: &range)
        XCTAssertEqual(foundAttributes.count, attributes.count)
        XCTAssertEqual(foundAttributes[NSForegroundColorAttributeName] as? NSColor,
                       attributes[NSForegroundColorAttributeName] as? NSColor)
        XCTAssertEqual(foundAttributes[NSFontAttributeName] as? NSFont,
                       attributes[NSFontAttributeName] as? NSFont)
        XCTAssertEqual(range.location, 0)
        XCTAssertEqual(range.length, result.length)
    }

    func testThatAttributedStringCanFormatted() {

        let plainAttributedString = NSAttributedString(string: aString)
        let attributed = Attributed(color: NSColor.red)
        let result = attributed.toString { plainAttributedString }
        var range = NSRange()
        let attributes = result.attributes(at: 0, effectiveRange: &range)
        XCTAssertEqual(attributes.count, 1)
        XCTAssertTrue(attributes.keys.contains(NSForegroundColorAttributeName))
        XCTAssertEqual(range.location, 0)
        XCTAssertEqual(range.length, result.length)
    }

    func testThatApplyingAttributesDoesntOverrideExistingAttributes() {

        let plainAttributedString = NSAttributedString(string: aString)
        let attributed = Attributed(color: NSColor.red)
        let result = attributed.toString { plainAttributedString }
        var range = NSRange()
        let attributes = result.attributes(at: 0, effectiveRange: &range)
        XCTAssertEqual(attributes.count, 1)
        XCTAssertTrue(attributes.keys.contains(NSForegroundColorAttributeName))
        XCTAssertEqual(range.location, 0)
        XCTAssertEqual(range.length, result.length)

        let greenAttributed = Attributed(color: NSColor.green)
        let finalResult = greenAttributed.toString { result }
        let finalAttributes = finalResult.attributes(at: 0, effectiveRange: &range)
        XCTAssertEqual(finalAttributes.count, 1)
        XCTAssertTrue(finalAttributes.keys.contains(NSForegroundColorAttributeName))
        XCTAssertEqual(finalAttributes[NSForegroundColorAttributeName] as? NSColor,
                       NSColor.red)
        XCTAssertEqual(range.location, 0)
        XCTAssertEqual(range.length, result.length)
    }

    func testAttributedStringsCanBeAddedTogether() {

        let firstString = NSAttributedString(string: aString)
        let secondString = NSAttributedString(string: aString)
        let result = firstString + secondString
        XCTAssertEqual(result.length, firstString.length + secondString.length)
    }

    func testAttributedAndPlainStringsCanBeAddedTogether() {

        let firstString = NSAttributedString(string: aString)
        let result = firstString + aString
        XCTAssertEqual(result.length, firstString.length + aString.characters.count)
        let resultOtherWay = aString + firstString
        XCTAssertEqual(resultOtherWay.length, firstString.length + aString.characters.count)
    }

    func testCanCombineStrings() {

        let attributed = Attributed
        let result = attributed.combine(strings: aString, aString, aString)
        XCTAssertEqual(result.length, (aString.characters.count * 3) + 2)
    }

    func testCanCominbeAttribtedStrings() {

        let firstString = NSAttributedString(string: aString)
        let attributed = Attributed
        let result = attributed.combine(strings: firstString, firstString, firstString)
        XCTAssertEqual(result.length, (firstString.length * 3) + 2)
    }

    func testCanCombineStringsWhileSpecifyingASeparator() {

        let attributed = Attributed
        let result = attributed.combine("", strings: aString, aString, aString)
        XCTAssertEqual(result.length, (aString.characters.count * 3))
    }

    func testCanCreateAnAttributedStringFromANSColor() {

        let result = NSColor.red.toString(aString)
        var range = NSRange()
        let attributes = result.attributes(at: 0, effectiveRange: &range)
        XCTAssertEqual(attributes.count, 1)
        XCTAssertTrue(attributes.keys.contains(NSForegroundColorAttributeName))
        XCTAssertEqual(range.location, 0)
        XCTAssertEqual(range.length, result.length)
    }

    func testCanCreateAnAttributedStringFromANSFont() {

        let result = NSFont.boldSystemFont(ofSize: 24).toString(aString)
        var range = NSRange()
        let attributes = result.attributes(at: 0, effectiveRange: &range)
        XCTAssertEqual(attributes.count, 1)
        XCTAssertTrue(attributes.keys.contains(NSFontAttributeName))
        let font = attributes[NSFontAttributeName] as? NSFont
        XCTAssertEqual(font, NSFont.boldSystemFont(ofSize: 24))
        XCTAssertEqual(range.location, 0)
        XCTAssertEqual(range.length, result.length)
    }
}
