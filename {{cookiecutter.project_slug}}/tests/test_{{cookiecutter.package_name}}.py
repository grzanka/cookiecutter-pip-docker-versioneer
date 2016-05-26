import unittest
import os

from {{ cookiecutter.package_name }} import {{cookiecutter.command_line_interface_bin_name}}


class TestFunMethod(unittest.TestCase):
    def test_check(self):
        r = {{cookiecutter.command_line_interface_bin_name}}.check()
        self.assertIn(r, [True, False])

    def test_process_output(self):
        if os.name in ['posix']:
            r = {{cookiecutter.command_line_interface_bin_name}}.process_output_linux()
        else:
            r = {{cookiecutter.command_line_interface_bin_name}}.process_output_windows()
        self.assertGreater(len(r), 1)

    def test_pid(self):
        r = {{cookiecutter.command_line_interface_bin_name}}.most_cpu_pid()
        self.assertGreater(r, 1)

if __name__ == '__main__':
    unittest.main()
