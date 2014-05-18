# -*- coding: utf-8 -*-
from unicodedata import normalize
"""
if __name__ == "__main__":
    from sys import argv
    FileName=argv[1]
    precomposed=int(argv[2])#whether or not file composed

def second_pass(file_TeX1,precomposed):
    if precomposed:
        for line in file_TeX1n:
            print normalize("NFD",line)
    else:
        for line in file_Tex1:
            print normalize("NFC",line)

/Library/Frameworks/Python.framework/Versions/2.7/Resources/Python.app/Contents/MacOS/Python: can't open file '++enc=utf-8': [Errno 2] No such file or directory
"""
def other_pass(INPUT_STRING):
    string1, string2 ='','' 
    count=1
    for char in INPUT_STRING:
        string1+="\(" + char + "\)"
        string2+="\\" + str(count) + " " + normalize("NFD",char)

        count += 1
        if count == 10:
            count = 1
            print "/" + string1 + "/" , string2 +"/"
            string1, string2 ='','' 
    print "/" + string1 + "/" +string2 +"/"

        
INPUT = u"כּײַאָפּאַפֿשׂתּוּיִבֿ"
#INPUT = open(FileName, "r")
#other_pass(INPUT)
print normalize("NFD",INPUT)
print normalize("NFC",INPUT)
