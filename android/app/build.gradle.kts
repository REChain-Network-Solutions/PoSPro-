plugins {
    id("com.android.application")
    id("kotlin-android")
    // id("com.google.gms.google-services")  // Временно отключено для сборки
    // id("com.huawei.agconnect")  // Временно отключено для сборки
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.delus.pos"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.modus.pos"
        // You can update the following values to match your application needs.
        // For more information, see: https://docs.flutter.dev/deployment/android#reviewing-the-gradle-build-configuration.
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // implementation("com.huawei.agconnect:agconnect-core:1.9.1.300")  // Временно отключено для сборки
    // Import the BoM for the Firebase platform
    // implementation(platform("com.google.firebase:firebase-bom:33.0.0"))  // Временно отключено для сборки
    
    // Add the dependency for the Firebase Authentication library
    // When using the BoM, you don't specify versions in Firebase library dependencies
    // implementation("com.google.firebase:firebase-auth")  // Временно отключено для сборки
    // implementation("com.google.firebase:firebase-analytics")  // Временно отключено для сборки
    // implementation("com.google.firebase:firebase-messaging")  // Временно отключено для сборки
    // implementation("com.google.firebase:firebase-crashlytics")  // Временно отключено для сборки
    // implementation("com.google.firebase:firebase-perf")  // Временно отключено для сборки
}

flutter {
    source = "../.."
}
