package com.rbbozkurt.demo.random


interface NumberGenerator {
    fun generate(min: Int, max: Int): Int
}
expect fun getNumberGenerator() : NumberGenerator
