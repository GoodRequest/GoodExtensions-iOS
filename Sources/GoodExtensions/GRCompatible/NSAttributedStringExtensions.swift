//
//  NSAttributedString.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

#if canImport(UIKit)
import UIKit

@available(*, deprecated, message: "This extension is deprecated and marked for removal")
public extension GRActive where Base: NSAttributedString {

    /// Creates an NSAttributedString from an HTML string, font, and color.
    ///
    /// - Parameters:
    ///   - html: The HTML string to be converted to an NSAttributedString.
    ///   - font: A tuple of UIFont objects representing the font to be used for regular and bold text respectively.
    ///   - color: The color to be applied to the text.
    ///   - documentAttributes: An optional pointer to a dictionary of document attributes.
    /// - Returns: An NSAttributedString or nil if the conversion fails.
    static func from(
        html: String?,
        font: (regular: UIFont, bold: UIFont),
        color: UIColor,
        documentAttributes: AutoreleasingUnsafeMutablePointer<NSDictionary?>? = nil
    ) -> NSAttributedString? {
        return from(
            html: html,
            font: font,
            size: font.regular.pointSize,
            color: color,
            documentAttributes: documentAttributes
        )
    }

    /// Generates an NSAttributedString from an HTML string.
    /// - Parameters:
    ///   - html: The HTML string to be converted to an NSAttributedString.
    ///   - font: An optional tuple of two fonts, regular and bold, to be used in the HTML string. If not provided, the default font will be used.
    ///   - size: The font size to be used in the HTML string.
    ///   - color: The color to be used as the foreground color of the NSAttributedString.
    ///   - documentAttributes: An optional parameter to pass in any additional document attributes.
    /// - Returns: An NSAttributedString representation of the HTML string, or nil if the HTML string is nil or empty.
    static func from(
        html: String?,
        font: (regular: UIFont, bold: UIFont)?,
        size: CGFloat,
        color: UIColor,
        documentAttributes: AutoreleasingUnsafeMutablePointer<NSDictionary?>? = nil
    ) -> NSAttributedString? {
        guard let html = html, !html.isEmpty else { return nil }

        var htmlWithFontType = ""

        if let font = font {
            htmlWithFontType = "<html><style>*{font-family: \(font.regular.fontName), -apple-system, HelveticaNeue !important; font-size: \(size) !important;}</style>\(html)</html>"
        } else {
            htmlWithFontType = "<html><style>*{font-family: -apple-system, HelveticaNeue !important; font-size: \(size) !important;}</style>\(html)</html>"
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html.rawValue,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        // Parse HTML
        // swiftlint:disable force_unwrapping
        guard let parsedHTML = try? NSAttributedString(
                data: htmlWithFontType.data(using: .unicode, allowLossyConversion: false)!,
                options: options,
                documentAttributes: documentAttributes
        ).mutableCopy() as? NSMutableAttributedString else {
            return nil
        }
        // swiftlint:enable force_unwrapping

        // Correct Bold Font
        if let font = font {
            parsedHTML.enumerateAttribute(
                .font,
                in: NSRange(location: 0, length: parsedHTML.length),
                options: .longestEffectiveRangeNotRequired
            ) { value, range, _ in
                if let currentFont = value as? UIFont {
                    if currentFont.fontName.contains("bold") || currentFont.fontName.contains("Bold") {
                        parsedHTML.gr.setFont(font.bold, range: range)
                    }
                }
            }
        }

        // Correct Foreground Color
        parsedHTML.gr.setColor(color)

        return parsedHTML
    }

}

@available(*, deprecated, message: "This extension is deprecated and marked for removal")
public extension GRActive where Base: NSMutableAttributedString {

    /// Add hyperlink to a specific text in an NSMutableAttributedString
    ///
    /// - Parameters:
    ///   - URL: The string representation of the URL that the text will be linked to
    ///   - text: The text that will be linked to the URL
    /// - Returns: True if the text was found and the link was added, False otherwise
    func addLink(URL: String, toText text: String) -> Bool {
        let range = base.mutableString.range(of: text)
        if range.location != NSNotFound {
            base.addAttribute(.link, value: URL, range: range)
            return true
        }
        return false
    }

    /// Append an NSAttributedString to an NSMutableAttributedString
    ///
    /// - Parameter string: The NSAttributedString that will be appended
    /// - Returns: The NSMutableAttributedString with the new string appended
    @discardableResult
    func append(string: NSAttributedString) -> NSMutableAttributedString {
        base.append(string)
        return base
    }

    /// Append a String to an NSMutableAttributedString
    ///
    /// - Parameter string: The String that will be appended
    /// - Returns: The NSMutableAttributedString with the new string appended
    @discardableResult
    func append(string: String) -> NSMutableAttributedString {
        return append(string: NSAttributedString(string: string))
    }

    // MARK: Color

    /// Set the text color of a range in an NSMutableAttributedString
    ///
    /// - Parameters:
    ///   - color: The color to be set
    ///   - range: The range in which the color will be applied
    /// - Returns: The NSMutableAttributedString with the color applied
    @discardableResult
    func setColor(_ color: UIColor, range: NSRange) -> NSMutableAttributedString {
        base.addAttributes([.foregroundColor: color], range: range)
        return base
    }

    /// Set the text color of an entire NSMutableAttributedString
    ///
    /// - Parameters:
    ///   - color: The color to be set
    /// - Returns: The NSMutableAttributedString with the color applied
    @discardableResult
    func setColor(_ color: UIColor) -> NSMutableAttributedString {
        return setColor(color, range: NSRange(location: 0, length: base.string.count))
    }

    // MARK: Font

    /// Set the font of a range in an NSMutableAttributedString
    ///
    /// - Parameters:
    ///   - font: The font to be set
    ///   - range: The range in which the font will be applied
    /// - Returns: The NSMutableAttributedString with the font applied
    @discardableResult
    func setFont(_ font: UIFont, range: NSRange) -> NSMutableAttributedString {
        base.addAttributes([.font: font], range: range)
        return base
    }

    /// Set the font of an entire  NSMutableAttributedString
    ///
    /// - Parameters:
    ///   - font: The font to be set
    /// - Returns: The NSMutableAttributedString with the font applied
    @discardableResult
    func setFont(_ font: UIFont) -> NSMutableAttributedString {
        return setFont(font, range: NSRange(location: 0, length: base.string.count))
    }

    // MARK: Text Alignment

    /// Sets text alignment for the specified range of the `NSMutableAttributedString`.
    ///
    /// - Parameters:
    ///   - alignment: The text alignment to set.
    ///   - range: The range of the text to align.
    /// - Returns: Returns the same `NSMutableAttributedString` instance.
    @discardableResult
    func setTextAlignment(_ alignment: NSTextAlignment, range: NSRange) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        base.addAttributes([.paragraphStyle: style], range: range)
        return base
    }


    /// Sets text alignment for the entire `NSMutableAttributedString`.
    ///
    /// - Parameter alignment: The text alignment to set.
    /// - Returns: Returns the same `NSMutableAttributedString` instance.
    func setTextAlignment(_ alignment: NSTextAlignment) -> NSMutableAttributedString {
        return setTextAlignment(alignment, range: NSRange(location: 0, length: base.string.count))
    }

}
#endif
