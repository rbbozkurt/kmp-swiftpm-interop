package com.rbbozkurt.demo.random

import kotlin.random.Random


class AndroidNumberGenerator : NumberGenerator {
    override fun generate(min: Int, max: Int): Int {
        return Random.nextInt(from = min, until = max + 1)
    }

}

actual fun getNumberGenerator(): NumberGenerator = AndroidNumberGenerator()
