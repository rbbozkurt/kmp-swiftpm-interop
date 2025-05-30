package com.rbbozkurt.demo.random

import RNGSwift.RandomNumberGenerator
import kotlinx.cinterop.ExperimentalForeignApi

@OptIn(ExperimentalForeignApi::class)
class RNGKWrapper {
    private val generator = RandomNumberGenerator()

    fun generate(min: Int, max: Int): Int {
        return generator.generateWithMin(min = min, max = max)
    }
}