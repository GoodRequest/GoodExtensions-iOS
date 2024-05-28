//
//  VersionTests.swift
//  GoodStructs
//
//  Created by Filip Šašala on 14/02/2024.
//

import XCTest
import GoodStructs
import GoodMacros

@available(iOS 16.0, *)
@available(macOS 13.0, *)
final class VersionTests: XCTestCase {

    struct VersionContainer: Codable {
        let version: Version
    }

    // MARK: - Initialization Tests

    func testVersionFromStringNoStage() throws {
        let versionString = "1.0.0"
        let tryMakeVersion = { try Version(string: versionString) }

        XCTAssertNoThrow(tryMakeVersion)

        let version = try tryMakeVersion()
        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 0)
        XCTAssertEqual(version.patch, 0)
        XCTAssertEqual(version.stage, .release)
        XCTAssertEqual(version.build, 0)
        XCTAssertEqual(version.suffix, nil)
    }

    func testVersionFromStringOnlyMajor() throws {
        let versionString = "1-alpha"
        let version = try Version(string: versionString)

        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 0)
        XCTAssertEqual(version.patch, 0)
        XCTAssertEqual(version.stage, .alpha)
        XCTAssertEqual(version.build, 0)
        XCTAssertEqual(version.suffix, nil)
    }

    func testVersionFromStringOnlyMajorAndBuild() throws {
        let versionString = "1-beta.2"
        let version = try Version(string: versionString)

        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 0)
        XCTAssertEqual(version.patch, 0)
        XCTAssertEqual(version.stage, .beta)
        XCTAssertEqual(version.build, 2)
        XCTAssertEqual(version.suffix, nil)
    }

    func testVersionFromStringOnlyMajorMinor() throws {
        let versionString = "1.2-alpha"
        let version = try Version(string: versionString)

        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 2)
        XCTAssertEqual(version.patch, 0)
        XCTAssertEqual(version.stage, .alpha)
        XCTAssertEqual(version.build, 0)
        XCTAssertEqual(version.suffix, nil)
    }

    func testVersionFromStringOnlyMajorMinorPatch() throws {
        let versionString = "1.2.31-alpha"
        let version = try Version(string: versionString)

        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 2)
        XCTAssertEqual(version.patch, 31)
        XCTAssertEqual(version.stage, .alpha)
        XCTAssertEqual(version.build, 0)
        XCTAssertEqual(version.suffix, nil)
    }

    func testVersionFromStringOnlyMajorAndSuffix() throws {
        let versionString = "1-alpha+ew"
        let version = try Version(string: versionString)

        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 0)
        XCTAssertEqual(version.patch, 0)
        XCTAssertEqual(version.stage, .alpha)
        XCTAssertEqual(version.build, 0)
        XCTAssertEqual(version.suffix, "ew")
    }

    func testVersionFromStringOnlyMajorMinorAndSuffix() throws {
        let versionString = "1.22-alpha+ew"
        let version = try Version(string: versionString)

        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 22)
        XCTAssertEqual(version.patch, 0)
        XCTAssertEqual(version.stage, .alpha)
        XCTAssertEqual(version.build, 0)
        XCTAssertEqual(version.suffix, "ew")
    }

    func testVersionFromStringAlpha() throws {
        let versionString = "1.0.0-alpha.1"
        let version = try Version(string: versionString)

        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 0)
        XCTAssertEqual(version.patch, 0)
        XCTAssertEqual(version.stage, .alpha)
        XCTAssertEqual(version.build, 1)
        XCTAssertEqual(version.suffix, nil)
    }

    func testVersionFromStringBeta() throws {
        let versionString = "2.15.4-beta.8"
        let version = try Version(string: versionString)

        XCTAssertEqual(version.major, 2)
        XCTAssertEqual(version.minor, 15)
        XCTAssertEqual(version.patch, 4)
        XCTAssertEqual(version.stage, .beta)
        XCTAssertEqual(version.build, 8)
        XCTAssertEqual(version.suffix, nil)
    }

    func testVersionFromStringReleaseCandidate() throws {
        let versionString = "3.5.0-rc.2"
        let version = try Version(string: versionString)

        XCTAssertEqual(version.major, 3)
        XCTAssertEqual(version.minor, 5)
        XCTAssertEqual(version.patch, 0)
        XCTAssertEqual(version.stage, .release)
        XCTAssertEqual(version.build, 2)
        XCTAssertEqual(version.suffix, nil)
    }

    func testVersionFromStringAlphaWithSuffix() throws {
        let versionString = "1.0.0-alpha.1+ew"
        let version = try Version(string: versionString)

        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 0)
        XCTAssertEqual(version.patch, 0)
        XCTAssertEqual(version.stage, .alpha)
        XCTAssertEqual(version.build, 1)
        XCTAssertEqual(version.suffix, "ew")
    }

    func testVersionFromStringAlphaWithSuffix2() throws {
        let versionString = "1.0.0-alpha.1+ew+2"
        let version = try Version(string: versionString)

        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 0)
        XCTAssertEqual(version.patch, 0)
        XCTAssertEqual(version.stage, .alpha)
        XCTAssertEqual(version.build, 1)
        XCTAssertEqual(version.suffix, "ew+2")
    }

    // MARK: - Branch name tests

    func testVersionFromBranchBitrise() throws {
        let branchName = "release/bitrise_1.0.0"
        let version = try Version(branchName: branchName)

        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 0)
        XCTAssertEqual(version.patch, 0)
        XCTAssertEqual(version.stage, .alpha)
        XCTAssertEqual(version.build, 0)
        XCTAssertEqual(version.suffix, nil)
    }

    func testVersionFromBranchBitriseOnlyMajor() throws {
        let branchName = "release/bitrise_2"
        let version = try Version(branchName: branchName)

        XCTAssertEqual(version.major, 2)
        XCTAssertEqual(version.minor, 0)
        XCTAssertEqual(version.patch, 0)
        XCTAssertEqual(version.stage, .alpha)
        XCTAssertEqual(version.build, 0)
        XCTAssertEqual(version.suffix, nil)
    }

    func testVersionFromBranchBitriseOnlyMajorWithSuffix() throws {
        let branchName = "release/bitrise_2+ew"
        let version = try Version(branchName: branchName)

        XCTAssertEqual(version.major, 2)
        XCTAssertEqual(version.minor, 0)
        XCTAssertEqual(version.patch, 0)
        XCTAssertEqual(version.stage, .alpha)
        XCTAssertEqual(version.build, 0)
        XCTAssertEqual(version.suffix, "ew")
    }

    func testVersionFromBranchTestflightOnlyMajorMinor() throws {
        let branchName = "release/testflight_dev_2.152"
        let version = try Version(branchName: branchName)

        XCTAssertEqual(version.major, 2)
        XCTAssertEqual(version.minor, 152)
        XCTAssertEqual(version.patch, 0)
        XCTAssertEqual(version.stage, .beta)
        XCTAssertEqual(version.build, 0)
        XCTAssertEqual(version.suffix, nil)
    }

    func testVersionFromBranchTestflight() throws {
        let branchName = "release/testflight_dev_2.15.4"
        let version = try Version(branchName: branchName)

        XCTAssertEqual(version.major, 2)
        XCTAssertEqual(version.minor, 15)
        XCTAssertEqual(version.patch, 4)
        XCTAssertEqual(version.stage, .beta)
        XCTAssertEqual(version.build, 0)
        XCTAssertEqual(version.suffix, nil)
    }

    func testVersionFromBranchTestflightRelease() throws {
        let branchName = "release/testflight_release_3.5.0"
        let version = try Version(branchName: branchName)

        XCTAssertEqual(version.major, 3)
        XCTAssertEqual(version.minor, 5)
        XCTAssertEqual(version.patch, 0)
        XCTAssertEqual(version.stage, .release)
        XCTAssertEqual(version.build, 0)
        XCTAssertEqual(version.suffix, nil)
    }

    func testVersionFromBranchBitriseWithSuffix() throws {
        let branchName = "release/bitrise_1.0.0+ew"
        let version = try Version(branchName: branchName)

        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 0)
        XCTAssertEqual(version.patch, 0)
        XCTAssertEqual(version.stage, .alpha)
        XCTAssertEqual(version.build, 0)
        XCTAssertEqual(version.suffix, "ew")
    }

    func testVersionFromBranchBitriseWithSuffix2() throws {
        let branchName = "release/bitrise_1.0.0+ew+2"
        let version = try Version(branchName: branchName)

        XCTAssertEqual(version.major, 1)
        XCTAssertEqual(version.minor, 0)
        XCTAssertEqual(version.patch, 0)
        XCTAssertEqual(version.stage, .alpha)
        XCTAssertEqual(version.build, 0)
        XCTAssertEqual(version.suffix, "ew+2")
    }

    func testVersionFromBranchTestflightWithSuffix() throws {
        let branchName = "release/testflight_dev_2.15.4+ew"
        let version = try Version(branchName: branchName)

        XCTAssertEqual(version.major, 2)
        XCTAssertEqual(version.minor, 15)
        XCTAssertEqual(version.patch, 4)
        XCTAssertEqual(version.stage, .beta)
        XCTAssertEqual(version.build, 0)
        XCTAssertEqual(version.suffix, "ew")
    }

    func testVersionFromBranchTestflightReleaseWithSuffix() throws {
        let branchName = "release/testflight_release_3.5.0+ew"
        let version = try Version(branchName: branchName)

        XCTAssertEqual(version.major, 3)
        XCTAssertEqual(version.minor, 5)
        XCTAssertEqual(version.patch, 0)
        XCTAssertEqual(version.stage, .release)
        XCTAssertEqual(version.build, 0)
        XCTAssertEqual(version.suffix, "ew")
    }

    // MARK: - Description Tests

    func testVersionToString() throws {
        let versionString = "1.0.0-alpha.1"
        let version = try Version(string: versionString)

        XCTAssertEqual(version.description, versionString)
    }

    func testVersionToStringWithSuffix() throws {
        let versionString = "1.0.0-alpha.1+ew"
        let version = try Version(string: versionString)

        XCTAssertEqual(version.description, versionString)
    }

    func testVersionToStringWithSuffixEmpty() throws {
        let versionString = "1.0.0-alpha.1+"
        let version = try Version(string: versionString)

        XCTAssertEqual(version.description, "1.0.0-alpha.1")
    }

    func testVersionToStringPlain() throws {
        let versionString = "2.3.5"
        let version = try Version(string: versionString)

        XCTAssertEqual(version.description, "2.3.5")
        XCTAssertEqual(version.debugDescription, "2.3.5-release.0")
    }

    // MARK: - Ordering tests

    func testVersionOrdering() throws {
        let version1 = Version()                                                               // 1.0.0
        let version11 = Version(major: 1, minor: 1)                                            // 1.1.0
        let version111 = Version(major: 1, minor: 1, patch: 1)                                 // 1.1.1
        let version2a0 = Version(major: 2, prerelease: .alpha)                                 // 2.0.0-alpha.0
        let version2b1 = Version(major: 2, prerelease: .beta, build: 1)                        // 2.0.0-beta.1
        let version2b1a = Version(major: 2, prerelease: .beta, build: 1, suffix: "a")          // 2.0.0-beta.1+a
        let version2b1b = Version(major: 2, prerelease: .beta, build: 1, suffix: "b")          // 2.0.0-beta.1+b
        let version2 = Version(major: 2)                                                       // 2.0.0
        let version21 = Version(major: 2, minor: 1)                                            // 2.1.0
        let version211a3 = Version(major: 2, minor: 1, patch: 1, prerelease: .alpha, build: 3) // 2.1.1-alpha.3
        let version211 = Version(major: 2, minor: 1, patch: 1)                                 // 2.1.1

        XCTAssertLessThan(version1, version11)
        XCTAssertLessThan(version11, version111)
        XCTAssertLessThan(version111, version2)
        XCTAssertLessThan(version2, version21)
        XCTAssertLessThan(version21, version211)

        XCTAssertGreaterThan(version211a3, version21)
        XCTAssertLessThan(version211a3, version211)

        XCTAssertLessThan(version2b1a, version2b1b)
        XCTAssertLessThan(version2b1a, version2)
        XCTAssertGreaterThan(version2b1b, version2b1a)
        XCTAssertGreaterThan(version2b1a, version2a0)

        XCTAssertLessThan(version2b1, version2b1a)

        XCTAssertEqual(version211a3, version211a3)
    }

    // MARK: - Codable Tests

    func testVersionDecodable() throws {
        let jsonString = "{\"version\":\"1\"}"
        let jsonData = jsonString.data(using: .utf8)!

        let originalDecodeVersion = Version(major: 1, minor: 0, patch: 0)
        let decodedContainer = try JSONDecoder().decode(VersionContainer.self, from: jsonData)

        XCTAssertEqual(originalDecodeVersion, decodedContainer.version)
    }

    func testVersionEncodable() throws {
        let originalEncodeVersion = Version(
            major: 2,
            minor: 3,
            patch: 6,
            prerelease: .beta,
            build: 4,
            suffix: "test"
        )
        let originalEncodeVersionContainer = VersionContainer(version: originalEncodeVersion)
        let originalEncodeVersionContainerString = "{\"version\":\"2.3.6-beta.4+test\"}"
        let encodedData = try JSONEncoder().encode(originalEncodeVersionContainer)
        let encodedString = String(data: encodedData, encoding: .utf8)!

        XCTAssertEqual(encodedString, originalEncodeVersionContainerString)
    }

}
