from pathlib import Path

import pytest

TEST_PATH = Path(__file__).resolve().parent


def pytest_collection_modifyitems(items):
    for item in items:
        module_path = item.path.resolve(strict=True).relative_to(TEST_PATH)

        dir_components = module_path.parent.parts
        if "unit" in dir_components:
            item.add_marker(pytest.mark.unit)
        if "integration" in dir_components:
            item.add_marker(pytest.mark.integration)
