import sys

decodeLog = sys.argv[1]

logFile = open(decodeLog, "r")
logLines = logFile.readlines()
logFile.close()

decodeLines = []
for line in logLines:
    if line.startswith("SINSPEECH_"):
        decodeLines.append(f"{line.strip().split('_', maxsplit=1)[1]}\n")

resultDir = sys.argv[2]

resultFile = open(f"{resultDir}/decode_text.txt", "w")
resultFile.writelines(decodeLines)
resultFile.close()