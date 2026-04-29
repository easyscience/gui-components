# SPDX-FileCopyrightText: 2026 EasyScience contributors <https://github.com/easyscience>
# SPDX-License-Identifier: BSD-3-Clause

import os
import sys
from urllib.parse import urlparse

# Utils


def generalize_path(fpath: str) -> str:
    """
    Generalize the filepath to be platform-specific, so all file
    operations can be performed.
    :param URI fpath: URI to the file
    :return URI filename: platform specific URI
    """
    filename = urlparse(fpath).path
    if not sys.platform.startswith('win'):
        return filename
    if filename[0] == '/':
        filename = filename[1:].replace('/', os.path.sep)
    return filename
