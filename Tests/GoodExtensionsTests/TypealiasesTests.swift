//
//  TypealiasesTests.swift
//  
//
//  Created by Filip Šašala on 01/07/2024.
//

import XCTest
import GoodExtensions

final class TypealiasesTests: XCTestCase {

    func testTypealiases() {
        let a: VoidClosure
        let b: Supplier<String>
        let c: Consumer<String>
        let d: BiConsumer<String, Int>
        let e: GoodExtensions.Predicate<String>
        let f: Function<String, Int>

        let g: NonSendableVoidClosure
        let h: NonSendableSupplier<String>
        let i: NonSendableConsumer<String>
        let j: NonSendableBiConsumer<String, Int>
        let k: NonSendablePredicate<String>
        let l: NonSendableFunction<String, Int>

        let m: ThrowingVoidClosure<NSError>
        let n: ThrowingSupplier<String, NSError>
        let o: ThrowingConsumer<String, NSError>
        let p: ThrowingBiConsumer<String, Int, NSError>
        let q: ThrowingPredicate<String, NSError>
        let r: ThrowingFunction<String, Int, NSError>

        let s: MainClosure
        let t: MainSupplier<String>
        let u: MainConsumer<String>
        let v: MainBiConsumer<String, Int>
        let w: MainPredicate<String>
        let x: MainFunction<String, Int>

        let y: MainThrowingVoidClosure<NSError>
        let z: MainThrowingSupplier<String, NSError>
        let aa: MainThrowingConsumer<String, NSError>
        let ab: MainThrowingBiConsumer<String, Int, NSError>
        let ac: MainThrowingPredicate<String, NSError>
        let ad: MainThrowingFunction<String, Int, NSError>
    }

}
