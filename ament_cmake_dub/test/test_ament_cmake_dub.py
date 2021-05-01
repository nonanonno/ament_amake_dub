import os
import pytest_shell.shell
from pathlib import Path


def _search_workspace(upper_than=2) -> str:
    """
    Search workspace root by finding `install` directory.

    :param int upper_than:
        Search from parents[upper_than] of test directory.
        Default is repository root.
    """
    path = Path(__file__).absolute()
    if upper_than > 0:
        path = path.parents[upper_than - 1]
    for p in path.parents:
        if 'install' in os.listdir(p):
            return str(p)
    assert False, "ament_cmake_dub does not build yet."


WORKSPACE_ROOT = _search_workspace()
PATH_TO_THIS = str(Path(__file__).absolute().parent)


def test_build(bash: pytest_shell.shell.bash):
    """Check if the dub package can be build via ament_cmake_dub."""
    bash.cd(WORKSPACE_ROOT)
    assert bash.run_script_inline([
        'source install/setup.bash',
        f'colcon build --paths {PATH_TO_THIS}/*'
    ]).count('Summary: 1 package finished') > 0
