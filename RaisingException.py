# raise KeyboardInterrupt

# raise MemoryError("this memory Error")

# try:
#     num=int(input("Enter a positive no."))
#     if num<=0:
#         raise MemoryError("Error: RAM Storage not available")
# except MemoryError as e:
#     print(e)

# try:
#     num=int(input("Enter a positive no."))
#     if num<=0:
#         raise MemoryError("Error: RAM Storage not available")
# except MemoryError as e:
#     print(e)
import os
os.chdir("C:/Users/272785/OneDrive - UST/Desktop/")
try:
    f = open('test.txt')
finally:
    print("final closed")
    f.close()