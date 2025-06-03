package com.rbbozkurt.demo.dummypackage

/**
 * Common interface shared across all targets (e.g., Android, iOS).
 * Each platform provides its own implementation of this interface.
 */
interface DummyPackage {
    /**
     * Describes platform-specific logic or output.
     * This method is expected to be overridden in each platform-specific implementation.
     */
    fun describe(): String
}

/**
 * Platform-specific factory function to return an actual implementation of [DummyPackage].
 *
 * This function is marked with 'expect', meaning the actual implementation must be provided
 * in source sets like iosMain, androidMain, etc.
 */
expect fun getDummyPackage(): DummyPackage
