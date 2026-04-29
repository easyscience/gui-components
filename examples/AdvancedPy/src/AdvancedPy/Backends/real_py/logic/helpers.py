# SPDX-FileCopyrightText: 2024 EasyApplication contributors
# SPDX-License-Identifier: BSD-3-Clause
# © 2024 Contributors to the EasyApplication project <https://github.com/easyscience/EasyApplication>

class IO:

    @staticmethod
    def format_msg(type, *args):
        types = {'main': '*', 'sub': '  -'}
        mark = types[type]
        widths = [22,21,20,10]
        widths[0] -= len(mark)
        msgs = []
        for idx, arg in enumerate(args):
            msgs.append(f'{arg:<{widths[idx]}}')
        msg = ' ▌ '.join(msgs)
        msg = f'{mark} {msg}'
        return msg


class DottyDict:

    @staticmethod
    def get(obj, path):
        *path, last = path.split(".")
        for bit in path:
            obj = obj.setdefault(bit, {})
        return obj[last]

    @staticmethod
    def set(obj, path, value):
        *path, last = path.split(".")
        for bit in path:
            obj = obj.setdefault(bit, {})
        obj[last] = value
