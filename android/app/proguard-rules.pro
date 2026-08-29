# Regole R8 per la build di release.
# Le librerie (google_mobile_ads, in_app_purchase, supabase) portano già le
# proprie regole consumer; qui si aggiunge solo ciò che manca.

# Google Play Billing: le classi vengono raggiunte per riflessione dal plugin.
-keep class com.android.billingclient.** { *; }
