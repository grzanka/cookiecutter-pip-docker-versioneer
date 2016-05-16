import argparse

import numpy as np

def fun(big=False):
    if big:
        print("Hej ho")
    print(137)
    x = np.asarray([1, 2, 3, 4])
    print(x)
    return 0


def main():
    import {{ cookiecutter.package_name }}
    parser = argparse.ArgumentParser()
    parser.add_argument('--what',
                        action='store_true',
                        help='please help me !')
    parser.add_argument('--version',
                        action='version',
                        version={{ cookiecutter.package_name }}.__version__)
    args = parser.parse_args()
    fun(big=args.what)


if __name__ == '__main__':
    main()
