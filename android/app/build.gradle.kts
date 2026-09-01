import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Firma di release: keystore e password stanno in android/key.properties e
// android/upload-keystore.jks, entrambi fuori da git. Vedi RELEASE_CHECKLIST.md.
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties().apply {
    if (keystorePropertiesFile.exists()) {
        load(FileInputStream(keystorePropertiesFile))
    }
}

android {
    namespace = "com.blueinhope.joyo"
    compileSdk = flutter.compileSdkVersion
    // I plugin (google_mobile_ads, in_app_purchase, ecc.) richiedono un NDK
    // più nuovo di quello proposto dal Flutter Gradle Plugin.
    ndkVersion = "28.2.13676358"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // Richiesto da flutter_local_notifications (usa API java.time su
        // Android vecchi tramite desugaring).
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        applicationId = "com.blueinhope.joyo"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (keystorePropertiesFile.exists()) {
            create("release") {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storeFile = rootProject.file(keystoreProperties.getProperty("storeFile"))
                storePassword = keystoreProperties.getProperty("storePassword")
            }
        }
    }

    buildTypes {
        release {
            // Firma la release solo se il keystore c'è. Il controllo bloccante
            // sta in taskGraph (sotto): così `check()` non viene valutato in
            // configurazione — altrimenti farebbe fallire anche assembleDebug.
            if (keystorePropertiesFile.exists()) {
                signingConfig = signingConfigs.getByName("release")
            }
        }
    }
}

// Mai firmare una release con la chiave di debug: se si sta assemblando una
// release senza keystore, fallisci con un errore chiaro. Va valutato a
// task-graph pronto, non in configurazione, per non toccare le build di debug.
gradle.taskGraph.whenReady {
    val buildingRelease = allTasks.any { it.name.contains("Release") }
    if (buildingRelease) {
        check(keystorePropertiesFile.exists()) {
            "Manca android/key.properties: la build di release richiede il keystore (vedi RELEASE_CHECKLIST.md)."
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Libreria di desugaring per le API java.time usate da
    // flutter_local_notifications sui dispositivi Android più vecchi.
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
