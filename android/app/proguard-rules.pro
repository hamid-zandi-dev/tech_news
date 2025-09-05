# Flutter-specific ProGuard rules
# Keep all Flutter classes
-keep class io.flutter.** { *; }
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep annotation classes
-keepattributes *Annotation*

# Keep enum classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Parcelable classes
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Keep Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep Google Play Core classes (needed for Flutter)
-keep class com.google.android.play.core.** { *; }

# Keep Dio/HTTP classes
-keep class okhttp3.** { *; }
-keep class retrofit2.** { *; }
-keep class com.google.gson.** { *; }

# Keep SQLite classes
-keep class org.sqlite.** { *; }

# Keep shared preferences
-keep class android.content.SharedPreferences { *; }

# Disable aggressive optimizations that might break Flutter
-dontoptimize
-dontobfuscate
-dontpreverify

# Disable warnings for missing classes
-dontwarn com.google.android.play.core.**
-dontwarn okhttp3.**
-dontwarn retrofit2.**
-dontwarn org.sqlite.**