"""Set up the test environment."""
import os
from .const import ENV_CONF_PROFILE
os.environ[ENV_CONF_PROFILE] = "test"
