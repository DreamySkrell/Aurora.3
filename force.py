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

                    n_old = n
                    n_new = n
                    if n in range(5, 10):
                        n_new = n*2.25
                    elif n in range(10, 20):
                        n_new = n*1.5
                    elif n in range(20, 30):
                        n_new = n*1.25
                    elif n in range(30, 40):
                        n_new = n*1.1

                    print(n_old, ' -> ', n_new)

                    with open(file_full_path, 'r') as file:
                        filedata = file.read()
                    filedata = filedata.replace(res.group(0), '\t@@force = '+str(n_new)+'@@')
                    with open(file_full_path, 'w') as file:
                        file.write(filedata)
        except Exception as e:
            continue

# @@(force = (([0-9]*[.])?[0-9]+))@@
