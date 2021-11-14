import os

with open('compile.sh', "rb") as f:
    data = bytearray(os.path.getsize('compile.sh'))
    f.readinto(data)
    data = data.replace(b"\r\n", b"\n")

with open('compile.sh', "wb") as f:
    f.write(data)