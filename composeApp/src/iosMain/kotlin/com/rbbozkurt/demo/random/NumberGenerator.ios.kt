package com.rbbozkurt.demo.random

import RNG.RandomNumberGenerator
import kotlinx.cinterop.ExperimentalForeignApi

@OptIn(ExperimentalForeignApi::class)
class IosNumberGenerator : NumberGenerator {
    val randomNumberGenerator = RandomNumberGenerator()
    override fun generate(min: Int, max: Int): Int {
        return randomNumberGenerator
            .generateWithMin(min.toLong(), max.toLong()).toInt()
    }

}

actual fun getNumberGenerator(): NumberGenerator = IosNumberGenerator()

