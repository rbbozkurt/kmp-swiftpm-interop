package com.rbbozkurt.demo

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform