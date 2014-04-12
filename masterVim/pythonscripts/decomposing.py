# -*- coding: utf-8 -*-
import sys

FileName=sys.argv[1]


def second_pass(file_TeX1,replacements):
    transform = lambda s: format(s, replacements)
    for line in file_TeX1:
        transform(line)


def format(string, rep):
    #print rep
    for r in rep:
        string = string.replace(r[1],r[0])#swaps replacement order.
        string=string.replace("\n","")
    print string



INPUT = open(FileName, "r")
repl = [["אַ", "אַ"], ["אָ", "אָ"], ["יִ", "יִ"], ["וּ", "וּ"],
        ["שׂ", "שׂ"], ["בֿ", "בֿ"], ["פּ", "פּ"], ["פֿ", "פֿ"],
        ["כּ", "כּ"], ["תּ", "תּ"], ["ײַ","ײַ"]]

second_pass(INPUT,repl)
