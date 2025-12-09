# Keep all classes in Mosambee, Pax, Morefun, and USDK SDKs
-keep class com.mosambee.** { *; }
-keep class com.pax.** { *; }
-keep class com.morefun.** { *; }
-keep class com.usdk.** { *; }

# Keep dependent libraries
-keep class co.nstant.in.cbor.** { *; }
-keep class com.google.common.** { *; }
-keep class com.google.zxing.** { *; }

# Don’t warn about missing references (to avoid “Missing class…”)
-dontwarn com.mosambee.**
-dontwarn com.pax.**
-dontwarn com.morefun.**
-dontwarn com.usdk.**
-dontwarn co.nstant.in.cbor.**
-dontwarn com.google.common.**
-dontwarn com.google.zxing.**

# Optional: keep annotations (safe default)
-keepattributes *Annotation*
