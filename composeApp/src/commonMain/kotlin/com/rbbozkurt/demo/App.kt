package com.rbbozkurt.demo

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.rbbozkurt.demo.random.getNumberGenerator
import org.jetbrains.compose.ui.tooling.preview.Preview

@Composable
@Preview
fun App() {
    MaterialTheme {
        var showContent by remember { mutableStateOf(false) }
        var lowerText by remember { mutableStateOf("0") }
        var upperText by remember { mutableStateOf("100") }

        val lowerBound = lowerText.toIntOrNull() ?: 0
        val upperBound = upperText.toIntOrNull() ?: 100

        var random by remember { mutableStateOf<Int?>(null) }

        Column(
            modifier = Modifier
                .safeContentPadding()
                .fillMaxSize()
                .padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically
            ) {
                TextField(
                    value = lowerText,
                    onValueChange = { lowerText = it },
                    label = { Text("Lower Bound") },
                    modifier = Modifier.weight(1f)
                )
                Spacer(Modifier.width(8.dp))
                TextField(
                    value = upperText,
                    onValueChange = { upperText = it },
                    label = { Text("Upper Bound") },
                    modifier = Modifier.weight(1f)
                )
            }

            Spacer(Modifier.height(16.dp))

            Button(onClick = {
                random = getNumberGenerator().generate(lowerBound, upperBound)
                showContent = true
            }) {
                Text("Generate!")
            }

            Spacer(Modifier.height(16.dp))

            AnimatedVisibility(visible = showContent && random != null) {
                Column(
                    Modifier.fillMaxWidth(),
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Text("Random: ${random}")
                }
            }
        }
    }
}
