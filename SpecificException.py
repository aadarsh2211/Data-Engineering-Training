import sys
lst=['b',0,2]

for entry in lst:
    try:
        print("++++++++++++++++")
        print("value is:", entry)
        k= 1/int(entry)
    except(ValueError):
        print("This is a value Error.")
    except(ZeroDivisionError):
        print("ZeroDivisionError")
    except:
        print("other Error")
print("the reciprocal of", entry, "is", k)