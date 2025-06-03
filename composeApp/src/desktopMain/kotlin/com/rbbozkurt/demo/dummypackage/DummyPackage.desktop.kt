package com.rbbozkurt.demo.dummypackage


class DummyDesktopPackage : DummyPackage {
    override fun describe(): String = "This is a desktop target in KMP"

}
actual fun getDummyPackage(): DummyPackage = DummyDesktopPackage()