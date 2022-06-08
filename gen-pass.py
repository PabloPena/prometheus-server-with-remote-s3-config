import sys
import bcrypt

hashed_password = bcrypt.hashpw(sys.argv[1].encode("utf-8"), bcrypt.gensalt())
print(hashed_password.decode())
