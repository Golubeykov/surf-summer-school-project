//
//  PhoneMask.swift
//  SurfSummerSchoolProject
//
//  Created by Антон Голубейков on 19.08.2022.
//

import Foundation

func applyPhoneMask(phoneNumber: String, shouldRemoveLastDigit: Bool) -> String {
    let maxNumberCountInPhoneNumberField = 11
    var regex: NSRegularExpression? {
        do {
            let regexExpression = try NSRegularExpression(pattern: "[\\+\\s-\\(\\)]", options: .caseInsensitive)
            return regexExpression
        } catch {
            print(error)
            return nil
        }
    }
    let range = NSString(string: phoneNumber).range(of: phoneNumber)
    guard let regex = regex else { return "\(phoneNumber)" }
    guard !(shouldRemoveLastDigit && phoneNumber.count <= 2 && phoneNumber.count >= 1) else { return "" }
    
    var number = regex.stringByReplacingMatches(in: phoneNumber, options: [], range: range, withTemplate: "")
    
    if number.count > maxNumberCountInPhoneNumberField {
        let maxIndex = number.index(number.startIndex, offsetBy: maxNumberCountInPhoneNumberField)
        number = String(number[number.startIndex..<maxIndex])
    }
    if shouldRemoveLastDigit {
        let maxIndex = number.index(number.startIndex, offsetBy: number.count - 1)
        number = String(number[number.startIndex..<maxIndex])
    }
    
    let maxIndex = number.index(number.startIndex, offsetBy: number.count)
    let regRange = number.startIndex..<maxIndex
    
    if number.count <= 4 {
        let pattern = "(\\d)(\\d+)"
        number = number.replacingOccurrences(of: pattern, with: "$1 ($2)", options: .regularExpression, range: regRange)
    } else if number.count <= 7 {
        let pattern = "(\\d)(\\d{3})(\\d+)"
        number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3", options: .regularExpression, range: regRange)
    } else if number.count < 10 {
        let pattern = "(\\d)(\\d{3})(\\d{3})(\\d+)"
        number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3 $4", options: .regularExpression, range: regRange)
    } else {
        let pattern = "(\\d)(\\d{3})(\\d{3})(\\d{2})(\\d+)"
        number = number.replacingOccurrences(of: pattern, with: "$1 ($2) $3 $4 $5", options: .regularExpression, range: regRange)
    }
    return "+" + number
}

func clearPhoneNumberFromMask(phoneNumber: String) -> String {
    let phoneNumberClearedFromSymbols = phoneNumber.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: " ", with: "")
    return phoneNumberClearedFromSymbols
}
