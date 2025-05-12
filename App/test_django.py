
import os
import django

try:
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'App.settings')
    django.setup()
    print("✅ Django loaded successfully with App.settings.")
except Exception as e:
    print("❌ Django failed to load.")
    print(f"Error: {e}")
