import os
import pytest
from ...auth import init_firebase, get_credentials
from google.cloud import storage

@pytest.fixture(scope="module", autouse=True)
def set_directory():
    """Sets the working directory to this suite's directory."""

    abspath = os.path.abspath(__file__)
    dname = os.path.dirname(abspath)
    os.chdir(dname)

@pytest.fixture(scope="session", autouse=True)
def init_cloud_connections():
    """Initializes the firebase connection."""
    init_firebase()

def pytest_configure():
    """Initializes the storage client."""
    pytest.storage_client: storage.Client = storage.Client(credentials=get_credentials())
