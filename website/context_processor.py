
def testbed_tag(request):
    from django.conf import settings
    return {'TESTBED': settings.TESTBED}
