# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('control', '0002_auto_20150804_1352'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='experimentsensorattribute',
            name='experiment_sensor',
        ),
    ]
