//
//  Version.swift
//  GoodStructs
//
//  Created by Filip Šašala on 28/05/2024.
//

import Foundation
import RegexBuilder

// MARK: - Version

@available(iOS 16.0, *)
@available(macOS 13.0, *)
public struct Version {

    public var major: UInt
    public var minor: UInt
    public var patch: UInt
    public var stage: ReleaseStage
    public var build: UInt
    public var suffix: String?

    public init(
        major: UInt = 1,
        minor: UInt = 0,
        patch: UInt = 0,
        prerelease: ReleaseStage = .release,
        build: UInt = 0,
        suffix: String? = nil
    ) {
        self.major = major
        self.minor = minor
        self.patch = patch
        self.stage = prerelease
        self.build = build
        self.suffix = suffix
    }

    public init(string: String) throws {
        let majorVersion = TryCapture {
            OneOrMore(.digit)
        } transform: { major in
            UInt(major)
        }
        let minorVersion = Optionally {
            TryCapture {
                OneOrMore(.digit)
            } transform: { minor in
                UInt(minor)
            }
        }
        let patchVersion = Optionally {
            TryCapture {
                OneOrMore(.digit)
            } transform: { patch in
                UInt(patch)
            }
        }
        let releaseStage = Optionally {
            TryCapture {
                OneOrMore(.word)
            } transform: { stage in
                ReleaseStage(rawValue: String(stage))
            }
        }
        let buildNumber = Optionally {
            TryCapture {
                OneOrMore(.digit)
            } transform: { build in
                UInt(build)
            }
        }
        let suffix = Optionally {
            TryCapture {
                OneOrMore(.any)
            } transform: { suffix in
                String(suffix)
            }
        }

        let regex = Regex {
            majorVersion
            Optionally(".")
            minorVersion
            Optionally(".")
            patchVersion
            // Stage
            Optionally("-")
            releaseStage
            // Bulid number
            Optionally(".")
            buildNumber
            // Suffix
            Optionally("+")
            suffix
        }

        if let result = string.firstMatch(of: regex)?.output {
            let major = result.1
            let minor = result.2 ?? 0
            let patch = result.3 ?? 0
            let stage = result.4 ?? .release
            let build = result.5 ?? 0
            let suffix = result.6

            self.major = major
            self.minor = minor
            self.patch = patch
            self.stage = stage
            self.build = build
            self.suffix = suffix
        } else {
            throw VersionError.invalidVersion(string)
        }
    }

    public init(branchName string: String) throws {
        let majorVersion = TryCapture {
            OneOrMore(.digit)
        } transform: { major in
            UInt(major)
        }
        let minorVersion = Optionally {
            TryCapture {
                OneOrMore(.digit)
            } transform: { minor in
                UInt(minor)
            }
        }
        let patchVersion = Optionally {
            TryCapture {
                OneOrMore(.digit)
            } transform: { patch in
                UInt(patch)
            }
        }
        let releaseStage = TryCapture {
            OneOrMore(.any)
        } transform: { stage in
            ReleaseStage(rawValue: String(stage))
        }
        let suffix = Optionally {
            TryCapture {
                OneOrMore(.any)
            } transform: { suffix in
                String(suffix)
            }
        }

        let regex = Regex {
            "release/"
            // Release stage
            releaseStage
            "_"
            // Release version
            majorVersion
            Optionally(".")
            minorVersion
            Optionally(".")
            patchVersion
            // Suffix
            Optionally("+")
            suffix
        }

        if let result = string.firstMatch(of: regex)?.output {
            self.major = result.2
            self.minor = result.3 ?? 0
            self.patch = result.4 ?? 0
            self.stage = result.1
            self.build = 0
            self.suffix = result.5
        } else {
            throw VersionError.invalidVersion(string)
        }
    }

}

// MARK: - CustonStringConvertible

@available(iOS 16.0, *)
@available(macOS 13.0, *)
extension Version: CustomStringConvertible, CustomDebugStringConvertible {

    public var description: String {
        let usesBuildStages = !(stage == .release && build == 0)

        if usesBuildStages {
            return debugDescription
        } else {
            return version
        }
    }

    public var debugDescription: String {
        if let suffix, !suffix.isEmpty {
            return "\(major).\(minor).\(patch)-\(stage).\(build)+\(suffix)"
        } else {
            return "\(major).\(minor).\(patch)-\(stage).\(build)"
        }
    }

    public var version: String {
        "\(major).\(minor).\(patch)"
    }

}

// MARK: - Equatable, Comparable

@available(iOS 16.0, *)
@available(macOS 13.0, *)
extension Version: Equatable, Comparable {

    public static func == (lhs: Version, rhs: Version) -> Bool {
        lhs.major == rhs.major
        && lhs.minor == rhs.minor
        && lhs.patch == rhs.patch
        && lhs.stage == rhs.stage
        && lhs.build == rhs.build
    }

    public static func < (lhs: Version, rhs: Version) -> Bool {
        if lhs.major != rhs.major {
            return lhs.major < rhs.major
        } else if lhs.minor != rhs.minor {
            return lhs.minor < rhs.minor
        } else if lhs.patch != rhs.patch {
            return lhs.patch < rhs.patch
        } else if lhs.stage.comparableValue != rhs.stage.comparableValue {
            return lhs.stage.comparableValue < rhs.stage.comparableValue
        } else if lhs.build != rhs.build {
            return lhs.build < rhs.build
        } else {
            return (lhs.suffix ?? "") < (rhs.suffix ?? "")
        }
    }

}

// MARK: - Codable

@available(iOS 16.0, *)
@available(macOS 13.0, *)
extension Version: Codable {

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let versionString = try container.decode(String.self)

        try self.init(string: versionString)
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.description)
    }

}

// MARK: - Parser, Formatter

@available(iOS 16.0, *)
@available(macOS 13.0, *)
public struct VersionParseStrategy: ParseStrategy {

    public typealias ParseInput = String
    public typealias ParseOutput = Version

    public init() {}

    public func parse(_ value: String) throws -> Version {
        try Version(string: value)
    }

}

@available(iOS 16.0, *)
@available(macOS 13.0, *)
public struct VersionFormatStyle: ParseableFormatStyle {

    public typealias Strategy = VersionParseStrategy
    public typealias FormatInput = Version
    public typealias FormatOutput = String

    public init() {}

    public var parseStrategy: Strategy {
        Strategy()
    }

    public func format(_ value: Version) -> String {
        value.version
    }

}

// MARK: - Stage

@available(iOS 16.0, *)
@available(macOS 13.0, *)
public enum ReleaseStage: String {

    case alpha
    case beta
    case release

    public init?(rawValue: String) {
        switch rawValue {
        case "alpha", "bitrise":
            self = .alpha

        case "beta", "testflight_dev", "testflight":
            self = .beta

        case "rc", "release", "testflight_release", "appstore":
            self = .release

        default:
            return nil
        }
    }

    public var comparableValue: UInt {
        switch self {
        case .alpha:
            return 1

        case .beta:
            return 2

        case .release:
            return 3
        }
    }

}

// MARK: - Errors

@available(iOS 16.0, *)
@available(macOS 13.0, *)
public enum VersionError: Error {

    case invalidVersion(String)

}
