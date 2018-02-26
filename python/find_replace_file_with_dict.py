import re

# 1. read dictionary file into a hash
with open('/Users/royceremulla/projects/learn-bash/dict.dat', 'r') as dict, \
        open('/Users/royceremulla/projects/learn-bash/user.dat', 'r') as input:

    mapping = {}
    for line in dict:
        if len(line):
            id, method = line.split()
            mapping[id] = method
            print('Key: {}, Value: {}'.format(id, method))

    for line in input:
        if len(line):
            # productCodes.3900(), "tiny",
            matcher = re.search(r'\.(\d+)\(\), "(\w+)"', line)
            id = matcher.group(1)
            method_small = matcher.group(2)
            method = mapping[id]
            # print('ID: {}, Method: {}'.format(id, method))

            replaced = re.sub(
                r'\.\d+\(\)',
                line,
                'productCodes.{}(): "{}",'.format(method, method_small))

            print(replaced)
