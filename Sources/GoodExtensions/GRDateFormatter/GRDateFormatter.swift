//
//  GRDateFormatter.swift
//
//
//  Created by GoodRequest on 13/02/2023.
//

import UIKit
import GRCompatible
import GoodStructs

public final class GRDateFormatter {

    public static let shared = GRDateFormatter()

    public let formatter = DateFormatter()
    public let relativeFormatter = RelativeDateTimeFormatter()

    private init() {}

}

// MARK: - Relative

public extension GRDateFormatter {

    /// Get the relative string representation of the given `date` relative to the given `relativeTo` date.
    ///
    /// - Parameters:
    ///   - date: The date to which the relative string should be calculated.
    ///   - relativeTo: The date relative to which the `date` should be calculated.
    ///
    ///- Returns: A localized string representing the relative date.
    func getRelativeDateString(date: Date, relativeTo: Date) -> String {
        return relativeFormatter.localizedString(for: date, relativeTo: relativeTo)
    }

    /// Get the relative string representation of the given `timeInterval`.
    ///
    /// - Parameters:
    /// - timeInterval: The time interval for which the relative string should be calculated.
    ///- Returns: A localized string representing the relative date.
    func getRelativeDateString(from timeInterval: TimeInterval) -> String {
        return relativeFormatter.localizedString(fromTimeInterval: timeInterval)
    }


    /// Get the relative string representation of the given `dateCompoents`.
    ///
    /// - Parameters:
    /// - dateCompoents: The date components to which the relative string should be calculated.
    ///- Returns: A localized string representing the relative date.
    func getRelativeDateString(dateCompoents: DateComponents) -> String {
        return relativeFormatter.localizedString(from: dateCompoents)
    }


}

public extension GRDateFormatter {

    /// Determines whether the given year is a leap year or not.
    ///
    /// - Parameters:
    ///   - year: The year to check.
    /// - Returns: `true` if the given `year` is a leap year; otherwise, `false`.
    func isLeapYear(year: Int) -> Bool {
        if year % 4 != 0 {
            return false
        } else if year % 100 != 0 {
            return true
        } else if year % 400 != 0 {
            return false
        } else {
            return true
        }
    }

    /// Determines whether the current time is between the given `startTime` and `endTime`.
    ///
    /// - Parameters:
    ///   - startTime: The start time.
    ///   - endTime: The end time.
    ///   - format: The date format string.
    /// - Returns: `true` if the current time is between the `startTime` and `endTime`; otherwise, `false`.
    func isCurrentTimeBetween(startTime: String, endTime: String, format: String = "HH:mm") -> Bool {
        formatter.dateFormat = format

        let currentTimeString = formatter.string(from: Date())

        let startDate = formatter.date(from: startTime)
        let endDate = formatter.date(from: endTime)

        guard let currentTime = formatter.date(from: currentTimeString),
              let startTime = startDate,
              let endTime = endDate
        else {
            return false
        }

        return currentTime < endTime && currentTime >= startTime
    }

    /// Calculates the number of days between the given `startDate` and `endDate`.
    ///
    /// - Parameters:
    ///   - startDate: The starting date.
    ///   - endDate: The ending date.
    /// - Returns: The number of days between the `startDate` and `endDate`.
    func daysBetweenDates(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current

        let components = calendar.dateComponents([.day], from: startDate, to: endDate)

        return components.day ?? 0
    }

    /// Converts the given `text` to a `Date` object using the specified `format`.
    ///
    /// - Parameters:
    ///   - text: The text to convert.
    ///   - format: The date format string.
    /// - Returns: A `Date` object created from the given `text` using the specified `format`, or `nil` if the conversion fails.
    func date(from text: String, format: String) -> Date? {
        formatter.dateFormat = format

        return GRDateFormatter.shared.formatter.date(from: text)
    }

    /// Returns the current date as a string in the specified `format`.
    ///
    /// - Parameter format: The date format string.
    /// - Returns: The current date as a string in the specified `format`.
    @available(iOS, deprecated: 15.0, message: "Deprecated, since iOS 15.0 you should use '.formatted()' instead.")
    func stringFromCurrentDate(format: String) -> String {
        return string(from: Date(), format: format)
    }

    /// Converts the given `date` to a string using the specified `format`.
    ///
    /// - Parameters:
    ///   - date: The date to convert.
    ///   - format: The date format string.
    ///   - doesRelativeFormatting: Whether or not to use relative date formatting.
    /// - Returns: A string representation of the given `date` using the specified `format`.
    @available(iOS, deprecated: 15.0, message: "Deprecated, since iOS 15.0 you should use '.formatted()' instead.")
    func string(from date: Date, format: String, doesRelativeFormatting: Bool = false) -> String {
        formatter.dateFormat = format
        formatter.doesRelativeDateFormatting = doesRelativeFormatting


        return formatter.string(from: date)
    }

    /// Returns the name of the day (i.e. Monday, Tuesday, etc.) of the given date
    /// - Parameter date: The date for which to determine the name of the day. Defaults to the current date.
    /// - Returns: A string representing the name of the day of the given date.
    @available(iOS, deprecated: 15.0, message: "Deprecated, since iOS 15.0 you should use '.formatted()' instead.")
    func nameOfDay(date: Date = Date()) -> String {
        formatter.dateFormat = "EEEE"

        return formatter.string(from: date)
    }

}
