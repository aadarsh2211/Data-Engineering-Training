n= int(input())
count_dic ={}
word_list=[]
for i in range(n):
    word = input()
    word_list.append(word)
    if word in count_dic:
        count_dic[word] +=1
    else:
        count_dic[word] = 1
    
print(len(count_dic))

print(*(count_dic.values()))