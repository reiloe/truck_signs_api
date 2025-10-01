import os

# Default
DJANGO_ENV = os.getenv("DJANGO_ENV", "docker")

if DJANGO_ENV == "production":
    from .production import *
elif DJANGO_ENV == "docker":
    from .test_docker import *
else:
    from .dev import *
