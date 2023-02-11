import random
import matplotlib.pyplot as plt
import math
import numpy as np


def efold(currentMultiverse):
    allF = [k for k in currentMultiverse if 'F' in k]
    if len(allF) > 0:
        count = random.choice(range(0, len(allF)))
    else:
        count = 0
        return "AllTrue"
    selected = random.sample(allF, k=count)
    result = []
    for item in currentMultiverse:
        if item in selected:
            result.append(item)
        else:
            result.append(item.replace('F', 'T'))
    # print(result)
    return result


def MutliverseExpansion(multiverse):
    expansionResult = []
    for item in multiverse:
        for index in range(0, 9):
            temp = item + str(index)
            expansionResult.append(temp)
    return expansionResult


if __name__ == '__main__':
    init = []
    FCountList = []
    TCountList = []
    RatioFTList = []
    for item in range(0, 9):
        init.append("F" + str(item))

    f = open('Multiverse.txt', 'w')
    for item in range(0, 5):
        print("Step: " + str(item))
        efoldResult = efold(init)
        if efoldResult == "AllTrue":
            print("All True")
        else:
            allT = [k for k in efoldResult if 'T' in k]
            allF = [k for k in efoldResult if 'F' in k]
            FCountList.append(len(allF))
            TCountList.append(len(allT))
            RatioFTList.append(len(allF) / len(allT))
            percent = len(allT) / len(efoldResult)
            print("Percent: " + str(percent))
            print("number of T: " + str(len(allT)))
            print("number of F: " + str(len(allF)))
            init = MutliverseExpansion(efoldResult)
            f.write("\n")
            f.write("====== step: " + str(item) + "============" + str(percent) + "=================\n")
            f.write(str(efoldResult))
            f.write("\n****************************************************\n")
            # f.writelines(str(init))
    f.close()
    map = []
    for index, y in enumerate(RatioFTList):
        map.append(y * math.exp(2*(index + 1)))
    plt.plot(range(len(RatioFTList)), map, marker='^')
    # Show the boundary between the regions:
    # theta = np.arange(0, 5, 1)
    # fit = []
    # for index, y in enumerate(theta):
    #     fit.append(math.exp(y))
    # plt.plot(theta, fit)
    plt.show()