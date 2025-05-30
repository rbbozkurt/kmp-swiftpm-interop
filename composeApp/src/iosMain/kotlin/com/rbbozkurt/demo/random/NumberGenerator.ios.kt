package com.rbbozkurt.demo.random

import RNGSwift.RandomNumberGenerator
import kotlinx.cinterop.ExperimentalForeignApi
@OptIn(ExperimentalForeignApi::class)
class IosNumberGenerator : NumberGenerator {
    val randomNumberGenerator = RandomNumberGenerator()
    override fun generate(min: Int, max: Int): Int {
        return randomNumberGenerator
            .generateWithMin(min, max)
    }

}

actual fun getNumberGenerator(): NumberGenerator = IosNumberGenerator()

