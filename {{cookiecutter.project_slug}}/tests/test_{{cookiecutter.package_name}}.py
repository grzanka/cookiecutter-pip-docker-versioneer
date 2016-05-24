import unittest

from {{ cookiecutter.package_name }} import {{cookiecutter.command_line_interface_bin_name}}


class TestFunMethod(unittest.TestCase):
    def test_check(self):
        r = {{cookiecutter.command_line_interface_bin_name}}.check()
        self.assertIn(r, [True, False])

    def test_psaux(self):
        r = {{cookiecutter.command_line_interface_bin_name}}.psaux_output()
        self.assertGreater(len(r), 1)

    def test_pid(self):
        r = {{cookiecutter.command_line_interface_bin_name}}.most_cpu_pid()
        self.assertGreater(r, 1)

if __name__ == '__main__':
    unittest.main()
