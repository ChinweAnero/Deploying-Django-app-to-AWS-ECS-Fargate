# weather/views.py

from django.shortcuts import render
import requests
from django.http import JsonResponse

ICON_MAP = {
    0: "☀️",   # Clear sky
    1: "🌤️",  # Mainly clear
    2: "⛅",   # Partly cloudy
    3: "☁️",  # Overcast
    45: "🌫️",  # Fog
    51: "🌦️",  # Drizzle
    61: "🌧️",  # Rain
    71: "❄️",  # Snow
    95: "⛈️",  # Thunderstorm
}



def current_weather(request):
    city = request.GET.get("city", "London")
    context = {"city": city}

    geo_url = f"https://geocoding-api.open-meteo.com/v1/search?name={city}&count=1"
    geo_res = requests.get(geo_url).json()
    results = geo_res.get("results")

    if not results:
        context["error"] = f"City '{city}' not found."
        return render(request, "weather/WeatherApp.html", context)

    lat = results[0]["latitude"]
    lon = results[0]["longitude"]

    weather_url = (
        f"https://api.open-meteo.com/v1/forecast?latitude={lat}&longitude={lon}&"
        f"current_weather=true"
    )
    weather_res = requests.get(weather_url).json()
    current = weather_res["current_weather"]

    context["temp"] = current["temperature"]
    context["icon"] = ICON_MAP.get(current["weathercode"], "❓")

    return render(request, "weather/WeatherApp.html", context)

def health_check(request):
    return JsonResponse({'status': 'ok'})
