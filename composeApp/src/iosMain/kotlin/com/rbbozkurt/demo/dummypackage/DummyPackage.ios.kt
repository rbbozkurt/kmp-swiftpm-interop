package com.rbbozkurt.demo.dummypackage

import kotlinx.cinterop.ExperimentalForeignApi
import SwiftPackage.SwiftPackageObjC

/**
 * iOS-specific implementation of the [DummyPackage] interface.
 *
 * This class demonstrates how Kotlin/Native can interoperate with a Swift Package Manager (SPM)
 * dependency that exposes an Objective-C API (via wrapper). It utilizes the `SwiftPackageObjC`
 * class, which internally wraps Swift logic.
 */
@OptIn(ExperimentalForeignApi::class) // Required for interop with Objective-C APIs in Kotlin/Native
class DummyIosPackage : DummyPackage {

    // Reference to the Objective-C wrapper, which internally calls Swift code
    private val spm = SwiftPackageObjC()

    // Description prefix specific to the iOS target
    private val desc = "This is iOS target code in KMP"

    /**
     * Returns a formatted string that includes:
     * 1. iOS-specific description
     * 2. Indented output of the SPM describe() function, delegated through ObjC
     *
     * This method demonstrates how deeply nested Kotlin–ObjC–Swift interop behaves in practice.
     */
    override fun describe(): String {
        val innerDescription = spm.describe()
            ?.lines()
            ?.joinToString("\n") { "  $it" }

        return "$desc calling:\n{\n$innerDescription\n}"
    }
}

/**
 * Factory function for the iOS target.
 *
 * This fulfills the `expect fun getDummyPackage()` declaration from `commonMain`.
 * When called from shared/common code, this returns the iOS-specific implementation.
 */
actual fun getDummyPackage(): DummyPackage = DummyIosPackage()
