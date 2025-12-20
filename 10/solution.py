file = open("input.txt", 'r')

content = file.read()

file.close()

lines = content.split("\n")

def press_button(current, buttons):
    for i in buttons:
        current[i] = not current[i]
    return current

def press_button2(current, buttons):
    for i in buttons:
        current[i] += 1
    return current

def works(current, requirements):
    ret = True;
    for i in range(len(requirements)):
        if current[i] > requirements[i]:
            ret = False
            break
    return ret

sum = 0
sum2 = 0

line_count = 0

for line in lines:
    if line == '':
        continue
    index1 = line.find("]")
    index2 = line.find("{")
    first = line[1:index1]
    second = line[index1+2:index2-1]
    third = line[index2+1:-1]
    requirements = [i == '#' for i in first]
    buttons = [[int(k) for k in i[1:-1].split(',')] for i in second.split(" ")]
    requirements2 = [int(i) for i in third.split(",")]
    queue = [[False for i in requirements]]
    i = 0
    found = False
    queue2 = [[0 for i in requirements2]]
    while True:
        new_queue = []
        if found:
            break
        for q in queue:
            if found:
                break
            for b in buttons:
                if found:
                    break
                result = press_button(q.copy(), b)
                if result == requirements:
                    found = True
                if result not in new_queue:
                    new_queue.append(result)
        i = i + 1
        queue = new_queue
    sum += i
    i = 0
    found = False
    # while True:
    #     new_queue2 = []
    #     if found:
    #         break
    #     for q in queue2:
    #         if found:
    #             break
    #         for b in buttons:
    #             if found:
    #                 break
    #             result = press_button2(q.copy(), b)
    #             # print(result)
    #             if result == requirements2:
    #                 found = True
    #             if result not in new_queue2 and works(result, requirements2):
    #                 new_queue2.append(result)
    #     i = i + 1
    #     queue2 = new_queue2
    #     print(i, len(queue2))
    # sum2 += i
    # line_count += 1
    # print(line_count, i)

print('Part 1 answer:', sum)
# print('Part 2 answer:', sum2)
