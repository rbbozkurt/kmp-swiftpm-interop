package com.rbbozkurt.demo.dummypackage

object DummyWasmPackage : DummyPackage {
    override fun describe(): String = "This is a web target in KMP"

}

actual fun getDummyPackage(): DummyPackage = DummyWasmPackage