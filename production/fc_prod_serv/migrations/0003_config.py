# -*- coding: utf-8 -*-
# Generated by Django 1.9.7 on 2016-07-04 16:43
from __future__ import unicode_literals

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('fc_prod_serv', '0002_auto_20160629_1447'),
    ]

    operations = [
        migrations.CreateModel(
            name='Config',
            fields=[
                ('settingKey', models.CharField(max_length=20, primary_key=True, serialize=False)),
                ('settingValue', models.CharField(max_length=500)),
            ],
        ),
    ]
