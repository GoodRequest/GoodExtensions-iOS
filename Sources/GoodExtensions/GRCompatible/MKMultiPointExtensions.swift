//
//  MKMultiPoint.swift
//  GoodExtensions
//
//  Created by Dominik Pethö on 4/30/19.
//  Copyright © 2020 GoodRequest. All rights reserved.
//

import MapKit

@available(*, deprecated, message: "This extension is deprecated and marked for removal")
public extension GRActive where Base == MKMultiPoint {

    /// An array of MKMapPoint that represent the individual points in the multi-point shape.
    var points: [MKMapPoint] { Array(UnsafeBufferPointer(start: base.points(), count: base.pointCount)) }

}
