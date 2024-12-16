package com.example.todoapp

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach

fun <T> Flow<T>.subscribe(
    onEach: (T) -> Unit
): Job {
    return this.onEach {
        onEach(it)
    }.launchIn(CoroutineScope(Dispatchers.Main))
}
