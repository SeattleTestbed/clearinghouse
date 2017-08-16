def customizable_strings(request):
  from django.conf import settings
  return {
      "TESTBED": settings.TESTBED,
      "TESTBED_URL": settings.TESTBED_URL,
      "TESTBED_DEVELOPERS_MAIL": settings.TESTBED_DEVELOPERS_MAIL,
      "TESTBED_USERS_MAIL": settings.TESTBED_USERS_MAIL,
      "CLEARINGHOUSE": settings.CLEARINGHOUSE,
      "CLEARINGHOUSE_URL": settings.CLEARINGHOUSE_URL,
      "DEMOKIT": settings.DEMOKIT,
}

def options(request):
    """Make variables defined in settings.py available to the template engine."""
    from django.conf import settings
    return {
        # A debug variable is available to the templates via django's
        # 'django.core.context_processors.debug', but only if the request's
        # IP address is listed in the INTERNAL_IPS setting, c.f.:
        # https://docs.djangoproject.com/en/1.9/ref/templates/api/#django-template-context-processors-debug
        "DEBUG" : settings.DEBUG,
        }
