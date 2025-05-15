from django.urls import path
from . import views
from .views import health_check




urlpatterns = [
    path("", views.current_weather, name="current_weather"),
    path("health/", health_check),
]

# urlpatterns = [
#     path("", health_check),
#     #path("weather/", views.current_weather, name="current_weather"),
# ]