package com.rbbozkurt.demo.dummypackage

class DummyWasmPackage : DummyPackage {
    override fun describe(): String = "This is a web target in KMP"

}

actual fun getDummyPackage(): DummyPackage = DummyWasmPackage()