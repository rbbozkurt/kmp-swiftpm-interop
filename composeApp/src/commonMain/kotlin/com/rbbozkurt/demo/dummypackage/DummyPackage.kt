package com.rbbozkurt.demo.dummypackage

interface DummyPackage {
    fun describe() : String
}

expect fun getDummyPackage() : DummyPackage
