import unittest

from {{ cookiecutter.package_name }} import {{cookiecutter.command_line_interface_bin_name}}


class TestFunMethod(unittest.TestCase):
    def test_bla(self):
        r = {{cookiecutter.command_line_interface_bin_name}}.fun()
        self.assertEqual(r, 0)


if __name__ == '__main__':
    unittest.main()
