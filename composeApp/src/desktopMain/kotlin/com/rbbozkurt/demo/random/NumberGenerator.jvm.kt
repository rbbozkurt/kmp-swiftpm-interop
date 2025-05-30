package com.rbbozkurt.demo.random

actual class NumberGenerator {
    actual fun generate(min: Int, max: Int): Int {
        return kotlin.math.max(max, min)
    }
}