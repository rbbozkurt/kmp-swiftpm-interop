package com.rbbozkurt.demo.dummypackage

object DummyAndroidPackage : DummyPackage {
    override fun describe(): String = "This is a Android target in KMP"

}

actual fun getDummyPackage(): DummyPackage = DummyAndroidPackage