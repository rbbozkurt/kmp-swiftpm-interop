package com.rbbozkurt.demo.dummypackage

import kotlinx.cinterop.ExperimentalForeignApi
import SwiftPackage.SwiftPackage

@OptIn(ExperimentalForeignApi::class)
object DummyIosPackage : DummyPackage {
    private val spm = SwiftPackage()
    private val desc = "This is IOS target code in KMP"

    override fun describe() = "${desc} calling:\n{\n\t${spm.describe()}\n} "

}

actual fun getDummyPackage() : DummyPackage = DummyIosPackage