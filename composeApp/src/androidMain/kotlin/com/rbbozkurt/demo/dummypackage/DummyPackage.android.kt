package com.rbbozkurt.demo.dummypackage

class DummyAndroidPackage : DummyPackage {
    override fun describe(): String = "This is a Android target in KMP"

}

actual fun getDummyPackage(): DummyPackage = DummyAndroidPackage()