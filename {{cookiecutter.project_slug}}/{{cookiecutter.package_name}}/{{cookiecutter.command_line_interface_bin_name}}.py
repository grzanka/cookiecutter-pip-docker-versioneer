import argparse

import numpy as np
import subprocess

def psaux_output(verbose=False):
    out_bytes = subprocess.check_output(["ps", "aux"])
    out_text = out_bytes.decode('ascii')
    tmp_list = []
    for line in out_text.split("\n")[1:]:
        items = line.split()
        if len(items) > 10:
            pid = int(items[1])
            cpu = float(items[2])
            command = " ".join(items[10:])
            tmp_list.append((pid, cpu, command))
            if verbose:
                print("pid", pid, "cpu", cpu, command)
    dtype = [('pid', int), ('cpu', float), ('name', 'S1000')]
    tmp_array = np.array(tmp_list, dtype=dtype)
    return tmp_array

def most_cpu_pid(verbose=False):
    outp = psaux_output(verbose)
    x = np.sort(outp, kind="mergesort", order="cpu")
    most_cpu_item = x[-1]
    if verbose:
        print("=" * 100)
        print("Most CPU consuming item", most_cpu_item["pid"], most_cpu_item["cpu"], most_cpu_item["name"])
    pid = most_cpu_item["pid"]
    return pid


def check(verbose=False):
    pid = most_cpu_pid()
    d = 2
    prime = True
    while d <= int(pid ** 0.5):
        if pid % d == 0:
            prime = False
            print(d)
            break
        d += 1
    return prime


def main():
    import {{ cookiecutter.package_name }}
    parser = argparse.ArgumentParser()
    parser.add_argument('--verbose',
                        action='store_true',
                        help='be verbose')
    parser.add_argument('--version',
                        action='version',
                        version={{ cookiecutter.package_name }}.__version__)
    args = parser.parse_args()

    isprime = check(verbose=args.verbose)

    if isprime:
        print("Its prime")
    else:
        print("Its not prime")


if __name__ == '__main__':
    main()
