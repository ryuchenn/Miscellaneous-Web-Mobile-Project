buildscript {
    repositories {
        google()
        mavenCentral()
    }
}

plugins{
    id("com.android.application") version "8.7.2" apply false
    id("com.android.library") version "8.7.2" apply false
    id("org.jetbrains.kotlin.android") version "1.9.21" apply false
    id("com.google.devtools.ksp") version "1.9.21-1.0.15" apply false
}

tasks.register("clean", Delete::class) {
    delete(rootProject.buildDir)
}





