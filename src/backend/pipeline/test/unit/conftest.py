import os
import pytest

@pytest.fixture(scope="module", autouse=True)
def set_directory():
    """Sets the working directory to this suite's directory."""

    abspath = os.path.abspath(__file__)
    dname = os.path.dirname(abspath)
    os.chdir(dname)
