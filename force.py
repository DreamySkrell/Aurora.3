import os
import re
import pathlib

def get_trailing_number(s):
    m = re.search(r'([0-9]+[.])?[0-9]+$', s)
    if m:
        return float(m.group())
    return None

# regex = re.compile('(.*zip$)|(.*rar$)|(.*r01$)')
rx = r'\tforce = (([0-9]*[.])?[0-9]+)'
# rx = '(force)'

for root, dirs, files in os.walk("D:/Git/Aurora.3"):
    for filename in files:
        if not filename.endswith('.dm'):
            continue
        file_full_path = os.path.join(root, filename)
        # print(filename)
        try:
            file_str = pathlib.Path(file_full_path).read_text()
            for res in re.finditer(rx, file_str):
                if res.group(0):
                    print("--",filename,'\t\t',res.group(0))
                    n = get_trailing_number(res.group(0))
                    print("####", n)

                    with open(file_full_path, 'r') as file:
                        filedata = file.read()
                    filedata = filedata.replace(res.group(0), '\tforce = '+(n*2))
                    with open(file_full_path, 'w') as file:
                        file.write(filedata)
        except Exception as e:
            continue
