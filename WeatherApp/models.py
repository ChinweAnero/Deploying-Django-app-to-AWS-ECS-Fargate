from django.db import models


class Worldcities(models.Model):
    objects = None
    city = models.TextField(blank=True, null=True)
    city_ascii = models.TextField(blank=True, null=True)
    lat = models.TextField(blank=True, null=True)  # This field type is a guess.
    lng = models.TextField(blank=True, null=True)  # This field type is a guess.
    country = models.TextField(blank=True, null=True)
    iso2 = models.TextField(blank=True, null=True)
    iso3 = models.TextField(blank=True, null=True)
    admin_name = models.TextField(blank=True, null=True)
    capital = models.TextField(blank=True, null=True)
    population = models.TextField(blank=True, null=True)
    id = models.TextField(blank=True, primary_key=True)

    class Meta:
        managed = False
        db_table = 'worldcities'
