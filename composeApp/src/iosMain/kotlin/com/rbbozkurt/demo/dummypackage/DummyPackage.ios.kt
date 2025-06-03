package com.rbbozkurt.demo.dummypackage

import kotlinx.cinterop.ExperimentalForeignApi
import SwiftPackage.SwiftPackageObjC

@OptIn(ExperimentalForeignApi::class)
class DummyIosPackage : DummyPackage {
    private val spm = SwiftPackageObjC()
    private val desc = "This is iOS target code in KMP"

    override fun describe(): String {
        val innerDescription = spm.describe()
            ?.lines()
            ?.joinToString("\n") { "  $it" }

        return "$desc calling:\n{\n$innerDescription\n}"
    }


}

actual fun getDummyPackage() : DummyPackage = DummyIosPackage()